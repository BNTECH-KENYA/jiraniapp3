import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiraniapp/models/contactfr.dart';

import '../models/chatModel.dart';

class NewGroupContributor extends StatelessWidget {
  const NewGroupContributor({Key? key, required this.contact}) : super(key: key);
  final ContactModel contact;

  @override
  Widget build(BuildContext context) {
    return  Column(
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

    );
  }
}
