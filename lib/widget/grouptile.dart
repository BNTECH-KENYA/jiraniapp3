import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiraniapp/pages/ingrouppage.dart';

import '../models/chatModel.dart';

class GroupTile extends StatelessWidget {
  final ChatModel chatModel;
  const GroupTile({Key? key, required this.chatModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    /*
                  FirebaseFirestore
                      .instance
                      .collection("contributionsupdate")
                      .where("groupid", isEqualTo:course!.id.toString() ).snapshots();

                   */

    // TODO: implement build
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>InGroupPage(groupid: chatModel.groupidmd,)));
      },
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(chatModel.icon),
            ),
            title: Text(chatModel.name,
                style:TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                )),
            subtitle: Text(chatModel.currentMessage,
                style:TextStyle(
                    fontSize: 13
                )),
            trailing: Text(chatModel.time),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20, left: 80),
            child: Divider(
              thickness: 1,
            ),
          ),

        ],
      ),
    );
  }
}


