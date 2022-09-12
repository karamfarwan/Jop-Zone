import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:social/layout/cubit/cubit.dart';
import 'package:social/layout/cubit/state.dart';
import 'package:social/models/social_user_model.dart';
import 'package:social/modules/user/friend_profile.dart';
import 'package:social/shared/styles/colors.dart';
import 'package:social/shared/styles/icon_broken.dart';

import '../../../shared/components/components.dart';

class SearchScreen extends StatelessWidget {
  var searchController = TextEditingController();
  dynamic text;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) =>
          Scaffold(
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
              title: Text(
                'Search',
              ),

            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: 20.0, horizontal: 15.0),
              child: Column(
                children: [

                  Container(



                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                      color: Theme.of(context).cardColor,),

                    child: defaultFormField(

                        onSubmit: (value) {
                          SocialCubit.get(context).searchUser(value);
                          text = value;
                        },

                        controller: searchController,
                        type: TextInputType.text,
                        validate:
                            (String value) {
                          if (value.isEmpty) {
                            return 'Search must not be empty';
                          } else {
                            return null;
                          }
                        },
                        prefix: IconBroken.Search,
                        label: 'Search'),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  ConditionalBuilder(
                    condition: SocialCubit
                        .get(context)
                        .search != null,
                    builder: (context) =>
                        buildSearch(
                          SocialCubit
                              .get(context)
                              .search,

                          context,
                        ),
                    fallback: (context) =>
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.0),
                                    color: Theme.of(context).cardColor),
                                height: 113.0,
                                child: Padding(
                                  padding: const EdgeInsets.all(25.0),
                                  child: Text(
                                    'You can search for your friends here',

                                    // 'Sorry, we could not find the person you wanted',
                                    style: Theme.of(context).textTheme.subtitle1
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  Widget buildSearch(Map<String, dynamic> model
      ,context,) {
    if (model['name'] != null &&
        model['name'] == text) {
      return InkWell(
          onTap: () {
            navigateTo(
                context,
                FriendProfile(
                  userUid: model['uId'],
                ));
          },
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20.0,

                  backgroundImage: NetworkImage(
                      '${model['image']}'),
                ),
                SizedBox(
                  width: 15.0,
                ),


                Column(

                  children: [
                    Text(

                      '${model['name']}',
                      style: Theme
                          .of(context)
                          .textTheme
                          .bodyText1,
                    ),
                  ],
                ),

              ],
            ),
          ),
      );
    }
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                color: Theme.of(context).cardColor),
            height: 70.0,
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Text(
                // 'You can search for your friends here',
                'Sorry, we could not find the person you wanted',
                style: Theme.of(context).textTheme.subtitle2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
