import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/layout/cubit/cubit.dart';
import 'package:social/layout/cubit/state.dart';
import 'package:social/models/comment_model.dart';
import 'package:social/models/post_model.dart';
import 'package:social/models/social_user_model.dart';
import 'package:social/shared/styles/colors.dart';
import 'package:social/shared/styles/icon_broken.dart';

class CommentScreen extends StatelessWidget {
  var commentController = TextEditingController();
  int postIndex;
  PostModel postModel;

  CommentScreen(
    this.postIndex,
    this.postModel,
  );

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      SocialCubit.get(context).getUser(postModel.uId);
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
              title: Text(
                'Comments',

              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [

                  SizedBox(height: 10),
                  ConditionalBuilder(
                      condition: SocialCubit.get(context).comments.length > 0,
                      builder: (context) => commentItem(
                          context,
                          SocialCubit.get(context).comments,
                          SocialCubit.get(context).postId[postIndex],
                          SocialCubit.get(context).user),
                      fallback: (context) => Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'There are no comments yet',
                                  style: TextStyle(
                                      color: Colors.grey[500], fontSize: 20.0),
                                ),
                                Text(
                                  'be the first to comment',
                                  style: TextStyle(
                                      color: Colors.grey[500], fontSize: 19.0),
                                ),
                                Spacer(),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextFormField(
                                          controller: commentController,
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
                                                    50.0)),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 25.0,
                                                    vertical: 5.0),
                                            hintText: 'Write a comment...',
                                            hintStyle: TextStyle(
                                                color: Colors.black),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(50.0),
                                            ),
                                          )),
                                    ),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    CircleAvatar(
                                      backgroundColor: defaultColor,
                                      radius: 20.0,
                                      child: IconButton(
                                        onPressed: () {
                                          if (commentController.text != '')
                                            SocialCubit.get(context).addComment(
                                              postId: SocialCubit.get(context)
                                                  .postId[postIndex],
                                              comment: commentController.text,
                                            );
                                          if (postModel.uId ==
                                              SocialCubit.get(context).user.uId)

                                          if (postModel.uId ==
                                              SocialCubit.get(context).user.uId)

                                          commentController.clear();
                                        },
                                        icon: Icon(
                                          IconBroken.Send,
                                          size: 16.0,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )),
                ],
              ),
            ),
          );
        },
      );
    });
  }
  Widget commentItem(context, List<CommentModel> comments, String index,
      SocialUserModel user) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: ListView.separated(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) => Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      CircleAvatar(

                        backgroundColor: Colors.amber,
                        radius: 20.0,
                        backgroundImage:
                        NetworkImage(comments[index].image),
                      ),
                      SizedBox(width: 5.0),
                      Container(

                        decoration: BoxDecoration(
                            color:Theme.of(context).hoverColor,
                            borderRadius: BorderRadiusDirectional.only(
                              bottomEnd: Radius.circular(20.0),
                              bottomStart: Radius.circular(20.0),
                             // topStart: Radius.circular(20.0),
                              topEnd: Radius.circular(20.0),
                            )),
                        padding: EdgeInsets.symmetric(
                          vertical: 5.0,
                          horizontal: 10.0,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Row(
                            children: [

                              Padding(
                                padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${comments[index].name}',
                                      style: Theme.of(context).textTheme.bodyText1,
                                    ),

                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 10,top: 10),
                                      child: Container(
                                        width:
                                        MediaQuery.of(context).size.width - 130,
                                        child: Text(
                                          comments[index].textComment,
                                          style: Theme.of(context).textTheme.subtitle1,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                    // if (SocialCubit.get(context).commentImage !=
                                    //     null)
                                    //   Column(
                                    //     children: [
                                    //       Container(
                                    //         width: 300.0,
                                    //         height: 160.0,
                                    //         decoration: BoxDecoration(
                                    //             image: DecorationImage(
                                    //                 image: NetworkImage(
                                    //                   '${comments[index].imageComment}',
                                    //                 ),
                                    //                 fit: BoxFit.cover),
                                    //             borderRadius:
                                    //                 BorderRadius.circular(10.0)),
                                    //       ),
                                    //       Text(comments[index].textComment,
                                    //           style: TextStyle(
                                    //               fontSize: 17.0,
                                    //               height: 1.5,
                                    //               color: Colors.white))
                                    //     ],
                                    //   ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  separatorBuilder: (context, index) => SizedBox(
                    height: 8.0,
                  ),
                  itemCount: SocialCubit.get(context).comments.length,
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                    controller: commentController,
                    minLines: 1,
                    maxLines: 2,
                    style: TextStyle(color: Colors.black),
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Comment text must not be empty';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      fillColor: Colors.grey.withOpacity(0.3),
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                          BorderSide(color: Colors.grey.withOpacity(0.3)),
                          borderRadius: BorderRadius.circular(50.0)),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 25.0, vertical: 5.0),
                      hintText: 'Write a comment...',
                      hintStyle: TextStyle(color: Colors.grey[500]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                    )),
              ),
              SizedBox(
                width: 10.0,
              ),
              CircleAvatar(
                backgroundColor: defaultColor,
                radius: 20.0,
                child: IconButton(
                  onPressed: () {
                    if (commentController.text != '')
                      SocialCubit.get(context).addComment(
                        postId: index,
                        comment: commentController.text,
                      );
                    commentController.clear();
                  },
                  icon: Icon(
                    IconBroken.Send,
                    size: 16.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 13.0,
          ),
        ],
      ),
    );
  }
}
