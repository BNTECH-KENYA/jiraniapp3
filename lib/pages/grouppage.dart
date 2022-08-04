import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
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
          leading: InkWell(
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
              Text("${groupsfromdb.length} groups",
                  style:TextStyle(
                    color:Colors.white,
                    fontSize: 13,
                  )),

            ],
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
              return ListView.builder(
                itemCount: snapshot.data?.size,
                itemBuilder: (context, index){
                  QueryDocumentSnapshot<Object?>? course = snapshot.data?.docs[index];
                  return GroupTile(chatModel:  ChatModel(
                      name: course?['groupname'],
                      icon: course?['groupprofilepic'],
                      time: "20:58",
                      currentMessage: course?['latestContribution'],
                      groupidmd: course!.id
                      ,select: false),);
                },
              );
            }

        }

      ),
        bottomNavigationBar:Padding(
          padding: const EdgeInsets.only(bottom:8.0, right:2.0, left:2.0),
          child: GNav(
            rippleColor: Colors.white, // tab button ripple color when pressed
            hoverColor: Colors.blueGrey, // tab button hover color
            haptic: true, // haptic feedback
            tabBorderRadius: 15,
            tabActiveBorder: Border.all(color: Colors.blue, width: 1), // tab button border
            tabBorder: Border.all(color: Colors.grey, width: 1), // tab button border
            tabShadow: [BoxShadow(color: Colors.white.withOpacity(0.5), blurRadius: 8)], // tab button shadow
            curve: Curves.easeOutExpo, // tab animation curves
            duration: Duration(milliseconds: 900), // tab animation duration
            gap: 8, // the tab button gap between icon and text
            color: Colors.grey[800], // unselected icon color
            activeColor: Colors.blue, // selected icon and text color
            iconSize: 24, // tab button icon size
            tabBackgroundColor: Colors.blue.withOpacity(0.1), // selected tab background color
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5), // navigation bar padding
            tabs: [
              GButton(
                icon: LineIcons.home,
                text: 'Home',
              ),
              GButton(
                icon: LineIcons.paypalCreditCard,
                text: 'Payments',
              ),
              GButton(
                icon: Icons.rate_review,
                text: 'Rate',
              ),
              GButton(
                icon: LineIcons.share,
                text: 'Share',
              )
            ],
            onTabChange: (index) async {
              if(index == 0)
              {
                Navigator.of(context).push(
                    MaterialPageRoute
                      (builder: (context)=>HomePage()));

              }
              else if(index == 1)
              {
                Navigator.of(context).push(
                    MaterialPageRoute
                      (builder: (context)=>My_Contributions()));
              }else if(index == 2)
              {

              }else if(index == 3)
              {
                await Share.share("link to download app");
              }
            },
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