import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:jiraniapp/pages/grouppage.dart';
import 'package:jiraniapp/pages/loading_screen.dart';
import 'package:jiraniapp/pages/selectContact.dart';
import 'package:line_icons/line_icons.dart';
import 'package:share/share.dart';

import '../models/contactfr.dart';
import '../widget/contactcard.dart';
import '../widget/groupactivitycards.dart';
import 'home.dart';
import 'login.dart';
import 'my_contributions.dart';

class GroupInfo extends StatefulWidget {
  const GroupInfo({Key? key, required this.groupId}) : super(key: key);
  final String groupId;

  @override
  State<GroupInfo> createState() => _GroupInfoState();
}

class _GroupInfoState extends State<GroupInfo> {

  List<ContactModel> contributors = [

  ];

  final db = FirebaseFirestore.instance;
  String imagelink = "";
  String groupname = "";
  bool onloaded = false;
  String uidAccess = "0";
  String user_name = "";
  List <Contact>? contacts2;
  bool isLoading = true;

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
  List<dynamic> contributors_numbers = [];

  Future<void> getGroupDetails() async {
    setState(
        (){
          contributors.clear();
        }
    );
    final docref = db.collection("GroupData").doc(widget.groupId);
    await docref.get().then((res) {

      if(res.data() != null)
      {
        setState(
                (){
              groupname=  res.data()!['groupname'];
              imagelink=  res.data()!['groupprofilepic'];
              contributors_numbers = res.data()!['contributors'];
            }
        );
        getUserData();
      }

    });

  }

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

        getContact();
      }

    });



  }

  Future<void> getContact() async
  {
    if(await FlutterContacts.requestPermission())
    {
      setState(
              (){
            contacts2?.clear();
          }
      );
      int i = 1;
      contacts2 = await FlutterContacts.getContacts(
          withProperties: true, withPhoto: false
      );
      contacts2?.forEach((element) async {
        // print("${element.phones[0].normalizedNumber}/n ${element.displayName}" );

        try{

          if((element.phones[0].normalizedNumber.toString()) != null &&
              element.phones[0].normalizedNumber.toString().trim().isNotEmpty &&
              element.phones[0].normalizedNumber.toString().length<15
          )
          {
            print(element.phones[0].normalizedNumber.toString());
            final docref = db.collection("userdd").doc(element.phones[0].normalizedNumber.toString());
            await docref.get().then((res) =>{
              print("matching"),
              if(res.data() != null)
                {
                  if(res.data()!['uid'] == uidAccess)
                    {

                    }
                  else
                    {
                      print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>${contributors_numbers[0]}"),
                      if(contributors_numbers.contains(res.data()!['phone']))
                        {
                          print(" adding <<<<<<<<<<<<<>>>>>>>>>>>>>>${contributors_numbers[0]}"),
                          setState(
                                  ()
                              {
                                contributors.add(
                                  ContactModel(
                                    name: element.displayName,
                                    uid: res.data()!['uid'],
                                    phone:  res.data()!['phone'],
                                    select: false,
                                  ),
                                );
                                i++;
                                print("${i} value of i ${contacts2!.length} value of contact2.length");
                                if( contacts2!.length == i )
                                {
                                  setState(
                                          (){
                                        onloaded = true;
                                      }
                                  );
                                }

                              }
                          ),
                        }

                    }
                }
              else
                {
                  i++,
                  if( contacts2!.length == i )
                    {
                  setState(
                      (){
                        onloaded = true;
                      }
                  )
                    }
                }
            }, onError: (e) {

            });
          }
        }
        catch(e){

        }
      });

    }
  }

  Future<void> updateDataToFirestore(new_contributors) async {
    setState(
            () {
          isLoading = true;
        }
    );
   final update_contributors =  <String, dynamic>{

     "contributors": FieldValue.arrayUnion(new_contributors),
   };

   await  db.collection("GroupData").doc(widget.groupId).update(
        update_contributors
    ).then((value){
      getGroupDetails();
    });
  }
  Future<void> Delete_Data_inFirestore() async {
    setState(
            () {
          isLoading = true;
        }
    );
   final update_contributors =  <String, dynamic>{

     "contributors": FieldValue.arrayRemove([uidAccess]),
   };

   await  db.collection("GroupData").doc(widget.groupId).update(
        update_contributors
    ).then((value){
     Navigator.of(context).push(
         MaterialPageRoute
           (builder: (context)=>GroupPage()));
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
        () async {
      await checkAuth();
      await getGroupDetails();

    }();
  }
  @override
  Widget build(BuildContext context) {
    return (contributors.length == 0 ) ? Loading_Screen() :
    Scaffold(
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
            Text(groupname,
                style:TextStyle(
                  color: Colors.white,
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                )),
            Text("${contributors.length} contributors",
                style:TextStyle(
                  color:Colors.white,
                  fontSize: 13,
                )),

          ],
        ),

      ),

      body: Column(

        children: [
          Card(
            color: Colors.white,
            child: Column(
              children: [
                InkWell(
                  onTap: (){

                    if(uidAccess != "0")
                      {
                        Delete_Data_inFirestore();
                      }

                  },
                  child: ListTile(
                    leading: Icon(Icons.logout, color: Colors.red,),

                    title: Text("Exit Group",
                        style:TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold
                        )),
                  ),
                ),
              ],
            ),
          ),
          Card(
            color: Colors.white,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 40,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("${contributors.length} contributors", style:TextStyle(
                            color: Colors.black,

                          )),
                          InkWell(
                            onTap: (){

                            },
                              child: Icon(Icons.search, color: Colors.black,)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      Expanded(
        child: ListView.builder(
    itemCount: contributors.length+1,
    itemBuilder: (context,index) {

        if(index == 0)
        {
          return Container(
// remeber to change this to check if admin
            height: contributors.length > 0 ? 170 :0,
            child: Column(
              children: [
                InkWell(
                    onTap:() async {


                    List<ContactModel> contactstadd =
                    await Navigator.push(context, MaterialPageRoute(builder: (context)=>SelectContact(

                      )));

                    if(contactstadd.length > 0)
                    {

                      List<String> new_contributors_numbers = [];

                      contactstadd.forEach((element) {

                        if(!contributors_numbers.contains(element.phone))
                          {
                            new_contributors_numbers.add(element.phone);
                            print("element.phone>>>>>>>>>>>>>>>>>>>>>>${element.phone}");
                          }
                      });

                     await updateDataToFirestore(new_contributors_numbers);

                      // add data to firebase
                    }
                          },
                    child: AddParticipants()),
                SizedBox(height: 20,),
                InkWell(
                    onTap:() async {

                      await Share.share("you were invited to join ${groupname} on jirani app if you dont have the app download it on ...");
                            },
                    child: LinkInvite()
                ),
              ],
            ),
          );
        }
        return InkWell(
            onTap: (){
              if(contributors[index-1].select == false)
              {
                setState(
                        ()
                    {
                      contributors[index-1].select = true;
                     // groups.add(contactsrr[index-1]);
                    }
                );
              }
              else
              {
                setState(
                        ()
                    {
                      contributors[index-1].select = false;
                     // groups.remove(contactsrr[index-1]);
                    }
                );
              }
            },
            child: ContactCard(contact: contributors[index-1]));
    }
        ),
      ),

        ],
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
