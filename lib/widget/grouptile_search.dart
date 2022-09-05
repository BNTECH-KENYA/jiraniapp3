import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiraniapp/models/grouplistmodel.dart';
import 'package:jiraniapp/pages/ingrouppage.dart';

import '../models/chatModel.dart';

class GroupTileSearch extends StatelessWidget {
  final GroupListModel groupModel;
  const GroupTileSearch({Key? key, required this.groupModel}) : super(key: key);

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
        Navigator.push(context, MaterialPageRoute(builder: (context)=>InGroupPage(groupid: groupModel.groupid,)));
      },
      child: Column(
        children: [
          ListTile(
            leading: CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(groupModel.groupprofilepic),
            ),
            title: Text(groupModel.groupname,
                style:TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                )),

            trailing: Icon(Icons.navigate_next, color:Colors.blue),
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


