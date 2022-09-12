import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:social/layout/cubit/cubit.dart';
import 'package:social/layout/cubit/state.dart';
import 'package:social/models/social_user_model.dart';
import 'package:social/modules/feeds/feeds_screen.dart';
import 'package:social/modules/fullScren.dart';
import 'package:social/shared/components/components.dart';
import 'package:social/shared/styles/colors.dart';
import 'package:social/shared/styles/icon_broken.dart';

class NewPostScreen extends StatelessWidget {
  var textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //var userModel = SocialCubit.get(context).userModel;

    return BlocConsumer<SocialCubit, SocialStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return ConditionalBuilder(
            condition: SocialCubit.get(context).userModel != null,
            builder: (context) => Scaffold(
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
                  'Create Post',
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      var now = DateTime.now();
                      if (SocialCubit.get(context).postImage == null) {
                        SocialCubit.get(context).createPost(
                            dateTime: now.toString(),
                            text: textController.text);
                      } else {
                        SocialCubit.get(context).uploadPostImage(
                            dateTime: now.toString(),
                            text: textController.text);
                      }
                      Navigator.pop(context);
                    },
                    child: Text('Post'),
                  ),
                ],
              ),
              body: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    if (state is SocialCreatePostLoadingStates)
                      LinearProgressIndicator(),
                    if (state is SocialCreatePostLoadingStates)
                      SizedBox(
                        height: 5,
                      ),
                    Row(
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
                          child: Text(
                            '${SocialCubit.get(context).userModel.name}',
                            style: Theme.of(context).textTheme.bodyText1
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child:
                      TextFormField(
                        controller: textController,
                        decoration: InputDecoration(
                          hintText: 'what is on your mind...',
                          hintStyle: Theme.of(context).textTheme.subtitle2,
                          //labelStyle: TextStyle(color: defaultColor),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    if (SocialCubit.get(context).postImage != null)
                      Expanded(
                        child: Stack(
                          alignment: AlignmentDirectional.topEnd,
                          children: [
                            Center(
                              child: Hero(
                                tag: 'custom back ground',
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4.0),
                                  child: Container(
                                    height: 200.0,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(4.0),
                                      image: DecorationImage(
                                        image: FileImage(
                                            SocialCubit.get(context).postImage),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  SocialCubit.get(context).removePostImage();
                                },
                                icon: CircleAvatar(
                                    backgroundColor: Colors.lightBlue,
                                    radius: 20.0,
                                    child: Icon(
                                      Icons.close,
                                      color: Colors.black,
                                      size: 20.0,
                                    ))),
                          ],
                        ),
                      ),
                      // Expanded(
                      //   child: Stack(
                      //     alignment: AlignmentDirectional.topEnd,
                      //     children: [
                      //       Center(
                      //         child: Container(
                      //           height: 140.0,
                      //           width: double.infinity,
                      //           decoration: BoxDecoration(
                      //             borderRadius: BorderRadius.circular(4.0),
                      //             image: DecorationImage(
                      //               image: FileImage(
                      //                   SocialCubit.get(context).postImage),
                      //               fit: BoxFit.cover,
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //       IconButton(
                      //         icon: CircleAvatar(
                      //             radius: 20.0,
                      //             child: Icon(
                      //               Icons.close,
                      //               size: 16,
                      //             )),
                      //         onPressed: () {
                      //
                      //         },
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              SocialCubit.get(context).getPostImage();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  IconBroken.Image,
                                ),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Text(
                                  'Add Photo',
                                ),
                              ],
                            ),
                          ),
                        ),

                      ],
                    )
                  ],
                ),
              ),
            ),
            //buildNewPostItem( SocialCubit.get(context).user,context,state),

            fallback: (context) => Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }

}
