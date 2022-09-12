import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class NotificationModel {
  String notificationId;
  String contentKey;
  String contentId;
  String content;
  String senderName;
  String senderId;
  String senderProfile;
  String reseverName;
  String reseverid;
  bool read;
  Timestamp dateTime;
  FieldValue serverTimeStamp;

  NotificationModel(
      {this.notificationId,
      this.contentKey,
      this.contentId,
      this.content,
      this.senderName,
      this.senderId,
      this.senderProfile,
      this.reseverName,
      this.reseverid,
      @required this.read,
      @required this.dateTime,
      this.serverTimeStamp});

  NotificationModel.fromjson(Map<String, dynamic> json) {
    notificationId = json['notificationId'];
    contentKey = json['contentKey'];
    contentId = json['contentId'];
    content = json['content'];
    senderName = json['senderName'];
    senderId = json['senderId'];
    senderProfile = json['senderProfile'];
    reseverName = json['reseverName'];
    reseverid = json['reseverid'];
    read = json['read'];
    dateTime = json['dateTime'];
  }
  Map<String, dynamic> toMap() {
    return {
      'notificationId': notificationId,
      'contentKey': contentKey,
      'contentId': contentId,
      'content': content,
      'senderName': senderName,
      'senderId': senderId,
      'senderProfile': senderProfile,
      'reseverName': reseverName,
      'reseverid': reseverid,
      'read': read,
      'dateTime': dateTime,
      'serverTimeStamp': serverTimeStamp,
    };
  }
}
