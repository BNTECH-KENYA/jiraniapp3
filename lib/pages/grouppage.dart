import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:intl/intl.dart';
import 'package:jiraniapp/models/grouplistmodel.dart';
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

  Future<void> checkAuth()async {
    await FirebaseAuth.instance
        .authStateChanges()
        .listen((user)
     {
      if(user != null)
      {
        print("!!!!!!!!!!+++++++++++++++++++++++++++++${user.phoneNumber!}");
        setState(
            (){
              uidAccess =  user.phoneNumber!;
            }
        );
        getGroupListings();
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

  Future<void> getGroupListings() async {

    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~!!!!!!!!!!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${uidAccess}");

    final groupListingdb = db.collection("GroupData");
    final groupListing = groupListingdb.where("contributors", arrayContains: uidAccess.toString());
    print("checking if group data is workng  1${groupListing}");

    await groupListing.get().then((ref){
      print("redata 1${ref.docs}");
      setState(
              (){
                ref.docs.forEach((element) {
                  groupsfromdb.add(
                      GroupListModel(
                          groupName: element.data()['groupname'],
                          groupid: element.id.toString()));
                  print("checking if group data is workng  ${element.data()['groupname']}");
                });
          }
      );
    });
  }


  List<ChatModel> chats =[
    ChatModel(
        name: "Help Group1",
        icon: "icon",
        time: "4.00 AM",
        currentMessage: "John: contributed 6000"
        ,select: false,
        groupidmd: "John: contributed 6000"),

  ];

  bool searchToggle = false;

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
          backgroundColor: !searchToggle? Colors.blue:Colors.white,
          leading:  InkWell(
            onTap: (){
              Navigator.pop(context);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              !searchToggle ?  Icon(Icons.arrow_back,color:Colors.white,
                  size: 24,):Icon(Icons.arrow_back,color:Colors.black87,
                size: 24,) ,
              ],
            ),
          ),
          title:!searchToggle ?  Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Groups",
                  style:TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  )),
              Text("${groupsfromdb.length} groups",
                  style:TextStyle(
                    color:Colors.white,
                    fontSize: 13,
                  )),

            ],
          ): Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: TextFormField(
              decoration: InputDecoration(
                hintStyle: TextStyle(
                  color: Colors.black87,

                ),
                hintText: "Search",
                prefix: Icon(Icons.search, color: Colors.white,)
              ),
            ),
          ),


          actions: [
            Padding(
              padding: const EdgeInsets.only(right:8.0),
              child: IconButton(
                  onPressed: () {

                    setState(
                            (){
                          searchToggle = !searchToggle;
                        }
                    );
                  },
                  icon: !searchToggle? Icon(Icons.search, color: Colors.white,):Icon(Icons.cancel, color: Colors.grey,) ),
            ),

          ],

          bottom: PreferredSize(
            preferredSize: Size(double.infinity, 20),
            child: SizedBox(height: 20,),

          ),

        ),
      body:StreamBuilder(
        stream: FirebaseFirestore
            .instance
            .collection("GroupData")
            .where("contributors", arrayContains: uidAccess)
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