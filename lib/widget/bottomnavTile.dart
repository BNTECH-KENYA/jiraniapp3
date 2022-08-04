import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiraniapp/models/bottommodel.dart';

class BottomNavTile extends StatelessWidget {
  const BottomNavTile({Key? key, required this.bottomModel}) : super(key: key);
  final BottomNavModel bottomModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 70,
      child: Column(
        children: [
       Icon(bottomModel.icon, color: Colors.blue,),
          Text(bottomModel.navtext, style: TextStyle(
            color: Colors.black38,
            fontSize: 12,
            fontWeight: FontWeight.w600
          ),)
        ],
      ),


    );
  }
}
