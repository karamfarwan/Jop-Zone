import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:social/layout/cubit/cubit.dart';
import 'package:social/layout/cubit/state.dart';
import 'package:social/models/notification_model.dart';
import 'package:social/models/social_user_model.dart';
import 'package:social/modules/chats/chats_details_screen.dart';
import 'package:social/modules/user/friend_profile.dart';
import 'package:social/shared/components/components.dart';
import 'package:social/shared/styles/colors.dart';

class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      SocialCubit.get(context).getNotification();
      return BlocConsumer<SocialCubit, SocialStates>(
          builder: (context, state) {
            List<NotificationModel> notifications =
                SocialCubit.get(context).notificationModel;
            return Scaffold(
              body: ConditionalBuilder(
                condition: notifications.length > 0,
                builder: (context) => ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    SocialUserModel user = SocialCubit.get(context).user;
                    if (user == null)
                      SocialCubit.get(context)
                          .getUser(notifications[index].senderId);
                    return Column(
                      children: [
                        buildNotification(
                            notifications[index], context, index, user),
                        Divider(
                          height: 1,
                          color: Colors.black,
                        ),
                      ],
                    );
                  },
                  itemCount: notifications.length,
                ),
                fallback: (context) => Center(
                    child: Text(
                  'No notifications yet',
                  style: TextStyle(color: Colors.grey[500], fontSize: 20.0),
                )),
              ),
            );
          },
          listener: (context, state) {});
    });
  }

  Widget buildNotification(
      NotificationModel notification, context, index, SocialUserModel user) {
    return Container(
      color: notification.read
          ? Theme.of(context).scaffoldBackgroundColor
          : Colors.blue[100],
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: defaultColor,
              backgroundImage: NetworkImage('${notification.senderProfile}'),
              radius: 25.0,
            ),
            SizedBox(
              width: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Expanded(
                child: InkWell(
                  // onLongPress: () {
                  //   return  showDialog(
                  //       context: context,
                  //       builder: (context) => AlertDialog(
                  //             backgroundColor: Colors.grey[300],
                  //             actions: [
                  //               Align(
                  //                 child: Row(
                  //                   children: [
                  //                     Icon(
                  //                       Icons.delete,
                  //                       color: Colors.grey,
                  //                     ),
                  //                     SizedBox(
                  //                       width: 15.0,
                  //                     ),
                  //                     InkWell(
                  //                       onTap: () {
                  //                         SocialCubit.get(context)
                  //                             .deleteNotification(
                  //                                 notification.notificationId);
                  //                       },
                  //                       child: Text(
                  //                         'Delete this notification',
                  //                         style: TextStyle(
                  //                             color: Colors.white,
                  //                             fontSize: 20.0),
                  //                       ),
                  //                     ),
                  //                   ],
                  //                 ),
                  //                 alignment: AlignmentDirectional.topStart,
                  //               )
                  //             ],
                  //           ));
                  // },
                  onTap: () {
                    if (notification.contentKey == 'commentPost') {
                      SocialCubit.get(context)
                          .readNotification(notification.notificationId);
                      SocialCubit.get(context).changeBottomNav(0);
                    } else if (notification.contentKey == 'chat') {
                      SocialCubit.get(context)
                          .readNotification(notification.notificationId);
                      navigateTo(
                          context,
                          ChatsDetailsScreen(
                            userModel: user,
                          ));
                      // showToast(text: '${user.name}', state: ToastStates.SUCCESS);
                    } else if (notification.contentKey ==
                        'friendRequestAccepted') {
                      SocialCubit.get(context)
                          .readNotification(notification.notificationId);
                      navigateTo(
                          context,
                          FriendProfile(
                            userUid: notification.senderId,
                          ));
                    } else if (notification.contentKey == 'friendRequest') {
                      SocialCubit.get(context)
                          .readNotification(notification.notificationId);
                      SocialCubit.get(context).changeBottomNav(2);
                    }
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${notification.senderName}',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      Row(
                        children: [
                          Text(
                            '${notification.senderName}',
                            style: Theme.of(context).textTheme.subtitle2,
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          Text(
                            '${notification.content}',
                            style: Theme.of(context).textTheme.subtitle2,

                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Container(
                        height: 0.7,
                        decoration: BoxDecoration(boxShadow: [
                          BoxShadow(
                            color: Colors.black,

                            blurRadius: 0.5, // soften the shadow

                            spreadRadius: 0.0, //extend the shadow

                            offset: Offset(
                              0.0, // Move to right 10  horizontally

                              0.0, // Move to bottom 10 Vertically
                            ),
                          )
                        ]),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
