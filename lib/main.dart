import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:bildirim/firebase_options.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  log("Handling a background message: ${message.messageId}");
  // Perform your desired actions here, such as updating the UI or sending data to your server.
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  // Set the background messaging handler early on, as a named top-level function
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late final FirebaseMessaging messaging;

  @override
  void initState() {
    super.initState();
    connectNotification();
  }

  void connectNotification() async {
    messaging = FirebaseMessaging.instance;

    // Notification settings
    await messaging.requestPermission();
    messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // Foreground notifications
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      log("Foreground notification: ${event.notification?.title}");
      // Show a notification dialog
      _showNotification(event);
    });

    // Handle background and terminated notifications
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log("Notification clicked: ${message.notification?.title}");
      // Navigate to a specific screen if needed
    });

    // Get token
    messaging.getToken().then((value) => log("Token: $value"));

    // Handle terminated notification
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        log("Terminated notification: ${message.notification?.title}");
        // Handle your terminated notification here
      }
    });
  }

  void _showNotification(RemoteMessage message) {
    // Notification title and body
    String? title = message.notification?.title;
    String? body = message.notification?.body;

    // Show notification using flutter_local_notifications or another notification plugin
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title ?? ''),
        content: Text(body ?? ''),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Flutter Notification"),
      ),
      body: Center(
        child: Text("Notification Demo"),
      ),
    );
  }
}
