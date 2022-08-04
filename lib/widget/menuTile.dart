import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiraniapp/models/menumodel.dart';

class MenuTile extends StatelessWidget {
  const MenuTile({Key? key, required this.menuModel}) : super(key: key);
  final MenuModel menuModel;

  @override
  Widget build(BuildContext context) {
    return  Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 23,
              backgroundImage: AssetImage(menuModel.imagelink),
              backgroundColor: Colors.blueGrey[200],
            ),
          ],
        ),
        SizedBox(height: 2,),
        Text(menuModel.menuinfo,
          style: TextStyle(
              fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black54
          ),)
      ],

    );
  }
}
