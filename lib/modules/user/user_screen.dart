import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/layout/cubit/cubit.dart';
import 'package:social/layout/cubit/state.dart';
import 'package:social/models/post_model.dart';
import 'package:social/modules/comment_screen.dart';
import 'package:social/modules/edit_profile/edit_profile_screen.dart';
import 'package:social/modules/fullScren.dart';
import 'package:social/modules/new_post/new_post_screen.dart';
import 'package:social/modules/user/friend_profile.dart';
import 'package:social/shared/components/components.dart';
import 'package:social/shared/styles/colors.dart';
import 'package:social/shared/styles/icon_broken.dart';

String friendUid;

class UserScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      var userModel = SocialCubit.get(context).userModel;
      SocialCubit.get(context).getUserData();
      SocialCubit.get(context).getUserPosts(userModel.uId);
      //SocialCubit.get(context).getFriends(userModel.uId);
      SocialCubit.get(context).getPosts();
      SocialCubit.get(context).getFriendRequest();
      SocialCubit.get(context).getUsers();
      SocialCubit.get(context)
          .getFriends(SocialCubit.get(context).userModel.uId);
      SocialCubit.get(context).checkFriends(friendUid);
      return BlocConsumer<SocialCubit, SocialStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var coverImage = SocialCubit.get(context).coverImage;
          var profileImage = SocialCubit.get(context).profileImage;
          return ConditionalBuilder(
            condition: userModel != null,
            builder: (context) => SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 200,
                      child: Stack(
                        alignment: AlignmentDirectional.bottomStart,
                        children: [
                          Align(
                            child: Stack(
                              alignment: AlignmentDirectional.topEnd,
                              children: [
                                Container(
                                  height: 170.0,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(4.0),
                                      topRight: Radius.circular(4.0),
                                    ),
                                    image: DecorationImage(
                                      image: coverImage == null
                                          ? NetworkImage('${userModel.cover}')
                                          : FileImage(coverImage),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            alignment: AlignmentDirectional.topCenter,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Stack(
                              alignment: AlignmentDirectional.bottomEnd,
                              children: [
                                CircleAvatar(
                                  radius: 65,
                                  backgroundColor:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  child: CircleAvatar(
                                    radius: 60.0,
                                    backgroundImage: profileImage == null
                                        ? NetworkImage('${userModel.image}')
                                        : FileImage(profileImage),
                                  ),
                                ),
                                // IconButton(
                                //   icon: CircleAvatar(
                                //     radius: 20.0,
                                //     child: Icon(
                                //       IconBroken.Camera,
                                //       size: 16,
                                //     ),
                                //   ),
                                //   onPressed: () {
                                //     SocialCubit.get(context).getProfileImage();
                                //   },
                                // ),
                              ],
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
                                  '${userModel.name}',
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  '${userModel.position}',
                                  style: Theme.of(context).textTheme.subtitle1,
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
                    SizedBox(
                      height: 10.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  side:
                                      BorderSide(color: defaultColor, width: 1),
                                ),
                                onPressed: () {
                                  navigateTo(
                                    context,
                                    NewPostScreen(),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 85.0),
                                  child: Row(
                                    children: [
                                      Icon(
                                        IconBroken.Plus,
                                        size: 20,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        'Add Posts',
                                        style: TextStyle(fontSize: 15.0),
                                      ),
                                    ],
                                  ),
                                )),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: defaultColor, width: 1),
                            ),
                            onPressed: () {
                              navigateTo(
                                context,
                                EditProfileScreen(),
                              );
                            },
                            child: Icon(
                              IconBroken.Edit,
                              size: 20,
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 8.0,
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
            fallback: (context) => Center(
              child: CircularProgressIndicator(),
            ),
          );
        },
      );
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
                              backgroundImage: NetworkImage(
                                  '${SocialCubit.get(context).userModel.image}'),
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
                                  //         height: 1.3,
                                  //       ),
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
                      onPressed: () {})
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
                      onTap: () {},
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
}
