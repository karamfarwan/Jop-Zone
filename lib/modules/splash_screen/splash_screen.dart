import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:social/layout/cubit/cubit.dart';
import 'package:social/layout/cubit/state.dart';
import 'package:social/modules/fullScren.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
        builder: (context, state) {
          return Scaffold(
            // resizeToAvoidBottomInset: false,
            // backgroundColor: HexColor('#242529'),
            body: Center(
              child: Padding(
                padding: const EdgeInsetsDirectional.only(top: 15.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4.0),
                  child: Container(
                    height: 900.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      image: DecorationImage(
                        image:  AssetImage('assets/image/Logo.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        listener: (context, state) {});
  }
}
//Container(
//           width: 250.0,
//           child: Image(
//               image: NetworkImage(
//                   'https://previews.123rf.com/images/nnv/nnv1106/nnv110600691/9733172-the-word-friends-isolated-on-a-black-background.jpg?fj=1')),
//         )
