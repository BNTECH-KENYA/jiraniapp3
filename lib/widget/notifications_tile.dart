import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../models/notifications_model.dart';

class Notification_In extends StatelessWidget {
  const Notification_In({Key? key,
    required this.notificationType,
    required this.notificationStatus,
    required this.groupid,
    required this.groupname,
    required this.guestid,
    required this.user_name,
    required this.phone_number,
    required this.notifications_id,
  }) : super(key: key);

 final String notificationType;
  final String notificationStatus;
  final String groupid;
  final String groupname;
  final String guestid;
  final String user_name;
  final String phone_number;
  final String notifications_id;

  Future<void> join_group ()async{

    final bodyInvited = jsonEncode({
      "phone_number ": phone_number,
      "user_name ": user_name,
      "group_id ": groupid,
      "notifications_id": notifications_id,
    });

    final url = "https://us-central1-jiranimobile.cloudfunctions.net/addtogroup";
    final response = await post(Uri.parse(url),
        body:bodyInvited,
        headers: {
          "Accept": "application/json",
          "Content-type": "application/json",
        });

    String Postresponce = response.body.toString(); //Populated XML String....
    print("response from cloud_fun **************************************** \n ${Postresponce}");

  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 100,
            width: double.infinity,

            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text("you were invited to join group ${groupname} as a contributor",
                style:TextStyle(
                  color: Colors.black
                )),
                SizedBox(height: 4,),
                InkWell(
                  onTap: (){
                    // function to join group
                  },
                  child: Container(
                    height: 30,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(15.0)
                    ),

                    child: Center(
                      child: Text("Accept", style: TextStyle(
                        color:Colors.white
                      ),),
                    ),

                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
