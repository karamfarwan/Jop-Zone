import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/layout/cubit/cubit.dart';
import 'package:social/layout/cubit/state.dart';
import 'package:social/shared/components/components.dart';
import 'package:social/shared/styles/icon_broken.dart';

class EditProfileScreen extends StatelessWidget {
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var positionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      SocialCubit.get(context).getUserData();

      return BlocConsumer<SocialCubit, SocialStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var userModel = SocialCubit.get(context).userModel;
          var profileImage = SocialCubit.get(context).profileImage;
          var coverImage = SocialCubit.get(context).coverImage;

          nameController.text = userModel.name;
          positionController.text = userModel.position;
          phoneController.text = userModel.phone;

          return Scaffold(
            appBar: AppBar(
              title: Text('Edit Profile'),
              actions: [
                TextButton(
                  onPressed: () {
                    if (SocialCubit.get(context).profileImage != null &&
                        SocialCubit.get(context).coverImage != null)
                      SocialCubit.get(context).updateUser(
                          name: nameController.text,
                          phone: phoneController.text,
                          position: positionController.text);
                    Navigator.pop(context);
                    if (SocialCubit.get(context).profileImage != null)
                      SocialCubit.get(context).uploadProfileImage(
                          name: nameController.text,
                          phone: phoneController.text,
                          position: positionController.text);
                    if (SocialCubit.get(context).coverImage != null)
                      SocialCubit.get(context).uploadCoverImage(
                          name: nameController.text,
                          phone: phoneController.text,
                          position: positionController.text);
                    SocialCubit.get(context).updateUser(
                        name: nameController.text,
                        phone: phoneController.text,
                        position: positionController.text);
                  },
                  child: Icon(IconBroken.Upload),
                ),
                SizedBox(
                  width: 15.0,
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    if (state is SocialUserUpdateLoadingStates)
                      LinearProgressIndicator(),
                    if (state is SocialUserUpdateLoadingStates)
                      SizedBox(
                        height: 10,
                      ),
                    Container(
                      height: 190,
                      child: Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        children: [
                          Align(
                            child: Stack(
                              alignment: AlignmentDirectional.topEnd,
                              children: [
                                if (coverImage == null)
                                  Container(
                                    height: 140.0,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(4.0),
                                        topRight: Radius.circular(4.0),
                                      ),
                                      image: DecorationImage(
                                        image:
                                            NetworkImage('${userModel.cover}'),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                if (coverImage != null)
                                  Container(
                                    height: 140.0,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(4.0),
                                        topRight: Radius.circular(4.0),
                                      ),
                                      image: DecorationImage(
                                        image: FileImage(coverImage),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                IconButton(
                                  icon: CircleAvatar(
                                      radius: 20.0,
                                      child: Icon(
                                        IconBroken.Camera,
                                        size: 16,
                                      )),
                                  onPressed: () {
                                    SocialCubit.get(context).getCoverImage();
                                  },
                                ),
                              ],
                            ),
                            alignment: AlignmentDirectional.topCenter,
                          ),
                          Stack(
                            alignment: AlignmentDirectional.bottomEnd,
                            children: [
                              if (profileImage == null)
                                CircleAvatar(
                                  radius: 65,
                                  backgroundColor:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  child: CircleAvatar(
                                    radius: 60.0,
                                    backgroundImage:
                                        NetworkImage('${userModel.image}'),
                                  ),
                                ),
                              if (profileImage != null)
                                CircleAvatar(
                                  radius: 65,
                                  backgroundColor:
                                      Theme.of(context).scaffoldBackgroundColor,
                                  child: CircleAvatar(
                                    radius: 60.0,
                                    backgroundImage: FileImage(profileImage),
                                  ),
                                ),
                              IconButton(
                                icon: CircleAvatar(
                                  radius: 20.0,
                                  child: Icon(
                                    IconBroken.Camera,
                                    size: 16,
                                  ),
                                ),
                                onPressed: () {
                                  SocialCubit.get(context).getProfileImage();
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    // if (SocialCubit.get(context).profileImage != null ||
                    //     SocialCubit.get(context).coverImage != null)
                    //   Row(
                    //     children: [
                    //       if (SocialCubit.get(context).profileImage != null)
                    //         Expanded(
                    //           child: Column(children: [
                    //             defaultButton(
                    //               function: () {
                    //                 SocialCubit.get(context).uploadProfileImage();
                    //               },
                    //               text: 'upload profile',
                    //             ),
                    //             if (state is SocialUserUpdateLoadingStates)
                    //               LinearProgressIndicator(),
                    //           ]),
                    //         ),
                    //       SizedBox(
                    //         width: 5,
                    //       ),
                    //       if (SocialCubit.get(context).coverImage != null)
                    //         Expanded(
                    //           child: Column(
                    //             children: [
                    //               defaultButton(
                    //                 function: () {
                    //                   SocialCubit.get(context).uploadCoverImage(
                    //                       name: nameController.text,
                    //                       phone: phoneController.text,
                    //                       position: positionController.text);
                    //                 },
                    //                 text: 'upload cover',
                    //               ),
                    //               if (state is SocialUserUpdateLoadingStates)
                    //                 LinearProgressIndicator(),
                    //             ],
                    //           ),
                    //         ),
                    //     ],
                    //   ),
                    if (SocialCubit.get(context).profileImage != null ||
                        SocialCubit.get(context).coverImage != null)
                      SizedBox(
                        height: 20,
                      ),
                    defaultFormField(
                        controller: nameController,
                        type: TextInputType.name,
                        validate: (String value) {
                          if (value.isEmpty) {
                            return 'name must not be empty';
                          }
                          return null;
                        },
                        label: 'Name',
                        prefix: IconBroken.User),
                    SizedBox(
                      height: 10,
                    ),
                    defaultFormField(
                        controller: positionController,
                        type: TextInputType.text,
                        validate: (String value) {
                          if (value.isEmpty) {
                            return 'position must not be empty';
                          }
                          return null;
                        },
                        label: 'Position',
                        prefix: Icons.person_pin),
                    SizedBox(
                      height: 10,
                    ),
                    defaultFormField(
                        controller: phoneController,
                        type: TextInputType.phone,
                        validate: (String value) {
                          if (value.isEmpty) {
                            return 'phone must not be empty';
                          }
                          return null;
                        },
                        label: 'Phone',
                        prefix: IconBroken.Call),
                  ],
                ),
              ),
            ),
          );
        },
      );
    });
  }
}
