import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social/layout/cubit/state.dart';
import 'package:social/models/comment_model.dart';
import 'package:social/models/messege_model.dart';
import 'package:social/models/notification_model.dart';
import 'package:social/models/post_model.dart';
import 'package:social/models/social_user_model.dart';
import 'package:social/modules/chats/chats_screen.dart';
import 'package:social/modules/feeds/feeds_screen.dart';
import 'package:social/modules/notification/notification_screen.dart';
import 'package:social/modules/social_login/social_login_screen.dart';
import 'package:social/modules/user/all_user.dart';
import 'package:social/modules/user/user_screen.dart';
import 'package:social/shared/components/components.dart';
import 'package:social/shared/components/constants.dart';
import 'package:social/shared/remote/cashe_helper.dart';
import 'package:social/shared/styles/icon_broken.dart';

import '../../shared/components/constants.dart';
import '../../shared/remote/dio_helper.dart';

String profileImageUrl = '';

class SocialCubit extends Cubit<SocialStates> {
  SocialCubit() : super(SocialInitialState());




  static SocialCubit get(context) => BlocProvider.of(context);

 SocialUserModel userModel;

  void getUserData() {
    uId = CacheHelper.getBoolean(key: 'uId');
    FirebaseFirestore.instance.collection('users').doc(uId).get().then((value) {
      //print(value.data());
       userModel = SocialUserModel.fromJson(value.data());
      getUserToken();
      emit(SocialGetUserSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(SocialGetUserErrorState(error.toString()));
    });
  }

  void getUserToken() async {
    emit(SocialGetUserTokenLoadingStates());
    var token = await FirebaseMessaging.instance.getToken();
    print('my token is $token');
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userModel.uId)
        .update({'token': token}).then((value) {
      emit(SocialGetUserTokenSuccessStates());
    });
  }

  int currentIndex = 0;

  List<Widget> screens = [
    FeedsScreen(),
    ChatsScreen(),
    UserScreen(),
    NotificationScreen(),
    AllUserScreen(),
  ];

  List<String> titles = [
    'Home',
    'Chats',
    'Profile',
    'Notification',
    'Friends',
  ];

  void changeBottomNav(int index) {
    if (index == 1) getUsers();
    if (index == 0) {
      if (posts.length == 0) {
        getPosts();
        getComment();
      }
    }

    currentIndex = index;
    emit(SocialChangeBottomNavStates());
  }

 File profileImage;
  var picker = ImagePicker();

