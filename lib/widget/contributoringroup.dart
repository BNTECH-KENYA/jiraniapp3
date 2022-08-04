import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/chatModel.dart';

class ContributorInGroup extends StatelessWidget {
  const ContributorInGroup({Key? key, required this.contact}) : super(key: key);
  final ChatModel contact;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 23,
                child: Icon(Icons.person,color:Colors.white),
                backgroundColor: Colors.blueGrey[200],
              ),
            ],
          ),
          SizedBox(height: 2,),
          Text(contact.name,
            style: TextStyle(
                fontSize: 12
            ),)
        ],

      ),
    );
  }
}
