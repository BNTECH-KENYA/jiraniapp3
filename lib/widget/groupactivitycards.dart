import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiraniapp/models/chatModel.dart';
import 'package:jiraniapp/models/contactfr.dart';

class AddParticipants extends StatelessWidget {


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
              backgroundColor: Colors.blue,
              child: Icon(Icons.person_add, color: Colors.white,),
            ),
          ],
        ),
      ),
      title: Text("Add Participant", style:TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
      )),
    );
  }
}

class LinkInvite extends StatelessWidget {


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
              backgroundColor: Colors.blue,
              child: Icon(Icons.person_add, color: Colors.white,),
            ),
          ],
        ),
      ),
      title: Text("Invite Via Link", style:TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
      )),
    );
  }
}
