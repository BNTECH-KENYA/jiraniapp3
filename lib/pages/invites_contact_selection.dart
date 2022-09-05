import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

import '../models/contactfr.dart';
import '../widget/contactcard.dart';
import '../widget/selectedcontributor.dart';
import 'loading_screen.dart';
import 'login.dart';

class Invite_Contacts extends StatefulWidget {
  const Invite_Contacts({Key? key, required this.groupid, required this.groupname}) : super(key: key);
  final String groupid, groupname;

  @override
  State<Invite_Contacts> createState() => _Invite_ContactsState();
}

class _Invite_ContactsState extends State<Invite_Contacts> {


  List<ContactModel> contacts = [

  ];


  List<ContactModel> addedcontacts = [
  ];

  List<ContactModel> contactstate = [];
  List<ContactModel> groups = [];
  List <Contact>? contacts2;
  bool isLoading = false;


  String uidaccess = "0";
  FirebaseFirestore db = FirebaseFirestore.instance;
  Future<void> checkAuth()async {
    await FirebaseAuth.instance
        .authStateChanges()
        .listen((user)
    {
      if(user != null)
      {

        uidaccess =  user.uid;
      }
      else{

        Navigator.of(context).push(
            MaterialPageRoute
              (builder: (context)=>LoginScreen()));
      }
    });
  }


  Future<void> getContact() async
  {
    if(await FlutterContacts.requestPermission())
    {


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

                  if(res.data()!['uid'] == uidaccess)
                    {

                    }
                  else
                    {
                      setState(
                              ()
                          {
                            contacts.add(
                              ContactModel(
                                name: res.data()!['name'],
                                uid: res.data()!['uid'],
                                phone:  res.data()!['phone'],
                                select: false,
                              ),
                            );
                            i++;
                            print("${i} value of i ${contacts2!.length} value of contact2.length");
                            if( contacts2!.length == i )
                            {
                              isLoading = false;

                            }

                          }
                      ),
                    }


                }
              else
                {
                  print("null check fbbase"+ res.data().toString() ),
                  i++,
                  print("${i} value of i ${contacts2!.length} value of contact2.length"),
                  if( contacts2!.length == i )
                    {
                      isLoading = false,
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

  Future<void> add_notifications_fb(guestid)async
  {
    final notification_data = {

      "notificationType":"invite",
      "notificationStatus":"new",
      "groupid":widget.groupid,
      "groupname":widget.groupname,
      "guestid":guestid,
      "timestamp":FieldValue.serverTimestamp()

    };

    await db.collection("notifications").add(notification_data).then(
            (DocumentReference doc) {
          //documentid2 = doc.id;
        }
    );


  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
        () async{

      setState(
              () async{
            await checkAuth();
            await getContact();
          }
      );
    }();

  }

  @override
  Widget build(BuildContext context) {
    return isLoading ? Loading_Screen():
    Scaffold(
            backgroundColor: Colors.white,
      floatingActionButton:groups.length>0 ? FloatingActionButton(
          backgroundColor: Colors.blue,
          onPressed: ()  {
            // function to sendinvites to db
            setState(
                    (){
                  isLoading= true;
                }
            );
            groups.forEach((element) async {
             await add_notifications_fb(element.phone);
            });

            setState(
                (){
                  isLoading= false;
                }
            );
            Navigator.pop(context);

          },
          child:Icon(Icons.arrow_forward,color:Colors.white)

      ):Container(),
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white
        ),
        backgroundColor: Colors.blue,
        title: Text("Send to...", style: TextStyle(
          color: Colors.white,
        ),),
        actions: [
          InkWell(
              onTap: (){

              },
              child: Icon(Icons.search, color:Colors.white)),

        ],
      ),

      body: (contacts.length >0) ? Stack(
        children: [
          ListView.builder(
              itemCount: contacts.length+1,
              itemBuilder: (context,index) {
                if(index == 0)
                {
                  return Container(
                    height: 10,
                    //height: groups.length > 0 ? 90 :10,
                  );
                }
                return InkWell(
                    onTap: (){
                      if(contacts[index-1].select == false)
                      {
                        setState(
                                ()
                            {
                              contacts[index-1].select = true;
                              groups.add(contacts[index-1]);
                            }
                        );
                      }
                      else
                      {
                        setState(
                                ()
                            {
                              contacts[index-1].select = false;
                              groups.remove(contacts[index-1]);
                            }
                        );
                      }
                    },
                    child: ContactCard(contact: contacts[index-1]));
              }
          ),
          groups.length>0 ? Positioned(
            bottom: 5,
            left: 2,
            child: Container(
              height: 50,
              child:  Card(
                color:Colors.blue,
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,

                  child: Center(
                    child: Row(
                      children: [
                        Icon(Icons.navigate_next, color: Colors.white, size: 40,),
                        Container(
                          width: MediaQuery.of(context).size.width-40,
                          height: 20,
                          child: ListView.builder(
                              itemCount: contacts.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context,index) {

                                if(contacts[index].select == true)
                                {
                                  return Text(
                                    "${contacts[index].name}",
                                    style: TextStyle(color: Colors.white)
                                    ,);
                                }
                                else
                                {
                                  return Container();
                                }
                              }
                          ),
                        ),
                      ],
                    ),
                  ),


                
                ),
              ),
          )) : Container(),
        ],
      ): Loading_Screen(),

    );
  }
}
