import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:jiraniapp/models/bottommodel.dart';
import 'package:jiraniapp/pages/Stores.dart';
import 'package:jiraniapp/pages/allItemsDisplay.dart';
import 'package:jiraniapp/pages/grouppage.dart';
import 'package:jiraniapp/pages/my_contributions.dart';
import 'package:jiraniapp/pages/services.dart';
import 'package:jiraniapp/widget/menuTile.dart';
import 'package:share/share.dart';
import 'package:toast/toast.dart';
import '../models/menumodel.dart';
import '../widget/bottomnavTile.dart';
import '../widget/card_design.dart';
import '../widget/icon_widget.dart';
import 'loading_screen.dart';
import 'login.dart';
import 'my_products.dart';
import 'my_profile.dart';
import 'my_services.dart';
import 'my_stores.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';

import 'notifications_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  List<MenuModel> menu_model = [
    MenuModel(
        menuinfo: "Groups", imagelink: "assets/groupsicon.png"),
  MenuModel(
        menuinfo: "Services", imagelink: "assets/services.png"),
  MenuModel(
        menuinfo: "Products", imagelink: "assets/storeicon.png"),
  MenuModel(
        menuinfo: "My Services", imagelink: "assets/my_services.png"),
  MenuModel(
        menuinfo: "My Products", imagelink: "assets/my_storeicon.png"),
    MenuModel(
        menuinfo: "About", imagelink: "assets/settingsicon.png"),
  ];

  DateTime timeBackPressed = DateTime.now();

  String uidAccess = "0";
  String username = "0";
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
        getUser_data();
      }
      else{
        Navigator.of(context).push(
            MaterialPageRoute
              (builder: (context)=>LoginScreen()));
        setState(
                (){
              isLoading = false;
            }
        );
      }
    });
    print("!!!!!!!!!!*********************************************${uidAccess}");

  }
  FirebaseFirestore db = FirebaseFirestore.instance;

 Future<void> getUser_data() async{
   print("!!!!!!!!!!*********************************************${uidAccess}");
   final docref = db.collection("userdd").doc(uidAccess);
   await docref.get().then((res) =>{
     print("matching ${res.data()}"),
     if(res.data() != null)
       {
         print("matching"),
         setState(
             ()
                 {
                   username = res.data()!['name'];
                   isLoading = false;
                 }
         ),

       }

   }, onError: (e) {

   });
  }


  Future<void> createToken ( phoneauthno)async{

    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final  fcmToken = await FirebaseMessaging.instance.getToken();

    final setdata = <String, String>{
      "authphonenumber":phoneauthno,
      "token":fcmToken!
    };

    await FirebaseFirestore.instance
        .collection('tokens')
        .doc(firebaseAuth.currentUser!.phoneNumber).set(setdata)
        .then((value) => {

      setState(
              (){
            isLoading = false;
          }
      ),

      /*
    .onError((error, stackTrace) => {
      Toast.show("Error saving Token${error}".toString(), context,duration:Toast.LENGTH_SHORT,
      gravity: Toast.BOTTOM)
      })
     */
    });
    print(fcmToken);



  }

  Future <void> check_for_token_and_update() async{

    final docref = db.collection("tokens").doc(uidAccess);
    await docref.get().then((res) async =>{
      print("matching ${res.data()}"),
      if(res.data() == null)
        {
          await createToken(uidAccess),
        }
  });
        }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();

        () async {
      await checkAuth();
    }();
  }
  @override
  Widget build(BuildContext context) {
    return isLoading ?  Loading_Screen(): WillPopScope(
      onWillPop: () async{
        final difference = DateTime.now().difference(timeBackPressed);
        final isExitWarning = difference >= Duration(seconds: 2);

        timeBackPressed = DateTime.now();

        if(isExitWarning)
        {
          Toast.show("Press Back Again To Exit".toString(), context,duration:Toast.LENGTH_SHORT,
              gravity: Toast.BOTTOM);
          return false;

        }
        else
        {

          return true;

        }
      },
      child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor:Colors.white,
            leadingWidth: 70,
            titleSpacing: 0,
            leading: Icon(Icons.menu, color: Colors.white,),
            title: Text('Home',
              style: TextStyle(
                color: Colors.black,
              ),),
            actions: [
              IconButton(
                  onPressed: () async {
                    await Share.share("link to download app");
                  },
                  icon: Icon(Icons.share, color: Colors.blue,)),
              IconButton(
                  onPressed: () {

                    Navigator.of(context).push(
                        MaterialPageRoute
                          (builder: (context)=>Notifications_Page(guestid: uidAccess, guestname: username,)));
                  },
                  icon: Icon(Icons.notifications_none, color: Colors.blue,)),

            ],
          ),
          body: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 100,
                  child: Center(
                    child: Container(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.only(left:16.0),
                        child: Text("Welcome ${username}", style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16
                        ),),
                      ),
                    ),
                  ),
                ),

                Card(
                  color: Colors.grey[100],
                  child: InkWell(
                    onTap: (){
                      Navigator.of(context).push(
                          MaterialPageRoute
                            (builder: (context)=>GroupPage()));
                    },
                    child: Container(
                      width:  double.infinity,
                      height: 150,
                      child: Center(

                        child: Container(
                          width: 50,
                          height: 70,
                          child: Column(
                            children: [
                              Image.asset("assets/group.png", width: 50,height:50,),
                              Text("Groups", style:TextStyle(
                                color: Colors.black,
                              ),),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                Column(
                  children: [
                    Container(
                      width:  double.infinity,
                      height: 150,
                      child: Row(

                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          InkWell(
                            onTap: (){
                              Navigator.of(context).push(
                                  MaterialPageRoute
                                    (builder: (context)=>ServiceHome()));
                            },

                            child: Card(
                              color: Colors.grey[100],
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.45,
                                height: 150,
                                child: Center(
                                  child: Container(
                                    width: 70,
                                    height: 70,
                                    child: Column(
                                      children: [
                                        Image.asset("assets/food-service.png", width: 50,height:50,),
                                        Text("Services", style:TextStyle(
                                          color: Colors.black,
                                        ),),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: (){
                              Navigator.of(context).push(
                                  MaterialPageRoute
                                    (builder: (context)=>All_Items()));
                            },
                            child: Card(
                              color: Colors.grey[100],
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.45,
                                height: 150,
                                child: Center(
                                  child: Container(
                                    width: 70,
                                    height: 70,
                                    child: Column(
                                      children: [
                                        Image.asset("assets/trade.png", width: 50,height:50,),
                                        Text("Products", style:TextStyle(
                                          color: Colors.black,
                                        ),),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 150,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: (){

                            },
                            child: Card(
                              color: Colors.grey[100],
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.45,
                                height: 150,
                                child: Center(
                                  child: Container(
                                    width: 70,
                                    height: 70,
                                    child: Column(
                                      children: [
                                        Image.asset("assets/information.png", width: 50,height:50,),
                                        Text("About", style:TextStyle(
                                          color: Colors.black,
                                        ),),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          InkWell(
                            onTap: (){
                              Navigator.of(context).push(
                                  MaterialPageRoute
                                    (builder: (context)=>My_Profile()));
                            },
                            child: Card(
                              color: Colors.grey[100],
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.45,
                                height: 150,
                                child: Center(
                                  child: Container(
                                    width: 70,
                                    height: 70,
                                    child: Column(
                                      children: [
                                        Image.asset("assets/user.png", width: 50,height:50,),
                                        Text("My Profile", style:TextStyle(
                                          color: Colors.black,
                                        ),),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                    ),
                  ],
                )

              ],
            ),
          ),

        bottomNavigationBar: BottomAppBar(
          color: Colors.blue,
          child: Padding(
            padding: const EdgeInsets.only(top:8.0),
            child: Container(
              height: 50,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CircleAvatar(
                    child: Icon(Icons.home, color: Colors.blue,),
                    backgroundColor: Colors.white,
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

 children: [

              Container(
                width: double.infinity,
                height: 100,
                child: Center(
                  child: Container(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.only(left:16.0),
                      child: Text("Welcome ${username}", style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16
                      ),),
                    ),
                  ),
                ),
              ),

              Card(
                color: Colors.grey[100],
                child: InkWell(
                  onTap: (){
                    Navigator.of(context).push(
                        MaterialPageRoute
                          (builder: (context)=>GroupPage()));
                  },
                  child: Container(
                    width:  double.infinity,
                    height: 150,
                    child: Center(
                      child: Text("Groups", style:TextStyle(
                        color: Colors.black,
                      ),),
                    ),
                  ),
                ),
              ),

              Column(
                children: [
                  Container(
                    width:  double.infinity,
                    height: 150,
                    child: Row(

                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      children: [
                        InkWell(
                          onTap: (){
                            Navigator.of(context).push(
                                MaterialPageRoute
                                  (builder: (context)=>ServiceHome()));
                          },

                          child: Card(
                            color: Colors.grey[100],
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.45,
                              height: 150,
                              child: Center(
                                  child: Text("Services",
                                      style:TextStyle(
                                        color: Colors.black,
                                      )
                                  )
                              ),
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: (){
                            Navigator.of(context).push(
                                MaterialPageRoute
                                  (builder: (context)=>All_Items()));
                          },
                          child: Card(
                            color: Colors.grey[100],
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.45,
                              height: 150,
                              child: Center(
                                  child: Text("Products",
                                      style:TextStyle(
                                        color: Colors.black,
                                      )
                                  )
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 150,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: (){
                            Navigator.of(context).push(
                                MaterialPageRoute
                                  (builder: (context)=>My_Services()));

                          },
                          child: Card(
                            color: Colors.grey[100],
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.45,
                              height: 150,
                              child: Center(
                                  child: Text("My Services",
                                      style:TextStyle(
                                        color: Colors.black,
                                      )
                                  )
                              ),
                            ),
                          ),
                        ),

                        InkWell(
                          onTap: (){
                            Navigator.of(context).push(
                                MaterialPageRoute
                                  (builder: (context)=>My_Products()));
                          },
                          child: Card(
                            color: Colors.grey[100],
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.45,
                              height: 150,
                              child: Center(
                                  child: Text("My Products",
                                      style:TextStyle(
                                        color: Colors.black,
                                      )
                                  )
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                  ),
                ],
              )

            ],
 */