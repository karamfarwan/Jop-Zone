

import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/layout/cubit/cubit.dart';

import 'package:social/layout/cubit/state.dart';
import 'package:social/models/notification_model.dart';
import 'package:social/models/social_user_model.dart';

import 'package:social/shared/styles/colors.dart';
import 'package:social/shared/styles/icon_broken.dart';

import '../../models/messege_model.dart';

class ChatsDetailsScreen extends StatelessWidget {
   SocialUserModel userModel;
  NotificationModel notificationModel;

  ChatsDetailsScreen({
    @required this.userModel,
   this.notificationModel,
  });

  var messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        SocialCubit.get(context).getMessages(receiverId: userModel.uId);
        return BlocConsumer<SocialCubit, SocialStates>(
          listener: (context, state) {},
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);

                  },
                  icon: Icon(
                    IconBroken.Arrow___Left_2,
                    color: defaultColor,

                  ),
                ),
                titleSpacing: 0.0,
                title: Row(
                  children: [
                    CircleAvatar(
                      radius: 20.0,
                      backgroundImage: NetworkImage(userModel.image),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text(userModel.name),
                  ],
                ),
              ),
              body: ConditionalBuilder(
                condition: SocialCubit.get(context).messages.length >= 0,
                builder: (context) => Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.separated(
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            var message =
                                SocialCubit.get(context).messages[index];

                            if (SocialCubit.get(context).userModel.uId ==
                                message.senderId)
                              return buildMyMessage(message,context);

                            return buildMessage(message,context);
                          },
                          separatorBuilder: (context, index) => SizedBox(
                            height: 15.0,
                          ),
                          itemCount: SocialCubit.get(context).messages.length,
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: messageController,
                              minLines: 1,
                              maxLines: 2,
                              style: TextStyle(color: Colors.grey),
                              keyboardType: TextInputType.multiline,
                              textInputAction:
                              TextInputAction.newline,
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return 'Comment text must not be empty';
                                } else {
                                  return null;
                                }
                              },
                                decoration: InputDecoration(
                                  fillColor:
                                  Colors.grey.withOpacity(0.3),
                                  filled: true,
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey
                                              .withOpacity(0.3)),
                                     borderRadius:
                                      BorderRadius.circular(
                                          50.0)
                                  ),
                                  contentPadding:
                                  const EdgeInsets.symmetric(
                                      horizontal: 25.0,
                                      vertical: 5.0),
                                  hintText: 'Write your messege ...',
                                  hintStyle: TextStyle(
                                      color: Colors.grey),
                                  border: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(50.0),
                                  ),
                                )
                            ),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          CircleAvatar(
                            backgroundColor: defaultColor,
                            radius: 25.0,
                            child: IconButton(
                              onPressed: () {
                                SocialCubit.get(context).sendMessage(
                                  receiverId: userModel.uId,
                                  dateTime: DateTime.now().toString(),
                                  text: messageController.text,
                                );
                                SocialCubit.get(context).sendAppNotification(
                                    content: ' send a message to you',
                                    contentId: userModel.uId,
                                    contentKey: 'chat',
                                    reseverId: userModel.uId,
                                    reseverName: userModel.name);

                                SocialCubit.get(context).sendNotification(
                                  token: userModel.token,
                                  senderName:
                                  SocialCubit.get(context).userModel.name,
                                  messageText: messageController.text,
                                );
                                messageController.text = '';
                              },
                              icon: Icon(
                                IconBroken.Send,
                                size: 20.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                fallback: (context) => Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget buildMessage(MessageModel model,context) => Align(
        alignment: AlignmentDirectional.centerStart,
        child: Container(
          decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadiusDirectional.only(
                bottomEnd: Radius.circular(10.0),
                topStart: Radius.circular(10.0),
                topEnd: Radius.circular(10.0),
              )),
          padding: EdgeInsets.symmetric(
            vertical: 5.0,
            horizontal: 10.0,
          ),
          child: Text(
            '${model.text}',
            style: Theme.of(context).textTheme.subtitle1.copyWith(color: Colors.black),
          ),
        ),
      );

  Widget buildMyMessage(MessageModel model,context) => Align(
        alignment: AlignmentDirectional.centerEnd,
        child: Container(
          decoration: BoxDecoration(
              color: defaultColor,
              borderRadius: BorderRadiusDirectional.only(
                bottomStart: Radius.circular(10.0),
                topStart: Radius.circular(10.0),
                topEnd: Radius.circular(10.0),
              )),
          padding: EdgeInsets.symmetric(
            vertical: 5.0,
            horizontal: 10.0,
          ),
          child: Text(
            model.text,
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ),
      );
}
