import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:intl/intl.dart';
import 'package:jiraniapp/models/grouplistmodel.dart';
import 'package:jiraniapp/pages/search-group.dart';
import 'package:jiraniapp/pages/selectContact.dart';
import 'package:jiraniapp/widget/grouptile.dart';
import 'package:line_icons/line_icons.dart';
import 'package:share/share.dart';

import '../models/chatModel.dart';
import 'createprofile.dart';
import 'home.dart';
import 'login.dart';
import 'my_contributions.dart';

class GroupPage extends StatefulWidget {
  const GroupPage({Key? key}) : super(key: key);

  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {

  final db = FirebaseFirestore.instance;

  String uidAccess = "0";
  String user_name = "";

  Future<void> getUserData()
  async {
    final docref = db.collection("userdd").doc(uidAccess);
    await docref.get().then((res) {

      if(res.data() != null)
      {
        print("###########################################${res.data()!['name']} group information");
        setState(
                (){
              user_name= res.data()!['name'];

            }
        );

      }

    });



  }

  Future<void> checkAuth()async {
    await FirebaseAuth.instance
        .authStateChanges()
        .listen((user)
     {
      if(user != null)
      {
        print("!!!!!!!!!!+++++++++++++++++++++++++++++${user.phoneNumber!}");
        setState(
            () async {

              uidAccess =  user.phoneNumber!;
              await getUserData();
            }
        );
        print("!!!!!!!!!!+++++++++++++++++++++${user.phoneNumber!}");
      }
      else{
        Navigator.of(context).push(
            MaterialPageRoute
              (builder: (context)=>LoginScreen()));
      }
    });
    print("!!!!!!!!!!*********************************************${uidAccess}");

  }
  List<GroupListModel> groupsfromdb =[];

  int group_no= 0;

  List<ChatModel> chats =[
    ChatModel(
        name: "Help Group1",
        icon: "icon",
        time: "4.00 AM",
        currentMessage: "John: contributed 6000"
        ,select: false,
        groupidmd: "John: contributed 6000"),

  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@${uidAccess}");

              () async {
                await checkAuth();
          }();

    print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@${uidAccess}");

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>CreateGroup()));
        },
        child:Icon(Icons.group_add,color:Colors.white)
      ),
        appBar: AppBar(
          backgroundColor: Colors.blue,
          leading:  InkWell(
            onTap: (){
              Navigator.pop(context);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.arrow_back,color:Colors.white,
                  size: 24,),
              ],
            ),
          ),
          title: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Groups",
                  style:TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  )),
              Text("${group_no} groups",
                  style:TextStyle(
                    color:Colors.white,
                    fontSize: 13,
                  )),

            ],
          ),


          actions: [
            Padding(
              padding: const EdgeInsets.only(right:8.0),
              child: IconButton(
                  onPressed: () {

                    Navigator.push(context, MaterialPageRoute(builder: (context)=>Groups_Search()));
                  },
                  icon:  Icon(Icons.search, color: Colors.white,),
            ),
            ),

          ],


        ),
      body:StreamBuilder(
        stream: FirebaseFirestore
            .instance
            .collection("GroupData")
            .where("contributors", arrayContains:

        {
          "phone":uidAccess,
          "name":user_name
        }
        )
             .orderBy("toppingClassifier", descending: true)
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
                  group_no =0;
                  group_no = snapshot.data!.size;
                  return GroupTile(chatModel:  ChatModel(
                      name: course?['groupname'],
                      icon: course?['groupprofilepic'],
                      time:

                      (DateFormat('dd/MMM/yyy').format(DateTime.parse((course?['toppingClassifier']).toDate().toString())))

                      ==
                          (DateFormat('dd/MMM/yyy').format(DateTime.now()))?

                      (DateFormat('hh:mm a').format(DateTime.parse((course?['toppingClassifier']).toDate().toString()))):

                      (DateFormat('dd/MMM/yyy').format(DateTime.parse((course?['toppingClassifier']).toDate().toString())))
                      ,
                      currentMessage: course?['latestContribution'],
                      groupidmd: course!.id
                      ,select: false),);
                },
              );
            }

        }
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(top:8.0),
        child: BottomAppBar(
          color: Colors.blue,
          child: Padding(
            padding: const EdgeInsets.only(top:8.0),
            child: Container(
              height: 50,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(

                    onTap: (){
                      Navigator.of(context).push(
                          MaterialPageRoute
                            (builder: (context)=>HomePage()));
                    },

                    child: Container(
                      child: Column(
                        children: [
                          Icon(Icons.home_filled, color:Colors.white),
                          Text(
                            'Home',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),

                  InkWell(

                    onTap: (){
                      Navigator.of(context).push(
                          MaterialPageRoute
                            (builder: (context)=>My_Contributions()));
                    },

                    child: Container(
                      child: Column(
                        children: [
                          Icon(Icons.payment, color:Colors.white),
                          Text(
                            'Payments',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),

                  InkWell(

                    onTap: (){

                    },

                    child: Container(
                      child: Column(
                        children: [
                          Icon(Icons.rate_review, color:Colors.white),
                          Text(
                            'Rate App',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),

                  InkWell(

                    onTap: () async {
                      await Share.share("link to download app");
                    },

                    child: Container(
                      child: Column(
                        children: [
                          Icon(Icons.share, color:Colors.white),
                          Text(
                            'Share',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
      ),


    );
  }
}

/*
 ListView.builder(
        itemCount: chats.length,
        itemBuilder: (context, index)=>GroupTile(chatModel: chats[index],),

      ),
 */