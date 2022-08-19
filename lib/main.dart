
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
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
import 'package:provider/provider.dart';

Future<void> main() async {
  await WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

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