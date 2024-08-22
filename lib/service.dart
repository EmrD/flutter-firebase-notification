// ignore_for_file: avoid_print

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:bildirim/firebase_options.dart';

class FirebaseNotificationService {
  late final FirebaseMessaging messaging; 
  void settingNotification()async{
    await messaging.requestPermission();
  }

  void connectNotification()async{
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    messaging = FirebaseMessaging.instance;
    messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    settingNotification();
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      print("gelen bildirim başlığı: ${event.notification!.title}");
    });
    messaging.getToken().then((value) => print("Token: $value"));
  }
}