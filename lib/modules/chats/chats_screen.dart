import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/layout/cubit/cubit.dart';
import 'package:social/layout/cubit/state.dart';
import 'package:social/models/social_user_model.dart';
import 'package:social/modules/chats/chats_details_screen.dart';
import 'package:social/shared/components/components.dart';

import '../../models/notification_model.dart';

class ChatsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SocialCubit.get(context).getFriends(SocialCubit.get(context).userModel.uId);
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {

        return ConditionalBuilder(
          condition: SocialCubit.get(context).friends.length > 0,
          builder: (context) => ListView.separated(
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) =>
                buildChatItem(SocialCubit.get(context).friends[index], context),
            separatorBuilder: (context, index) => SizedBox(height: 10),
            itemCount: SocialCubit.get(context).friends.length,
          ),
          fallback: (context) => Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                'You don\'t have friends yet',
                style: TextStyle(fontSize: 25.0, color: Colors.grey[500]),
              ),

            ]),
          ),
        );
      },
    );
  }

  Widget buildChatItem(SocialUserModel model, context) => InkWell(
        onTap: () {
          navigateTo(
            context,
            ChatsDetailsScreen(
              userModel: model,
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20.0,
                backgroundImage: NetworkImage('${model.image}'),
              ),
              SizedBox(
                width: 15.0,
              ),
              Column(
                children: [
                  Text(
                    '${model.name}',
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}
