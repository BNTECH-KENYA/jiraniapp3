
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jiraniapp/blocs/application_bloc.dart';
import 'package:jiraniapp/pages/addService.dart';
import 'package:jiraniapp/pages/creategroup.dart';
import 'package:jiraniapp/pages/home.dart';
import 'package:jiraniapp/pages/ingrouppage.dart';
import 'package:jiraniapp/pages/ipay_page.dart';
import 'package:jiraniapp/pages/location.dart';
import 'package:jiraniapp/pages/login.dart';
import 'package:jiraniapp/pages/tabslayout.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");

}


Future<void> main() async {
  await WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final fcmToken = await FirebaseMessaging.instance.getToken();

  if(firebaseAuth.currentUser != null)
    {
      final setdata = <String, String>{
        "authphonenumber":firebaseAuth.currentUser!.phoneNumber!,
        "token":fcmToken!
      };

      await FirebaseFirestore.instance
          .collection('tokens')
          .doc(firebaseAuth.currentUser!.phoneNumber).set(setdata)
          .onError((error, stackTrace) => print(error));
      print(fcmToken);
      FirebaseMessaging.instance.onTokenRefresh
          .listen((fcmToken) async{
        // TODO: If necessary send token to application server.
        print(fcmToken);
        final setdata = <String, String>{

          "authphonenumber":firebaseAuth.currentUser!.phoneNumber!,
          "token":fcmToken
        };
        await FirebaseFirestore.instance
            .collection('tokens')
            .doc(firebaseAuth.currentUser!.phoneNumber!).set(setdata)
            .onError((error, stackTrace) => print(error));
        // Note: This callback is fired at each app startup and whenever a new
        // token is generated.
      })
          .onError((err) {
        // Error getting token.
      });
    }

  //await FirebaseMessaging.instance.setAutoInitEnabled(true);
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  analytics.setAnalyticsCollectionEnabled(true);

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,

  );

  print('User granted permission: ${settings.authorizationStatus}');

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');

    }
  });

  final status = await Permission.appTrackingTransparency.request();
  if (status == PermissionStatus.granted) {
    await FacebookAuth.i.autoLogAppEventsEnabled(true);
    print(
        "isAutoLogAppEventsEnabled:: ${await FacebookAuth.i.isAutoLogAppEventsEnabled}");
  }
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  //notification onclick on opened app
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {

    if(message.notification?.body != null)
    {
      //navigate
    }
  });

  //notification in background
  var initialzationSettingAndroid = AndroidInitializationSettings("");
  InitializationSettings(android: initialzationSettingAndroid);

  runApp(const ProviderScope(child:MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
          title: 'Flutter Login UI',
          theme: ThemeData(
            primaryColor: const Color(0xff3b4ea8),
            accentColor: const Color(0xffffffff),
            scaffoldBackgroundColor: Colors.grey.shade100,
            primarySwatch: Colors.grey,
          ),
          initialRoute: '/login',
          routes:{
            '/login':(context)=> LoginScreen(),
          }
      );
  }
}