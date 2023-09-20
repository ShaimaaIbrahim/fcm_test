import 'dart:isolate';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'notofications_helper.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp();
   FirebaseMessaging.instance.getToken().then((value) => print("shaimaaToken : ${value}"));
  // Set the background messaging handler early on, as a named top-level function
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
 runApp(MyApp());
}


@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  await NotificationsHelper().setupFlutterNotifications();
  await NotificationsHelper().showNotification(message);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    NotificationsHelper().requestPermissions();
    NotificationsHelper().isAndroidPermissionGranted();
    NotificationsHelper().setupFlutterNotifications();

    //...
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async{
      print('A new onMessageOpenedApp event was published!');
       await Firebase.initializeApp();
       NotificationsHelper().setupFlutterNotifications();
       NotificationsHelper().showNotification(message);
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async{
      print('A new onMessageOpenedApp event was published!');
      await Firebase.initializeApp();
      NotificationsHelper().setupFlutterNotifications();
      NotificationsHelper().showNotification(message);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Isolates')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //const CircularProgressIndicator(),
            const SizedBox(height: 50),
            ElevatedButton(
              child: const Text('Run Heavy Task'),
              onPressed: () => NotificationsHelper().showNotification(null),
            ),
          ],
        ),
      ),
    );
  }
}
