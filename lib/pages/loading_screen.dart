import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading_Screen extends StatefulWidget {
  const Loading_Screen({Key? key}) : super(key: key);

  @override
  State<Loading_Screen> createState() => _Loading_ScreenState();
}

class _Loading_ScreenState extends State<Loading_Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height:MediaQuery.of(context).size.height,
        
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height:MediaQuery.of(context).size.height-40,
              child: Center(
                child: SpinKitPulse(
                  color: Colors.white,
                  size: 100,
                ),
              ),
            ),
            Text("Loading please wait...", style: TextStyle(
                fontSize: 16,
                color:Colors.white),)
          ],
        ),
      ),
    );
  }
}
