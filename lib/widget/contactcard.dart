import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiraniapp/models/chatModel.dart';
import 'package:jiraniapp/models/contactfr.dart';

class ContactCard extends StatelessWidget {

  const ContactCard({Key? key, required this.contact}) : super(key: key);
  final ContactModel contact;


  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        height: 53,
        width: 50,
        child: Stack(
          children: [
            CircleAvatar(
              radius: 23,
              backgroundColor: Colors.blueGrey[200],
              child: Icon(Icons.person, color: Colors.white,),
            ),
           contact.select? Positioned(
              bottom: 4,
              right: 5,
              child: CircleAvatar(
                backgroundColor: Colors.teal,
                  radius: 11,
                  child: Icon(Icons.check, color: Colors.white,size: 18,)),
            ):Container(),
          ],
        ),
      ),
      title: Text(contact.name, style:TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
      )),
    );
  }
}
