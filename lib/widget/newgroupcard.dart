import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewGroup extends StatelessWidget {
  const NewGroup({Key? key, required this.name, required this.icon}) : super(key: key);
  final String name;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 23,
        child: Icon(icon, size: 26,color: Colors.white,),
        backgroundColor: Colors.blue,
      ),
      title: Text(name, style:TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
      )),
    );
  }
}
