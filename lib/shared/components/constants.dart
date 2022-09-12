
import 'package:social/modules/social_login/social_login_screen.dart';
import 'package:social/shared/components/components.dart';
import 'package:social/shared/remote/cashe_helper.dart';

void singOut(context) {
  CacheHelper.removeData(key: 'token').then((value) {
    if (value) {
      navigateAndFinish(
        context,
        SocialLoginScreen(),
      );
    }
  });
}


void printFullText(String text){
  final pattern = RegExp('.{1,800}');
  pattern.allMatches(text).forEach((match) => print(match.group(0)));
}

String token = '';
String uId = '';