  Future<void> getProfileImage() async {
    final pickedFile = await picker.getImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      print(pickedFile.path);
      emit(SocialProfileImagePickedSuccessStates());
    } else {
      print('No image selected.');
      emit(SocialProfileImagePickedErrorStates());
    }
  }

 File coverImage;

  Future<void> getCoverImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      coverImage = File(pickedFile.path);
      print(pickedFile);
      emit(SocialCoverImagePickedSuccessStates());
    } else {
      print('No image selected.');
      emit(SocialCoverImagePickedErrorStates());
    }
  }

  void uploadProfileImage({
    @required String name,
    @required String phone,
    @required String position,
  }) {
    emit(SocialUserUpdateLoadingStates());

    FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(profileImage.path).pathSegments.last}')
        .putFile(profileImage)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        //emit(SocialUploadProfileImageSuccessStates());
        print(value);
        updateUser(name: name, phone: phone, position: position, image: value);
      }).catchError((error) {
        emit(SocialUploadProfileImageErrorStates());
      });
    }).catchError((error) {
      emit(SocialUploadProfileImageErrorStates());
    });
  }

  void uploadCoverImage({
    @required String name,
    @required String phone,
    @required String position,
  }) {
    emit(SocialUserUpdateLoadingStates());

    FirebaseStorage.instance
        .ref()
        .child('users/${Uri.file(coverImage.path).pathSegments.last}')
        .putFile(coverImage)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        //emit(SocialUploadCoverImageSuccessStates());
        print(value);
        updateUser(name: name, phone: phone, position: position, cover: value);
      }).catchError((error) {
        emit(SocialUploadCoverImageErrorStates());
      });
    }).catchError((error) {
      emit(SocialUploadCoverImageErrorStates());
    });
  }

  void updateUser({
    @required String name,
   @required String phone,
    @required String position,
    String cover,
    String image,
  }) {
     SocialUserModel model = SocialUserModel(
      name: name,
      phone: phone,
      position: position,
      email: userModel.email,
      cover: cover ?? userModel.cover,
      image: image ?? userModel.image,
      uId: userModel.uId,
      isEmailVerified: false, token: token,
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel.uId)
        .update(model.toMap())
        .then((value) {
      getUserData();
    }).catchError((error) {
      emit(SocialUserUpdateErrorStates());
    });
  }

   File postImage;

  Future<void> getPostImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      postImage = File(pickedFile.path);
      emit(SocialPostImagePickedSuccessStates());
    } else {
      print('No image selected.');
      emit(SocialPostImagePickedErrorStates());
    }
  }

  void uploadPostImage({
    @required String dateTime,
    @required String text,
  }) {
    emit(SocialCreatePostLoadingStates());

    FirebaseStorage.instance
        .ref()
        .child('posts/${Uri.file(postImage.path).pathSegments.last}')
        .putFile(postImage)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        print(value);
        createPost(
          dateTime: dateTime,
          text: text,
          postImage: value,
        );
        removePostImage();
      }).catchError((error) {
        emit(SocialCreatePostErrorStates());
      });
    }).catchError((error) {
      emit(SocialCreatePostErrorStates());
    });
  }

  void removePostImage() {
    postImage == null;
    emit(SocialRemovePostImage());
  }

  List<MessageModel> messages = [];

  void sendMessage({
    @required String receiverId,
    @required String dateTime,
    @required String text,
  }) {
    MessageModel model = MessageModel(
      text: text,
      senderId: userModel.uId,
      receiverId: receiverId,
      dateTime: dateTime,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .add(model.toMap())
        .then((value) {
      emit(SocialSendMessageSuccessStates());
    }).catchError((error) {
      emit(SocialSendMessageErrorStates());
    });
    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(userModel.uId)
        .collection('messages')
        .add(model.toMap())
        .then((value) {
      emit(SocialSendMessageSuccessStates());
    }).catchError((error) {
      emit(SocialSendMessageErrorStates());
    });
  }

  void getMessages({
    @required String receiverId,
  }) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel.uId)
        .collection('chats')
        .doc(receiverId)
        .collection('messages')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      messages = [];
      event.docs.forEach((element) {
        messages.add(MessageModel.fromJson(element.data()));
      });
      emit(SocialGetMessageSuccessStates());
    });
  }

   SocialUserModel user;

  void getUser(String uid) {
    emit(UserLoadingState());
    FirebaseFirestore.instance.collection('users').doc(uid).get().then((value) {
      user = SocialUserModel.fromJson(value.data());
      emit(UserSuccessState());
    }).catchError((error) {
      emit(UserErrorState());
    });
  }

  List<PostModel> userPosts = [];

  void getUserPosts(String userId) {
    FirebaseFirestore.instance
        .collection('posts')
        .orderBy('dateTime', descending: true)
        .snapshots()
        .listen((event) {
      userPosts = [];
      event.docs.forEach((element) {
        if (element.data()['uId'] == userId) {
          userPosts.add(PostModel.fromJson(element.data()));
        }
      });
      emit(GetUserPostSuccessState());
    });
  }

   PostModel postModel;

  void createPost({
    @required String dateTime,
    @required String text,
    String postImage,
  }) {
    emit(SocialCreatePostLoadingStates());
    PostModel model = PostModel(
      name: userModel.name,
      image: userModel.image,
      uId: userModel.uId,
      dateTime: dateTime,
      text: text,
      postImage: postImage,
      like: 0,
      comment: 0, userModel: userModel, imagePost: postImage,
    );

    FirebaseFirestore.instance
        .collection('posts')
        .add(model.toMap())
        .then((value) {
      emit(SocialCreatePostSuccessStates());
      posts = [];
    }).catchError((error) {
      emit(SocialCreatePostErrorStates());
    });
  }

  List<PostModel> posts = [];
  List<String> postId = [];
  List<int> likes = [];

  void getPosts() {
    // PostModel model = PostModel(
    //   name: userModel.name,
    //   image: userModel.image,
    //   uId: userModel.uId,
    //
    //
    // );
    FirebaseFirestore.instance
        .collection('posts')
        .orderBy('dateTime', descending: true)
        .snapshots()
        .listen((event) async {
      posts = [];
      event.docs.forEach((element) async {
        posts.add(PostModel.fromJson(element.data()));
        postModel = PostModel.fromJson(element.data());
        postId.add(element.id);
        var likes = await element.reference.collection('likes').get();
        var comments = await element.reference.collection('comments').get();
        await FirebaseFirestore.instance
            .collection('posts')
            .doc(element.id)
            .update({
          'like': likes.docs.length,
          'comment': comments.docs.length,
          'postId': element.id
        });
      });
      //print(isLike);
      //getComment();
      emit(SocialGetPostsSuccessState());
    });
  }

  bool isLike = false;

  void isLikePost( String postId) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        if (element.id == userModel.uId) {
          isLike = true;
        } else {
          isLike = false;
        }
       // return  isLike;
      });
    });
  }

  void likePost(String postId) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(userModel.uId)
        .set({
      'like': true,
    }).then((value) {
      isLike = true;
      getPosts();
      emit(SocialLikePostSuccessState());
    }).catchError((error) {
      emit(SocialLikePostErrorState(error.toString()));
    });
  }

  void dislikePost(String postId) {
    // isLike = true;
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(userModel.uId)
        .delete()
        .then((value) {
      isLike = false;
      getPosts();
      emit(SocialDisLikePostSuccessState());
    }).catchError((error) {
      emit(SocialDisLikePostErrorState(error.toString()));
    });
  }

  CommentModel comment;
  List<CommentModel> comments = [];

  void getComment({
    String postId,
  }) {
    // comments = [];
    emit(SocialGetCommentLoadingState());
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .snapshots()
        .listen((event) {
      comments.clear();
      event.docs.forEach((element) {
        comments.add(CommentModel.fromJson(element.data()));
        // getPosts();
        emit(SocialGetCommentSuccessState());
      });
    });
  }

  void addComment({@required String postId, @required String comment,   }) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc()
        .set({
      'image': userModel.image,
      'name': userModel.name,
      'textComment': comment,
      'uId': userModel.uId,
    }).then((value) {
      emit(SocialPostCommentSuccessState());
      getComment(postId: postId);
      getPosts();
      getSinglePost(postId);
    }).catchError((error) {
      emit(SocialPostCommentErrorState(error.toString()));
    });
  }

   PostModel singlePost;

  void getSinglePost(String postId) async {
    emit(SocialGetPostsLoadingState());
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .get()
        .then((value) async {
      singlePost = PostModel.fromJson(value.data());
      emit(SocialGetSinglePostSuccessState());
    }).catchError((error) {
      emit(SocialGetSinglePostErrorState(error.toString()));
    });
  }

  List<SocialUserModel> users = [];

  void getUsers() {
    if (users.length == 0)
      FirebaseFirestore.instance.collection('users').get().then((value) {
        value.docs.forEach((element) {
          if (element.data()['uId'] != userModel.uId)
            users.add(SocialUserModel.fromJson(element.data()));
        });
        emit(SocialGetAllUserSuccessState());
      }).catchError((error) {
        print(error.toString());
        emit(SocialGetAllUserErrorState(error.toString()));
      });
  }

   SocialUserModel friendsProfile;

  void getFriendsProfile(String friendsUid) {
    emit(GetFriendProfileLoadingState());
    FirebaseFirestore.instance.collection('users').snapshots().listen((value) {
      value.docs.forEach((element) {
        if (element.data()['uId'] == friendsUid)
          friendsProfile = SocialUserModel.fromJson(element.data());
      });
      emit(GetFriendProfileSuccessState());
    });
  }

  void addFriendTohim(
      {@required String friendsUid,
      @required String friendName,
      @required bool verify,
      @required String phone,
      @required String cover,
      @required String position,
      @required String email,
      @required String token,
      @required String friendImage}) {
    emit(AddFriendLoadingState());
    SocialUserModel myFriendModel = SocialUserModel(
        image: friendImage,
        name: friendName,
        uId: friendsUid,
        phone: phone,
        isEmailVerified: verify,
        email: email,
        cover: cover,
        token: token,
        position: position);
    SocialUserModel myModel = SocialUserModel(
        uId: userModel.uId,
        name: userModel.name,
        image: userModel.image,
        phone: userModel.phone,
        email: userModel.email,
        cover: userModel.cover,
        position: userModel.position,
        token: userModel.token,
        isEmailVerified: userModel.isEmailVerified);
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel.uId)
        .collection('friends')
        .doc(friendsUid)
        .set(myFriendModel.toMap())
        .then((value) {
      emit(AddFriendSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(AddFriendErrorState());
    });
  }

  void addFriendToMe(
      {@required String friendsUid,
      @required String friendName,
      @required bool verify,
      @required String phone,
      @required String cover,
      @required String position,
      @required String token,
      @required String email,
      @required String friendImage}) {
    emit(AddFriendLoadingState());
    SocialUserModel myFriendModel = SocialUserModel(
      image: friendImage,
      name: friendName,
      uId: friendsUid,
      phone: phone,
      isEmailVerified: verify,
      email: email,
      cover: cover,
      position: position,
      token: token,
    );
    SocialUserModel myModel = SocialUserModel(
        uId: userModel.uId,
        name: userModel.name,
        image: userModel.image,
        phone: userModel.phone,
        email: userModel.email,
        cover: userModel.cover,
        position: userModel.position,
        token: userModel.token,
        isEmailVerified: userModel.isEmailVerified);
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel.uId)
        .collection('friends')
        .doc(friendsUid)
        .set(myFriendModel.toMap())
        .then((value) {
      emit(AddFriendSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(AddFriendErrorState());
    });
    // FirebaseFirestore.instance
    //     .collection('users')
    //     .doc(friendsUid)
    //     .collection('friends')
    //     .doc(userModel.uId)
    //     .set(myModel.toMap())
    //     .then((value) {
    //   emit(AddFriendSuccessState());
    // }).catchError((error) {
    //   print(error.toString());
    //   emit(AddFriendErrorState());
    // });
  }

  List<SocialUserModel> friends = [];

  void getFriends(String userUid) {
    emit(GetFriendLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(userUid)
        .collection('friends')
        .snapshots()
        .listen((value) {
      friends = [];
      value.docs.forEach((element) {
        friends.add(SocialUserModel.fromJson(element.data()));
      });
      emit(GetFriendSuccessState());
    });
  }

  bool isFriend = false;

  bool checkFriends(String friendUid) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel.uId)
        .collection('friends')
        .snapshots()
        .listen((value) {
      isFriend = false;
      value.docs.forEach((element) {
        if (friendUid == element.id) isFriend = true;
      });
      emit(CheckFriendState());
    });
    return isFriend;
  }

  void unFriend(String friendsUid) {
    emit(UnFriendLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel.uId)
        .collection('friends')
        .doc(friendsUid)
        .delete()
        .then((value) {
      emit(UnFriendSuccessState());
    }).catchError((error) {
      emit(UnFriendErrorState());
      print(error.toString());
    });
    FirebaseFirestore.instance
        .collection('users')
        .doc(friendsUid)
        .collection('friends')
        .doc(userModel.uId)
        .delete()
        .then((value) {
      emit(UnFriendSuccessState());
    }).catchError((error) {
      emit(UnFriendErrorState());
      print(error.toString());
    });
  }

  void sendFriendRequest(
      {@required String friendsUid,
      @required String friendName,
      @required String friendImage}) {
    emit(FriendRequestLoadingState());
    SocialUserModel friendRequestModel = SocialUserModel(
        uId: userModel.uId,
        name: userModel.name,
        image: userModel.image,
        position: userModel.position,
        cover: userModel.cover,
        email: userModel.email,
        token: userModel.token,
        isEmailVerified: userModel.isEmailVerified,
        phone: userModel.phone);
    FirebaseFirestore.instance
        .collection('users')
        .doc(friendsUid)
        .collection('friendRequests')
        .doc(userModel.uId)
        .set(friendRequestModel.toMap())
        .then((value) {
      emit(FriendRequestSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(FriendRequestErrorState());
    });
  }

  List<SocialUserModel> friendRequests = [];

  void getFriendRequest() {
    emit(GetFriendLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel.uId)
        .collection('friendRequests')
        .snapshots()
        .listen((value) {
      friendRequests = [];
      value.docs.forEach((element) {
        friendRequests.add(SocialUserModel.fromJson(element.data()));
        emit(GetFriendSuccessState());
      });
    });
  }

  bool request = false;

  bool checkFriendRequest(String friendUid) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(friendUid)
        .collection('friendRequests')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        if (element.data()['uId'] == userModel.uId)
          request = true;
        else
          request = false;
      });
      emit(CheckFriendRequestState());
    });
    return request;
  }

  void deleteFriendRequest(String friendsUid) {
    emit(DeleteFriendRequestLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel.uId)
        .collection('friendRequests')
        .doc(friendsUid)
        .delete()
        .then((value) {
      emit(DeleteFriendRequestSuccessState());
    }).catchError((error) {
      emit(DeleteFriendRequestErrorState());
      print(error.toString());
    });
  }

   List<SocialUserModel> searchUserModel;
  Map<String, dynamic> search;

  void searchUser(String searchText) {
    emit(SocialSearchUserLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .where('name', isEqualTo: searchText)
        .get()
        .then((value) {
      search = value.docs[0].data();
      emit(SocialSearchUserSuccessState());
      // searchUserModel = SocialUserModel.fromJson(value.da)
    }).catchError((error) {
      emit(SocialSearchUserErrorState());
    });
  }

///////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////
  ////////////////////////////////////////
  void sendNotification(
      {@required String token,
      @required String senderName,
      String messageText,
      String messageImage}) {
    DioHelper.postSocialData(data: {
      "to": "$token",
      "notification": {
        "title": "$senderName",
        "body":
            "${messageText != null ? messageText : messageImage != null ? messageImage : 'ERROR 404'}",
        "sound": "default"
      },
      "android": {
        "Priority": "HIGH",
        "notification": {
          "notification_Priority": "PRIORITY_MAX",
          "sound": "default",
          "default_sound": true,
          "default_vibrate_timings": true,
          "default_light_settings": true
        }
      },
      "data": {
        "type": "order",
        "id": "87",
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "navigation": "chatDetails"
      }
    });
    emit(SendNotificationSuccessState());
  }

  void sendAppNotification({
    String content,
    String contentId,
    String contentKey,
    String notificationId,
    String reseverId,
    String reseverName,
  }) {
    emit(SendAppNotificationLoadingState());
    NotificationModel notificationModel = NotificationModel(
        content: content,
        contentId: contentId,
        contentKey: contentKey,
        notificationId: notificationId,
        reseverid: reseverId,
        reseverName: reseverName,
        senderId: userModel.uId,
        senderName: userModel.name,
        senderProfile: userModel.image,
        serverTimeStamp: FieldValue.serverTimestamp(),
        read: false,
        dateTime: Timestamp.now());
    FirebaseFirestore.instance
        .collection('users')
        .doc(reseverId)
        .collection('notification')
        .add(notificationModel.toMap())
        .then((value) async {
      await setNotificationId();
      emit(SendAppNotificationSuccessState());
    }).catchError((error) {
      emit(SendAppNotificationErrorState());
    });
  }

   setNotificationId() async {
    await FirebaseFirestore.instance.collection('users').get().then((value) {
      value.docs.forEach((element) async {
        var notifications =
            await element.reference.collection('notification').get();
        notifications.docs.forEach((notificationsElement) async {
          await notificationsElement.reference
              .update({'notificationId': notificationsElement.id});
        });
      });
      emit(SetNotificationIdSuccessState());
    });
  }

  List<NotificationModel> notificationModel = [];

  void getNotification() {
    emit(GetNotificationIdLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel.uId)
        .collection('notification')
        .orderBy('serverTimeStamp', descending: true)
        .snapshots()
        .listen((event) {
      notificationModel = [];
      event.docs.forEach((element) {
        if (element.data()['reseverid'] == userModel.uId) {
          if (element.data()['senderId'] != userModel.uId)
            notificationModel.add(NotificationModel.fromjson(element.data()));
        }
      });
      emit(GetNotificationIdSuccessState());
    });
  }

  int unReadNotificationsCount = 0;

  Future<int> getUnReadNotificationsCount(String uId) async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(uId)
        .collection('notification')
        .snapshots()
        .listen((event) {
      unReadNotificationsCount = 0;
      for (int i = 0; i < event.docs.length; i++) {
        if (event.docs[i]['read'] == false) unReadNotificationsCount++;
      }
      emit(UnReadNotificationSuccessState());
      print("UnRead: " + '$unReadNotificationsCount');
    });

    return unReadNotificationsCount;
  }

  Future readNotification(String notificationId) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userModel.uId)
        .collection('notification')
        .doc(notificationId)
        .update({'read': true}).then((value) {
      emit(ReadNotificationSuccessState());
    });
  }

  void deleteNotification(String notificationId) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userModel.uId)
        .collection('notification')
        .doc(notificationId)
        .delete()
        .then((value) {
      emit(DeleteNotificationSuccessState());
    });
  }

  String notificationContent(String contentKey) {
    if (contentKey == 'likePost')
      return 'likePost';
    else if (contentKey == 'commentPost')
      return 'commentPost';
    else if (contentKey == 'friendRequest')
      return 'friendRequest';
    else if (contentKey == 'friendRequestAccepted')
      return 'friendRequestAccepted';
    else if (contentKey == 'chat')
      return 'chat';
    else
      return 'friendRequestNotify';
  }

  IconData notificationContentIcon(String contentKey) {
    if (contentKey == 'likePost')
      return IconBroken.Heart;
    else if (contentKey == 'commentPost')
      return IconBroken.Chat;
    else if (contentKey == 'friendRequestAccepted')
      return Icons.person;
    else if (contentKey == 'chat')
      return Icons.person;
    else
      return Icons.person;
  }

