import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jiraniapp/pages/ipay_page.dart';

import '../models/messagemodel.dart';
import '../services/http_helper_ipay.dart';
import '../widget/otherCard.dart';
import '../widget/owncontributor.dart';
import 'checkout_page.dart';
import 'groupInformation.dart';
import 'login.dart';

class InGroupPage extends StatefulWidget {
  const InGroupPage({Key? key, required this.groupid}) : super(key: key);
  final String groupid;

  @override
  State<InGroupPage> createState() => _InGroupPageState();
}

class _InGroupPageState extends State<InGroupPage>{
  TextEditingController _amounttocontribute = TextEditingController();
  final db = FirebaseFirestore.instance;
    String imagelink = "";
    String groupname = "";
    bool onloaded = false;
    String uidAccess = "0";
    String user_name = "";
  late String _email = 'bngatia122@gmail.com';
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

    List<String> contributorsfrst = [];

  Future<void> getGroupDetails()

  async {

    final docref = db.collection("GroupData").doc(widget.groupid);
    await docref.get().then((res) {

      if(res.data() != null)
      {
        setState(
            (){
              groupname=  res.data()!['groupname'];
              imagelink=  res.data()!['groupprofilepic'];
            }
        );

        getUserData();
      }

    });

  } Future<void> getUserData()

  async {

    final docref = db.collection("userdd").doc(uidAccess);
    await docref.get().then((res) {

      if(res.data() != null)
      {
        print("###########################################${res.data()!['name']}");
        setState(
            (){
              user_name= res.data()!['name'];

              onloaded = true;
            }
        );


      }

    });

  }



  Future<String> add_Chat_Data()

  async {
    setState(
            (){
          onloaded = false;
        }
    );

    String documentid = "";
    final chatdetails = <String, dynamic>{

      "timestamp":FieldValue.serverTimestamp(),
      "groupuid":widget.groupid,
      "sendername": user_name,
      "message": "",
      "senderphoneno":uidAccess,
      "groupname":groupname,

    };

    await db.collection("contributionsupdate").add(chatdetails).then(
            (DocumentReference doc) async {
              documentid = doc.id;
            await  updateGroupLastText(user_name, "");
              Navigator.push(context, MaterialPageRoute(builder: (context)=>Ipay_Page(id: documentid,  uidaccessip: uidAccess, amountip:_amounttocontribute.text.toString() , emailip: _email,)));

        }
    );
    return documentid;
  }

  Future <void> updateGroupLastText(name, amount)async {

    final latupdatetext = <String, dynamic>{

      "toppingClassifier":FieldValue.serverTimestamp(),

      "latestContribution": "${name} contributed ${amount}",

    };
    await db.collection("GroupData")
        .doc(widget.groupid)
        .update(latupdatetext)
        .then((value){

      setState(
              (){
            onloaded = true;
          }
      );
    });


  }


  Future<void> display_function_dialogue() async {
   await showDialog(
       context: context,
       builder: (BuildContext context)
       {
         return AlertDialog(
           
           title: const Text("Payment confirmation"),
           content: const Text("Are you sure you want complete this transaction ?"),
           actions: [
             
             TextButton(
                 onPressed: (){
                   Navigator.of(context).pop();

                 },
         
                 child: const Text("No")),
             TextButton(
                 onPressed: () async {

                   Navigator.of(context).pop();
                   print("user name >>>>>>>>>>>>>${user_name}");

                   setState(
                       (){
                         _amounttocontribute.text = "";
                       }
                   );


                 },

                 child: const Text("Yes")),

           ],
         );
       }
   
   );
  }

  late String result = '';
  late HttpHelper helper;


  // final move

    @override
      void initState() {
        // TODO: implement initState
        helper = HttpHelper();
        super.initState();

        () async {
          await checkAuth();
          await getGroupDetails();

        }();


      }

