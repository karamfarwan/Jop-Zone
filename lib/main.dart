  import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:bloc/bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:social/layout/cubit/cubit.dart';
import 'package:social/layout/cubit/state.dart';
import 'package:social/layout/social_layout.dart';
import 'package:social/modules/social_login/social_login_screen.dart';
import 'package:social/modules/splash_screen/splash_screen.dart';
import 'package:social/modules/start_screen/start_screen.dart';
import 'package:social/shared/bloc_observer.dart';
import 'package:social/shared/components/components.dart';
import 'package:social/shared/components/constants.dart';
import 'package:social/shared/remote/cashe_helper.dart';
import 'package:social/shared/remote/dio_helper.dart';
import 'package:social/shared/styles/colors.dart';
import 'package:social/shared/styles/themes.dart';


Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async{
  print('on background message');
  print(message.data.toString());
  showToast(text:'on background message', state: ToastStates.SUCCESS,);
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  var token = await FirebaseMessaging.instance.getToken();
  print(token);
  FirebaseMessaging.onMessage.listen((event) {
    print('on message');
    print(event.data.toString());
    showToast(text: 'on message', state: ToastStates.SUCCESS,);
  });
  FirebaseMessaging.onMessageOpenedApp.listen((event) {
    print('on message opened app');
    print(event.data.toString());
    showToast(text: 'on message opened app', state: ToastStates.SUCCESS,);
  });
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await CacheHelper.init();
  bool isDark = CacheHelper.getBoolean(key: 'isDark');

  Widget widget;
  //bool onBoarding = CacheHelper.getData(key: 'onBoarding');
  //token = CacheHelper.getData(key: 'token');
  uId = CacheHelper.getBoolean(key: 'uId');

  if (uId != null) {
    widget = SocialLayout();
  } else {
    widget = SocialLoginScreen();
  }
  // if (onBoarding != null) {
  //   if (token != null)
  //     widget = ShopLayout();
  //   else
  //     widget = ShopLoginScreen();
  // } else {
  //   widget = OnBoardingScreen();
  // }
  //
  // print('onBoarding $onBoarding');

  runApp(MyApp(
    isDark: isDark,
    startWidget: widget,
  ));

  // @override
  // Widget build(BuildContext context) {
  //   return MultiBlocProvider(
  //     providers: [
  //       BlocProvider(
  //           create: (BuildContext context) => SocialCubit()..getUserData())
  //     ],
  //     child: BlocConsumer<AppCubit, AppStates>(
  //       listener: (context, state) {},
  //       builder: (context, state) {
  //         return MaterialApp(
  //           debugShowCheckedModeBanner: false,
  //           theme: ThemeData(
  //             fontFamily: 'Jannah',
  //             primarySwatch: Colors.blue,
  //             scaffoldBackgroundColor: Colors.white,
  //           ),
  //           home: Directionality(
  //             textDirection: AppCubit
  //                 .get(context)
  //                 .appDirection,
  //             child: start,
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }
}

class MyApp extends StatelessWidget {
  final bool isDark;
  final Widget startWidget;

  MyApp({this.isDark, this.startWidget});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (BuildContext context) =>
            SocialCubit()
              ..getUserData()
              ..getPosts()
               ..getUsers()
              ..getComment()
              ..getUnReadNotificationsCount(uId)
                ..changeAppMode()
        ),
      ],
      child: BlocConsumer<SocialCubit, SocialStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
              theme: lightTheme,
              darkTheme: darkTheme,
              themeMode: SocialCubit.get(context).isDark ? ThemeMode.dark : ThemeMode.light,
            debugShowCheckedModeBanner: false,
            // theme: ThemeData(
            //  // fontFamily: 'Jannah',
            //   primarySwatch: Colors.blue,
            //   scaffoldBackgroundColor: Colors.white,
            // ),
             home: startWidget,
            //AnimatedSplashScreen(
            //   splash: SplashScreen(),
            //   nextScreen: startWidget,
            //   backgroundColor: defaultColor,
            //   splashTransition: SplashTransition.scaleTransition,
            //   animationDuration: Duration(milliseconds: 2000),
            //   //pageTransitionType: PageTransitionType.topToBottom,
            //  duration: 3000,
            // ),
            //SocialRegisterScreen(),
            //SettingsScreen(),
            );

        },
      ),
    );
    // return MaterialApp(
    //   debugShowCheckedModeBanner: false,
    //   theme: lightTheme,
    //   darkTheme: darkTheme,
    //   themeMode: ThemeMode.light,
    //   home: startWidget,
    //   //SocialLoginScreen(),
    //   //SocialRegisterScreen(),
    //
    //   //onBoarding ? ShopLoginScreen() : OnBoardingScreen(),
    //   //HomeScreen(),
    // );
  }
}
