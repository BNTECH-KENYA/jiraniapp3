import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:share/share.dart';
import '../models/contactfr.dart';
import '../widget/contactcard.dart';
import '../widget/selectedcontributor.dart';
import 'creategroup.dart';
import 'home.dart';
import 'login.dart';
import 'my_contributions.dart';

class CreateGroup extends StatefulWidget {
  const CreateGroup({Key? key}) : super(key: key);
  @override
  State<CreateGroup> createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {

  List<ContactModel> contactsrr = [];
  List<ContactModel> contactstate = [];
  List<ContactModel> groups = [];
  List <Contact>? contacts2;
  bool isLoading = true;


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
                                contactsrr.add(
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

    return Scaffold(
      backgroundColor:Colors.white,
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
            Text("New Group",
                style:TextStyle(
                  color: Colors.white,
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                )),
            Text("Add new Contributor",
                style:TextStyle(
                  color:Colors.white,
                  fontSize: 13,
                )),

          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              size: 26,
              color: Colors.white,),
            onPressed: (){},),

        ],
      ),
      body: (contactsrr.length >0) ? Stack(
        children: [
          ListView.builder(
              itemCount: contactsrr.length+1,
              itemBuilder: (context,index) {
                if(index == 0)
                  {
                    return Container(
                      height: groups.length > 0 ? 90 :10,
                    );
                  }
                return InkWell(
                  onTap: (){
                    if(contactsrr[index-1].select == false)
                      {
                        setState(
                            ()
                                {
                                  contactsrr[index-1].select = true;
                                  groups.add(contactsrr[index-1]);
                                }
                        );
                      }
                    else
                      {
                        setState(
                                ()
                            {
                              contactsrr[index-1].select = false;
                              groups.remove(contactsrr[index-1]);
                            }
                        );
                      }
                  },
                    child: ContactCard(contact: contactsrr[index-1]));
              }
          ),
         groups.length>0 ? Column(
            children: [
              Container(
                height: 75,
                color: Colors.white,
                child: ListView.builder(
                  itemCount: contactsrr.length,
                  scrollDirection: Axis.horizontal,
                    itemBuilder: (context,index) {

                    if(contactsrr[index].select == true)
                      {
                        return InkWell(
                          onTap: (){
                              setState(
                                      ()
                                  {
                                    groups.remove(contactsrr[index]);
                                    contactsrr[index].select = false;
                                  }
                              );
                          },
                            child: SelectedContributor(contact: contactsrr[index]));
                      }
                    else
                      {
                        return Container();
                      }
                    }
                    ),
              ),
              Divider(thickness: 1)
            ],
          ) : Container(),
        ],
      ): Center(child: CircularProgressIndicator(),),
      floatingActionButton:groups.length>0 ? FloatingActionButton(
      backgroundColor: Colors.blue,
    onPressed: (){
    Navigator.push(context, MaterialPageRoute(builder: (context)=>GroupActivation( groups:groups )));
    },
    child:Icon(Icons.group_add,color:Colors.white)

    ):FloatingActionButton(
          backgroundColor: Colors.blueGrey[200],
          onPressed: (){
          },
          child:Icon(Icons.group_add,color:Colors.white)

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
        )
    );
  }
}
