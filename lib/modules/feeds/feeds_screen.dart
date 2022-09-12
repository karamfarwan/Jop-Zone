import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:social/layout/cubit/cubit.dart';
import 'package:social/layout/cubit/state.dart';
import 'package:social/models/post_model.dart';
import 'package:social/models/social_user_model.dart';
import 'package:social/modules/comment_screen.dart';
import 'package:social/modules/fullScren.dart';
import 'package:social/modules/new_post/new_post_screen.dart';
import 'package:social/modules/user/friend_profile.dart';
import 'package:social/shared/components/components.dart';
import 'package:social/shared/styles/colors.dart';
import 'package:social/shared/styles/icon_broken.dart';

class FeedsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        // SocialCubit.get(context).getFriends(SocialCubit.get(context).userModel.uId);
        //var coverImage = SocialCubit.get(context).coverImage;
        return ConditionalBuilder(
          condition: SocialCubit.get(context).posts.length > 0 &&
              SocialCubit.get(context).userModel != null,
          builder: (context) => SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                SizedBox(
                  height: 8.0,
                ),
                Card(
                  color: Theme.of(context).cardColor,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  elevation: 5.0,
                  margin: EdgeInsets.symmetric(
                    horizontal: 8.0,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 20.0,
                                  backgroundImage: NetworkImage(
                                      '${SocialCubit.get(context).userModel.image}'),
                                ),
                                SizedBox(
                                  width: 15.0,
                                ),
                                InkWell(hoverColor: Theme.of(context).backgroundColor,
                                  child: Text(
                                    'what is on your mind...',
                                    style:
                                        Theme.of(context).textTheme.subtitle1,
                                  ),
                                  onTap: () {
                                    navigateTo(context, NewPostScreen());
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 8.0,
                ),
                ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) => buildPostItem(
                      SocialCubit.get(context).posts[index],
                      context,
                      state,
                      index),
                  separatorBuilder: (context, index) => SizedBox(
                    height: 8.0,
                  ),
                  itemCount: SocialCubit.get(context).posts.length,
                ),
                SizedBox(
                  height: 8.0,
                ),
              ],
            ),
          ),
          fallback: (context) => Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  Widget buildPostItem(PostModel postmodel, context, state, index) => Card(
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

                  // if (SocialCubit.get(context).postId[index] == postmodel.uId)
                  //   IconButton(
                  //     onPressed: () {},
                  //     icon: Icon(
                  //
                  //       Icons.more_horiz,
                  //       color:defaultColor,
                  //       size: 16.0,
                  //     ),
                  //   )
                  IconButton(
                    icon: Icon(
                      Icons.more_horiz,
                      size:25.0,
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
                    },
                  ),
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
                      child: Icon(
                        IconBroken.Heart,
                        size: 30,
                        color: Colors.grey,

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
                        // SocialCubit.get(context).changeColorHeart();
                      },
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: InkWell(
                      child: Icon(
                        IconBroken.Message,
                        size: 30,
                        color: Colors.grey,
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
