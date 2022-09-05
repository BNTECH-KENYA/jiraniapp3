import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiraniapp/widget/notifications_tile.dart';

class Notifications_Page extends StatefulWidget {
  const Notifications_Page({Key? key, required this.guestid, required this.guestname}) : super(key: key);
  final String guestid;
  final String guestname;

  @override
  State<Notifications_Page> createState() => _Notifications_PageState();
}

class _Notifications_PageState extends State<Notifications_Page> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        backgroundColor: Colors.blue,
        title: Text("Notifications", style: TextStyle(color: Colors.white),),
      ),

     body:StreamBuilder(
         stream: FirebaseFirestore
             .instance
             .collection("notifications")
             .where("guestid", isEqualTo: widget.guestid)
             .where("notificationStatus", isEqualTo: "new")
             .orderBy("timestamp", descending: true)
             .snapshots(),
         builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){

           if(!snapshot.hasData)
           {

             return Center(
               child: CircularProgressIndicator(),
             );
           }
           else
           {


             return  ListView.builder(
               itemCount: snapshot.data?.size,
               itemBuilder: (context, index){

                 QueryDocumentSnapshot<Object?>? course = snapshot.data?.docs[index];

                 return InkWell(
                   onTap: (){


                   },
                   child: Notification_In(
                       notificationType:course?['notificationType'],
                       notificationStatus:course?['notificationStatus'],
                       groupid:course?['groupid'],
                       groupname:course?['groupname'],
                       guestid:course?['guestid'],
                        phone_number: widget.guestid,
                        notifications_id: course!.id,
                        user_name: widget.guestname,),

                 );

               },
             );
           }

         }
     )


    );
  }
}
