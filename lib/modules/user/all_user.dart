import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:social/layout/cubit/cubit.dart';
import 'package:social/layout/cubit/state.dart';
import 'package:social/models/social_user_model.dart';
import 'package:social/modules/user/friend_profile.dart';
import 'package:social/shared/components/components.dart';
import 'package:social/shared/styles/colors.dart';
import 'package:social/shared/styles/icon_broken.dart';

String friendUid;

class AllUserScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      // print(friendUid);
      SocialCubit.get(context).getFriendRequest();
      SocialCubit.get(context).getUsers();
      SocialCubit.get(context)
          .getFriends(SocialCubit.get(context).userModel.uId);
      SocialCubit.get(context).checkFriends(friendUid);
      return BlocConsumer<SocialCubit, SocialStates>(
          builder: (context, state) => Scaffold(
                body: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Friend Request',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      SizedBox(
                        height: 7.0,
                      ),
                      ConditionalBuilder(
                        condition:
                            SocialCubit.get(context).friendRequests.length > 0,
                        builder: (context) => Expanded(
                          child: ListView.separated(
                              physics: BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) =>
                                  buildFriendRequest(
                                      SocialCubit.get(context)
                                          .friendRequests[index],
                                      context),
                              separatorBuilder: (context, index) => SizedBox(
                                    width: 10.0,
                                  ),
                              itemCount: SocialCubit.get(context)
                                  .friendRequests
                                  .length),
                        ),
                        fallback: (context) => Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0),
                                color: Theme.of(context).cardColor,
                              ),
                              child: Center(
                                child: Text(
                                  'No Friend Requests',
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      .copyWith(fontSize: 25),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Text(
                        'Suggestion',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      ConditionalBuilder(
                        condition: SocialCubit.get(context).users != null,
                        builder: (context) => Expanded(
                          child: ListView.separated(
                              // physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              physics: BouncingScrollPhysics(),
                              itemBuilder: (context, index) =>
                                  buildInviteFriends(
                                    SocialCubit.get(context).users[index],
                                    context,
                                  ),
                              separatorBuilder: (context, index) => SizedBox(
                                    height: 10.0,
                                  ),
                              itemCount: SocialCubit.get(context).users.length),
                        ),
                        fallback: (context) => CircularProgressIndicator(
                          color: defaultColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          listener: (context, state) {});
    });
  }

  Widget buildInviteFriends(
    SocialUserModel model,
    context,
  ) {
    friendUid = model.uId.toString();
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 5.0,
      margin: EdgeInsets.symmetric(
        horizontal: 8.0,
      ),
      child: InkWell(
        onTap: () {
          navigateTo(
              context,
              FriendProfile(
                userUid: model.uId,
              ));
        },
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30.0,
                  backgroundColor: defaultColor,
                  backgroundImage: NetworkImage('${model.image}'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${model.name}',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      Text(
                        '${model.position}',
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    ],
                  ),
                ),
                Spacer(),
                IconButton(
                  onPressed: () {
                    if (SocialCubit.get(context).isFriend == false) {
                      SocialCubit.get(context).sendFriendRequest(
                        friendsUid: model.uId,
                        friendName: model.name,
                        friendImage: model.image,
                      );
                      showToast(
                          text: 'Friend request has been sent successfully',
                          state: ToastStates.SUCCESS);
                      SocialCubit.get(context).sendAppNotification(
                          content: 'sent you a friend request',
                          contentId: model.uId,
                          contentKey: 'friendRequestAccepted',
                          reseverId: model.uId,
                          reseverName: model.name);

                      SocialCubit.get(context).sendNotification(
                        token: model.token,
                        senderName: SocialCubit.get(context).userModel.name,
                        messageText:
                            '${SocialCubit.get(context).userModel.name}' +
                                ' sent you a friend request, check it out',
                      );
                      SocialCubit.get(context).addFriendToMe(
                          friendsUid: model.uId,
                          friendName: model.name,
                          verify: model.isEmailVerified,
                          phone: model.phone,
                          cover: model.cover,
                          position: model.position,
                          email: model.email,
                          friendImage: model.image,
                          token: model.token);
                    } else {
                      SocialCubit.get(context).unFriend(model.uId);
                      SocialCubit.get(context).sendAppNotification(
                          content: 'cancel friendship with you',
                          contentId: model.uId,
                          contentKey: 'friendRequestAccepted',
                          reseverId: model.uId,
                          reseverName: model.name);

                      SocialCubit.get(context).sendNotification(
                        token: model.token,
                        senderName: SocialCubit.get(context).userModel.name,
                        messageText: '${SocialCubit.get(context).userModel.name}' +
                            ' cancel friendship with you,Why did that happen?!',
                      );
                    }
                  },
                  icon: SocialCubit.get(context).isFriend == false
                      ? Icon(
                          IconBroken.Add_User,
                          size: 25,
                          color: defaultColor,
                        )
                      : Icon(
                          IconBroken.Close_Square,
                          size: 25,
                          color: defaultColor,
                        ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildFriendRequest(SocialUserModel friendModel, context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Card(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          elevation: 5.0,
          margin: EdgeInsets.symmetric(
            horizontal: 5.0,
          ),
          child: InkWell(
            onTap: () {
              navigateTo(
                  context,
                  FriendProfile(
                    userUid: friendModel.uId,
                  ));
            },
            child: Container(
              height: 200.0,
              width: 250.0,
              decoration: BoxDecoration(
                // borderRadius: BorderRadius.circular(20),
                borderRadius: BorderRadius.circular(15.0),
                color: Theme.of(context).cardColor,
              ),
              child: Column(
                children: [
                  Image(
                    image: NetworkImage('${friendModel.image}'),
                    height: 170.0,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  Text(
                    '${friendModel.name}',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  Text(
                    '${friendModel.position}',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            SocialCubit.get(context).addFriendTohim(
                                friendsUid: friendModel.uId,
                                friendName: friendModel.name,
                                friendImage: friendModel.image,
                                position: friendModel.position,
                                token: friendModel.token,
                                cover: friendModel.cover,
                                email: friendModel.email,
                                phone: friendModel.phone,
                                verify: friendModel.isEmailVerified);
                            SocialCubit.get(context)
                                .deleteFriendRequest(friendModel.uId);
                            showToast(
                                text: 'You have become friends',
                                state: ToastStates.SUCCESS);
                            SocialCubit.get(context).sendAppNotification(
                                content: 'accept the friend request',
                                contentId:
                                    SocialCubit.get(context).userModel.uId,
                                contentKey: 'friendRequestAccepted',
                                reseverId: friendModel.uId,
                                reseverName: friendModel.name);

                            SocialCubit.get(context).sendNotification(
                              token: friendModel.token,
                              senderName:
                                  SocialCubit.get(context).userModel.name,
                              messageText:
                                  '${SocialCubit.get(context).userModel.name}' +
                                      ' accept the friend request',
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: defaultColor),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Accept',
                                style: TextStyle(
                                    fontSize: 18.0, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 30.0,
                        ),
                        InkWell(
                          onTap: () {
                            SocialCubit.get(context)
                                .deleteFriendRequest(friendModel.uId);
                            SocialCubit.get(context).sendAppNotification(
                                content: 'Reject the friend request ',
                                contentId:
                                    SocialCubit.get(context).userModel.uId,
                                contentKey: 'friendRequestAccepted',
                                reseverId: friendModel.uId,
                                reseverName: friendModel.name);

                            SocialCubit.get(context).sendNotification(
                              token: friendModel.token,
                              senderName:
                                  SocialCubit.get(context).userModel.name,
                              messageText:
                                  '${SocialCubit.get(context).userModel.name}' +
                                      ' Reject the friend request',
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.grey[300]),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Remove',
                                style: TextStyle(
                                    fontSize: 18.0, color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
}