////////////////////////////////////////////
  ///////////////////////////////
  ///////////////////////////////////////////////////////////////////////////////
  void signOut(context) {
    FirebaseAuth.instance.signOut().then((value) async {
      //friends = [];
      userPosts = [];
      users = [];
      //friendRequests = [];
      //postId = [];
      posts = [];
      likes = [];
      comments = [];
      messages = [];
      uId = '';
      CacheHelper.removeData(key: 'uId');
      await FirebaseMessaging.instance.deleteToken();
      await FirebaseFirestore.instance.collection('users').get().then((value) {
        value.docs.forEach((element) {
          if (element.id == userModel.uId)
            element.reference.update({'token': null});
        });
      });
      navigateAndFinish(context, SocialLoginScreen());

      currentIndex = 0;
      emit(SocialSingOutSuccessStates());
    }).catchError((error) {
      emit(SocialSingOutErrorStates());
    });
    // CacheHelper.removeData(key: 'uId').then((value) {
    //   if (value) {
    //     navigateAndFinish(context, StartScreen());
    //     emit(SignOut());
    //   }
    // }
    // );
  }

  void deletePost(String postId, String userPostId) {
    if (userModel.uId == userPostId) {
      FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .delete()
          .then((value) {
        showToast(text: 'Post Deleted', state: ToastStates.SUCCESS);
        emit(DeletePostSuccessState());
      });
    } else {
      showToast(text: 'You do not have permission', state: ToastStates.ERROR);
    }
  }

  IconData HeartRed = Icons.favorite;

  bool isRed = true;

  void changeColorHeart() {
    isRed = !isRed;
    HeartRed = isRed ? Icons.favorite_border : Icons.favorite;

    emit(SocialChangeColorHeartState());
  }

  bool isDark = false;

  void changeAppMode({bool fromShared}) {
    if (fromShared != null) {
      isDark = fromShared;
      emit(ChangeModeState());
    } else {
      isDark = !isDark;
      CacheHelper.putBoolean(key: 'isDark', value: isDark).then((value) {
        emit(ChangeModeState());
      });
    }
  }
}
