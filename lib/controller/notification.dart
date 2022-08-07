import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

abstract class IFCMNotificationService {
  Future<void> sendNotificationToUser({
    required List<String> tokenList,
    required String title,
    required String body,
  });
  // Future<void> sendNotificationToGroup({
  //   required String group,
  //   required String title,
  //   required String body,
  // });
  // Future<void> unsubscribeFromTopic({
  //   required String topic,
  // });
  // Future<void> subscribeToTopic({
  //   required String topic,
  // });
}

class FCMNotificationService extends IFCMNotificationService {
  final Dio dio = Dio();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final String _endPoint = 'https://fcm.googleapis.com/fcm/send';
  final String _contentType = 'application/json';
  final String _authorization =
      'key=AAAAO-cWRJw:APA91bEC9ExURKGQxisOSI36rdJzaWThjZrOTmauKQgmsCrpEUv6WK-QNNfsJokMOvm0MDXcJTQEXztH2UjenQNkhl0w7SDyrIeD_sp9T0sb8uioSIUmIogxgXFrd-KOpBFS_o5FNZng';

  sendNotification(List<String> tokenList, String title, String body) async {
    try {
      Map data = {
        'registration_ids': tokenList,
        'notification': {
          'title': title,
          'body': body,
          'android_channel_id': "push_notificationID"
        },
      };

      var res = await dio.post(
        _endPoint,
        data: data,
        options: Options(
          contentType: _contentType,
          headers: {
            'Authorization': _authorization,
          },
        ),
      );
      if (res.data.isNotEmpty) {
        return res.data;
      }
    } on DioError catch (e) {
      debugPrint(e.error);
    }
  }

  // @override
  // Future<void> unsubscribeFromTopic({required String topic}) {
  //   return _firebaseMessaging.unsubscribeFromTopic(topic);
  // }

  // @override
  // Future<void> subscribeToTopic({required String topic}) {
  //   return _firebaseMessaging.subscribeToTopic(topic);
  // }

  @override
  Future<void> sendNotificationToUser({
    required List<String> tokenList,
    required String title,
    required String body,
  }) {
    return sendNotification(
      tokenList,
      title,
      body,
    );
  }

  // @override
  // Future<void> sendNotificationToGroup(
  //     {required String group, required String title, required String body}) {
  //   return sendNotification('/topics/$group', title, body);
  // }
}
