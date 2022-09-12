import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:social/layout/cubit/cubit.dart';
import 'package:social/layout/cubit/state.dart';
import 'package:social/models/post_model.dart';
import 'package:social/models/social_user_model.dart';
import 'package:social/modules/chats/chats_details_screen.dart';
import 'package:social/modules/comment_screen.dart';
import 'package:social/modules/fullScren.dart';
import 'package:social/shared/components/components.dart';
import 'package:social/shared/styles/colors.dart';
import 'package:social/shared/styles/icon_broken.dart';

class FriendProfile extends StatelessWidget {
  String userUid;

  FriendProfile({this.userUid});

  @override
  Widget build(BuildContext context) {
    // SocialCubit.get(context).getFriendsProfile(userUid);
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return Builder(builder: (context) {
      SocialCubit.get(context).getFriendsProfile(userUid);
      SocialCubit.get(context).checkFriends(userUid);
      SocialCubit.get(context).getUserPosts(userUid);
      SocialCubit.get(context).getFriends(userUid);
      SocialCubit.get(context).getUser(userUid);
      SocialCubit.get(context).getPosts();
      return BlocConsumer<SocialCubit, SocialStates>(
          listener: (context, state) {},
          builder: (context, state) {
            SocialUserModel friendsModel =
                SocialCubit.get(context).friendsProfile;
            return ConditionalBuilder(
              condition: friendsModel != null,
              builder: (context) => Scaffold(
                appBar: AppBar(
                  title: Text('User Profile'),
                  leading: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      IconBroken.Arrow___Left_2,
                      color: defaultColor,
                    ),
                  ),
                ),
                body: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Container(
                          height: 200,
                          child: Stack(
                            alignment: AlignmentDirectional.bottomStart,
                            children: [
                              Align(
                                child: Container(
                                  height: 170.0,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(4.0),
                                      topRight: Radius.circular(4.0),
                                    ),
                                    image: DecorationImage(
                                      image:
                                          NetworkImage('${friendsModel.cover}'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                alignment: AlignmentDirectional.topCenter,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: CircleAvatar(
                                  radius: 65,
                                  backgroundColor:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  child: CircleAvatar(
                                    radius: 60.0,
                                    backgroundImage:
                                        NetworkImage('${friendsModel.image}'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${friendsModel.name}',
                                      style:
                                          Theme.of(context).textTheme.bodyText1,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      '${friendsModel.position}',
                                      style:
                                          Theme.of(context).textTheme.subtitle1,
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: InkWell(
                                        child: Column(
                                          children: [
                                            Text(
                                              '${SocialCubit.get(context).userPosts.length}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1,
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              'Posts',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle2,
                                            ),
                                          ],
                                        ),
                                        onTap: () {},
                                      ),
                                    ),
                                    Expanded(
                                      child: InkWell(
                                        child: Column(
                                          children: [
                                            Text(
                                              '${SocialCubit.get(context).friends.length}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle1,
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              'Friends',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .subtitle2,
                                            ),
                                          ],
                                        ),
                                        onTap: () {},
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: OutlinedButton(
                                  onPressed: () {
                                    if (SocialCubit.get(context).isFriend ==
                                        false) {
                                      SocialCubit.get(context)
                                          .sendFriendRequest(
                                        friendsUid: friendsModel.uId,
                                        friendName: friendsModel.name,
                                        friendImage: friendsModel.image,
                                      );
                                      showToast(
                                          text:
                                              'Friend request has been sent successfully',
                                          state: ToastStates.SUCCESS);
                                      SocialCubit.get(context)
                                          .sendAppNotification(
                                              content:
                                                  'sent you a friend request',
                                              contentId: friendsModel.uId,
                                              contentKey:
                                                  'friendRequestAccepted',
                                              reseverId: friendsModel.uId,
                                              reseverName: friendsModel.name);

                                      SocialCubit.get(context).sendNotification(
                                        token: friendsModel.token,
                                        senderName: SocialCubit.get(context)
                                            .userModel
                                            .name,
                                        messageText:
                                            '${SocialCubit.get(context).userModel.name}' +
                                                ' sent you a friend request, check it out',
                                      );
                                      SocialCubit.get(context).addFriendToMe(
                                          friendsUid: friendsModel.uId,
                                          friendName: friendsModel.name,
                                          verify: friendsModel.isEmailVerified,
                                          phone: friendsModel.phone,
                                          cover: friendsModel.cover,
                                          position: friendsModel.position,
                                          email: friendsModel.email,
                                          friendImage: friendsModel.image,
                                          token: friendsModel.token);
                                    } else {
                                      SocialCubit.get(context)
                                          .unFriend(friendsModel.uId);
                                      SocialCubit.get(context)
                                          .sendAppNotification(
                                              content:
                                                  'cancel friendship with you',
                                              contentId: friendsModel.uId,
                                              contentKey:
                                                  'friendRequestAccepted',
                                              reseverId: friendsModel.uId,
                                              reseverName: friendsModel.name);

                                      SocialCubit.get(context).sendNotification(
                                        token: friendsModel.token,
                                        senderName: SocialCubit.get(context)
                                            .userModel
                                            .name,
                                        messageText:
                                            '${SocialCubit.get(context).userModel.name}' +
                                                ' cancel friendship with you,Why did that happen?!',
                                      );
                                    }
                                  },
                                  child: SocialCubit.get(context).isFriend ==
                                          false
                                      ? Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 50.0),
                                          child: Row(
                                            children: [
                                              Icon(
                                                IconBroken.Add_User,
                                                size: 20,
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                'Add Friend',
                                                style:
                                                    TextStyle(fontSize: 15.0),
                                              ),
                                            ],
                                          ),
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 55.0),
                                          child: Row(
                                            children: [
                                              Icon(
                                                IconBroken.Close_Square,
                                                size: 20,
                                              ),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                'Unfriend',
                                                style:
                                                    TextStyle(fontSize: 15.0),
                                              ),
                                            ],
                                          ),
                                        ),
                                ),
                              ),
                            ),
                            OutlinedButton(
                              onPressed: () {
                                navigateTo(
                                  context,
                                  ChatsDetailsScreen(
                                    userModel: friendsModel,
                                  ),
                                );
                              },
                              child: Icon(
                                IconBroken.Chat,
                                size: 30,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: OutlinedButton(
                                onPressed: () {},
                                child: Icon(
                                  IconBroken.Message,
                                  size: 30,
                                ),
                              ),
                            )
                          ],
                        ),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) => buildPostItem(
                              SocialCubit.get(context).userPosts[index],
                              context,
                              index),
                          separatorBuilder: (context, index) => SizedBox(
                            height: 8.0,
                          ),
                          itemCount: SocialCubit.get(context).userPosts.length,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              fallback: (context) => Center(
                child: CircularProgressIndicator(),
              ),
            );
          });
    });
  }

  Widget buildPostItem(PostModel postmodel, context, index) => Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        elevation: 5.0,
        margin: EdgeInsets.symmetric(
          horizontal: 8.0,
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 5.0,
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 20.0,
                              backgroundImage:
                                  NetworkImage('${postmodel.image}'),
                            ),
                            SizedBox(
                              width: 15.0,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '${postmodel.name}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText1,
                                      ),
                                      // SizedBox(
                                      //   width: 5.0,
                                      // ),
                                      // Icon(
                                      //   Icons.check_circle,
                                      //   color: defaultColor,
                                      //   size: 16.0,
                                      // )
                                    ],
                                  ),
                                  // Text(
                                  //   '${postmodel.dateTime}',
                                  //   style: Theme.of(context)
                                  //       .textTheme
                                  //       .caption
                                  //       .copyWith(
                                  //     height: 1.3,
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 15.0,
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        navigateTo(
                            context,
                            FriendProfile(
                              userUid: postmodel.uId,
                            ));
                      },
                    ),
                  ),
                  IconButton(
                      icon: Icon(
                        Icons.more_horiz,
                        size: 25.0,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  backgroundColor: Colors.white,

                                  // alignment: AlignmentDirectional.bottomEnd,

                                  actions: [
                                    Align(
                                      alignment: AlignmentDirectional.topStart,
                                      child: InkWell(
                                        onTap: () {
                                          SocialCubit.get(context).deletePost(
                                              SocialCubit.get(context)
                                                  .postId[index],
                                              postmodel.uId);
                                        },
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.delete,
                                              color: defaultColor,
                                            ),
                                            SizedBox(
                                              width: 15.0,
                                            ),
                                            Text(
                                              'Delete this post',
                                              style: TextStyle(
                                                  color: defaultColor,
                                                  fontSize: 20.0),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ));
                      })
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 15.0,
                ),
                child: Container(
                  width: double.infinity,
                  height: 0.8,
                  color: Colors.grey,
                ),
              ),
              Text(
                '${postmodel.text}',
                style: Theme.of(context).textTheme.subtitle1,
              ),
              // SizedBox(height: 15.0,),

              if (postmodel.postImage != null)
                Padding(
                  padding: const EdgeInsetsDirectional.only(top: 15.0),
                  child: FullScreenWidget(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4.0),
                      child: Container(
                        height: 300.0,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          image: DecorationImage(
                            image: NetworkImage('${postmodel.postImage}'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 5.0,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 15.0,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                IconBroken.Heart,
                                size: 20,
                                color: Colors.grey,
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                              Text(
                                '${postmodel.like}',
                                // '${SocialCubit.get(context).likes[index]}',
                                style: Theme.of(context).textTheme.subtitle2,
                              ),
                            ],
                          ),
                        ),
                        // onTap: () {},
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 5.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(
                                Icons.comment,
                                size: 20,
                                color: Colors.grey,
                              ),
                              SizedBox(
                                width: 5.0,
                              ),
                              Text(
                                '${postmodel.comment}',
                                style: Theme.of(context).textTheme.subtitle2,
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          SocialCubit.get(context).getComment(
                            postId: SocialCubit.get(context).postId[index],
                          );
                          navigateTo(
                              context,
                              CommentScreen(
                                index,
                                SocialCubit.get(context).posts[index],
                              ));
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Container(
                  width: double.infinity,
                  height: 0.8,
                  color: Colors.grey,
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 18.0,
                            backgroundImage: NetworkImage(
                                '${SocialCubit.get(context).userModel.image}'),
                          ),
                          SizedBox(
                            width: 15.0,
                          ),
                          Text(
                            'write a comment ....',
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
                        ],
                      ),
                      onTap: () {
                        SocialCubit.get(context).getComment(
                          postId: SocialCubit.get(context).postId[index],
                        );
                        navigateTo(
                            context,
                            CommentScreen(
                              index,
                              SocialCubit.get(context).posts[index],
                            ));
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: InkWell(
                      child: Row(
                        children: [
                          // if(state is SocialDisLikePostSuccessState)
                          Icon(
                            IconBroken.Heart,
                            size: 30,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                      onTap: () {
                        SocialCubit.get(context)
                            .likePost(SocialCubit.get(context).postId[index]);
                        if (SocialCubit.get(context).isLike == false) {
                          SocialCubit.get(context)
                              .likePost(SocialCubit.get(context).postId[index]);
                        } else {
                          SocialCubit.get(context).dislikePost(
                            SocialCubit.get(context).postId[index],
                          );
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: InkWell(
                      child: Row(
                        children: [
                          // if(state is SocialDisLikePostSuccessState)
                          Icon(
                            IconBroken.Message,
                            size: 30,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}
