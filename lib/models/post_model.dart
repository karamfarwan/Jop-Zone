import 'package:social/models/social_user_model.dart';

class PostModel {
  SocialUserModel userModel;
  String name;
  String uId;
  String image;
  String dateTime;
  String text;
  String postImage;
  String imagePost;
  int like;
  int comment;

  PostModel({
    this.userModel,
    this.name,
    this.uId,
    this.image,
    this.dateTime,
    this.text,
    this.postImage,
    this.imagePost,
    this.comment,
    this.like,
  });

  PostModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    uId = json['uId'];
    image = json['image'];
    dateTime = json['dateTime'];
    text = json['text'];
    postImage = json['postImage'];
    like = json['like'];
    comment = json['comment'];
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'uId': uId,
      'image': image,
      'dateTime': dateTime,
      'text': text,
      'postImage': postImage,
      'like': like,
      'comment': comment,
    };
  }
}
