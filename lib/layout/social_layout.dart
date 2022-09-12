import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social/layout/cubit/state.dart';
import 'package:social/modules/new_post/new_post_screen.dart';
import 'package:social/modules/search/search_screen.dart';
import 'package:social/shared/components/components.dart';
import 'package:social/shared/styles/colors.dart';
import 'package:social/shared/styles/icon_broken.dart';
import 'package:social/shared/styles/themes.dart';

import 'cubit/cubit.dart';

class SocialLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {
        if (state is SocialNewPostStates) {
          navigateTo(
            context,
            NewPostScreen(),
          );
        }
      },
      builder: (context, state) {
        var cubit = SocialCubit.get(context);

        return Scaffold(
          appBar: AppBar(
            title: Text(
              cubit.titles[cubit.currentIndex],
            ),
            actions: [
              IconButton(
                icon: Icon(IconBroken.Logout,color: defaultColor),
                onPressed: () {
                  SocialCubit.get(context).signOut(context);
                },
              ),
              IconButton(
                icon: Icon(Icons.brightness_2,color: defaultColor),
                onPressed: () {
                  SocialCubit.get(context).changeAppMode();
                },
              ),
              IconButton(onPressed: (){}, icon: Icon(IconBroken.Message,color: defaultColor,)),
              IconButton(
                icon: Icon(IconBroken.Search,
                color: defaultColor),
                onPressed: () {
                  navigateTo(
                      context,
                      SearchScreen(
                      ));
                },
              ),
            ],
            titleTextStyle: TextStyle(
              color: defaultColor,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),

            //backgroundColor: Colors.white,
          ),
          body: cubit.screens[cubit.currentIndex],
          floatingActionButton: FloatingActionButton(
            backgroundColor: defaultColor,
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:(context) => NewPostScreen(),
                ),
              );
            },
            child: Icon(
              IconBroken.Plus,
              size: 30,
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: cubit.currentIndex,
            onTap: (index) {
              cubit.changeBottomNav(index);
            },
            items: [
              BottomNavigationBarItem(
                  icon: Icon(
                    IconBroken.Home,
                    size: 40,
                  ),
                  label: ''),
              BottomNavigationBarItem(
                icon: Icon(
                  IconBroken.Chat,
                  size: 40,

                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  IconBroken.Profile,
                  size: 40,

                ),
                label: '',
              ),
              BottomNavigationBarItem(



                  icon: Icon(
                    IconBroken.Notification,
                    size: 40,

                  ),
                  label: ''),
              BottomNavigationBarItem(
                  icon: Icon(
                    IconBroken.User1,
                    size: 40,

                  ),
                  label: ''),
            ],
          ),

        );
      },
    );
  }
}