  @override
  Widget build(BuildContext context) {
    return Stack(

      children: [
         Image.asset("assets/bg.jpeg",
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        fit:BoxFit.cover),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60),
            child: AppBar(
              backgroundColor:Colors.blue,
              leadingWidth: 70,
              titleSpacing: 0,
              leading: InkWell(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.arrow_back,color:Colors.white,
                    size: 24,),
                   onloaded?
                   CircleAvatar(
                     radius: 20,
                     backgroundImage: NetworkImage(imagelink),
                   )
                       : CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage("assets/catering.jfif"),
                    )
                  ],
                ),
              ),
              title: InkWell(
                onTap: (){

                    Navigator.push(context, MaterialPageRoute(builder: (context)=>GroupInfo(
                        groupId: widget.groupid, groupname: groupname,
                    )));

                },
                child: Container(
                  margin: EdgeInsets.all(6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(groupname,
                      style:TextStyle(
                        fontSize: 18.5,
                        fontWeight: FontWeight.bold,
                        color:Colors.white
                      ))
                    ],
                  ),
                ),
              ),
              actions: [
                PopupMenuButton<String>(
                    color:Colors.white,
                    onSelected: (value)
                    {
                      if(value == "groupinfo")
                        {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>GroupInfo(
                              groupId: widget.groupid, groupname: groupname,
                          )));
                        }
                    },
                    itemBuilder: (BuildContext context){
                      return[
                        PopupMenuItem(
                          child: Text("Group info"),
                          value:"groupinfo",
                        ),
                        PopupMenuItem(
                          child: Text("Group Media"),
                          value:"Settings",
                        ),
                        PopupMenuItem(
                          child: Text("Search"),
                          value:"Settings",
                        ),
                      ];
                    }
                )
              ],
            ),
          ),

          body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height-159,
                  child: StreamBuilder(
                      stream: FirebaseFirestore
                          .instance
                          .collection("contributionsupdate")
                          .where("groupuid", isEqualTo: widget.groupid)
                          .orderBy("timestamp", descending: false)
                          .snapshots(),

                      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot)
                      {
                        if(!snapshot.hasData)
                          {
                            return Center(child: CircularProgressIndicator(),);
                          }

                       return ListView.builder(
                            shrinkWrap: true,
                         itemCount: snapshot.data?.size,
                         itemBuilder: (context, index){
                           QueryDocumentSnapshot<Object?>? course = snapshot.data?.docs[index];

                           if(course?['message'] !="" )
                           {
                             if(course?['senderphoneno'] == uidAccess)
                             {

                               return OwnMessageCard(messageModel:  MesssageModel(
                                   timestamp: (DateFormat('dd/MMM/yyy').format(DateTime.parse((course?['timestamp']).toDate().toString())))

                                       ==
                                       (DateFormat('dd/MMM/yyy').format(DateTime.now()))?

                                   (DateFormat('hh:mm a').format(DateTime.parse((course?['timestamp']).toDate().toString()))):

                                   (DateFormat('dd/MMM/yyy hh:mm a').format(DateTime.parse((course?['timestamp']).toDate().toString()))),
                                   name: course?['sendername'].split('-')[0],
                                   message: "you contributed ${course?['message']}"
                               ),);

                             }
                             else
                             {
                               return ReplCard(messageModel:  MesssageModel(
                                   timestamp: (DateFormat('dd/MMM/yyy').format(DateTime.parse((course?['timestamp']).toDate().toString())))

                                       ==
                                       (DateFormat('dd/MMM/yyy').format(DateTime.now()))?

                                   (DateFormat('hh:mm a').format(DateTime.parse((course?['timestamp']).toDate().toString()))):

                                   (DateFormat('dd/MMM/yyy hh:mm a').format(DateTime.parse((course?['timestamp']).toDate().toString()))),
                                   name: course?['sendername'].split('-')[0],
                                   message: "${course?['sendername']..split('-')[0]} contributed ${course?['message']}"),);
                             }
                           }
                           else
                             {
                               return Container();
                             }



                         },

                        );
                      },

                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width-60,
                        child: Card(
                          margin: EdgeInsets.only(left: 2, right: 2, bottom: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25)
                          ),
                          child: TextFormField(
                                textAlignVertical:TextAlignVertical.center ,
                                keyboardType: TextInputType.number,
                                controller: _amounttocontribute,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText:"Enter your contributions",
                                  prefixIcon: IconButton(
                                    icon: Icon(
                                      Icons.keyboard
                                    ),
                                    onPressed: (){

                                    },
                                  ),
                                  contentPadding: EdgeInsets.all(5)
                                ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only( bottom: 8, right: 5, left:2),
                        child: CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.blue,
                          child: IconButton(
                            onPressed: () async {
                              if(_amounttocontribute.text.toString().isEmpty)
                              {

                              }
                              else if(uidAccess == "0"){

                              }
                              else if(user_name == "0"){

                              }
                              else
                                {
                                  await add_Chat_Data();


                                }

                            },
                            icon: Icon(Icons.send,size:36, color:Colors.white),

                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
