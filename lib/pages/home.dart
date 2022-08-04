import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:jiraniapp/models/bottommodel.dart';
import 'package:jiraniapp/pages/Stores.dart';
import 'package:jiraniapp/pages/allItemsDisplay.dart';
import 'package:jiraniapp/pages/grouppage.dart';
import 'package:jiraniapp/pages/my_contributions.dart';
import 'package:jiraniapp/pages/services.dart';
import 'package:jiraniapp/pages/shoppingPage.dart';
import 'package:jiraniapp/widget/menuTile.dart';
import 'package:share/share.dart';
import 'package:toast/toast.dart';
import '../models/menumodel.dart';
import '../widget/bottomnavTile.dart';
import '../widget/card_design.dart';
import '../widget/icon_widget.dart';
import 'login.dart';
import 'my_products.dart';
import 'my_profile.dart';
import 'my_services.dart';
import 'my_stores.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';

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
    return isLoading ?  Center(child: CircularProgressIndicator(),): WillPopScope(
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
                  onPressed: () {},
                  icon: Icon(Icons.share, color: Colors.blue,)),
              IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.notifications_none, color: Colors.blue,)),
              IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.more_vert, color: Colors.blue,)),
            ],
          ),
          body: Column(

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


                          },
                          child: Card(
                            color: Colors.grey[100],
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.45,
                              height: 150,
                              child: Center(
                                  child: Text("About",
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
                                  (builder: (context)=>My_Profile()));
                          },
                          child: Card(
                            color: Colors.grey[100],
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.45,
                              height: 150,
                              child: Center(
                                  child: Text("My Profile",
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
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              // navigation bar padding
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