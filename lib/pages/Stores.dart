import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:jiraniapp/widget/stores_category_card.dart';
import 'package:line_icons/line_icons.dart';

import '../models/service_list_display.dart';
import '../models/stores_model.dart';
import '../widget/categorycard.dart';
import '../widget/store_display_card.dart';
import '../widget/taskcard.dart';
import 'filtered_stores.dart';
import 'login.dart';

class StoresList extends StatefulWidget {
  const StoresList({Key? key}) : super(key: key);

  @override
  State<StoresList> createState() => _StoresListState();
}

class _StoresListState extends State<StoresList> {

  List<Store_Model> category_stores_display = [];
  List<String> categories_tracker = [];
  List<Store_Model> stores_for_display = [];

  final db = FirebaseFirestore.instance;
  String uidAccess = "0";
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
        get_All_Stores();
        print("!!!!!!!!!!+++++++++++++++++++++${user.phoneNumber!}");
      }
      else{
        setState(
                (){
              isLoading = false;
            }
        );
        Navigator.of(context).push(
            MaterialPageRoute
              (builder: (context)=>LoginScreen()));
      }
    });
    print("!!!!!!!!!!*********************************************${uidAccess}");

  }

  Future<void> get_All_Stores() async {

    final service_listings = db.collection("StoreData");


    await service_listings.get().then((ref){
      print("redata 1${ref.docs}");
      setState(
              (){
            ref.docs.forEach((element) {
              stores_for_display.add(
                  Store_Model(
                      store_location:
                      (element.data()['location']["address_components"][2][ "short_name"]).toString()+
                          (element.data()['location']["address_components"][5][ "short_name"]).toString()+
                          (element.data()['location']["address_components"][6][ "short_name"]).toString()
                      ,
                      storename: element.data()['storename'],
                      store_cloud_id: element.id,
                      store_phone: element.data()['phone'],
                      store_category: element.data()['storecategory'],
                      store_photo_links:element.data()['photosLinks'],
                      createdby_store: element.data()['createdby'],
                      store_description: element.data()['storedescription']
                  )

              );

              if(!categories_tracker.contains(
                element.data()['storecategory']

              ))
              {
                categories_tracker.add(element.data()['storecategory']);
                print("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& contains");
                category_stores_display.add(
                    Store_Model(
                        store_location:
                        (element.data()['location']["address_components"][2][ "short_name"]).toString()+
                            (element.data()['location']["address_components"][5][ "short_name"]).toString()+
                            (element.data()['location']["address_components"][6][ "short_name"]).toString()
                        ,
                        storename: element.data()['storename'],
                        store_cloud_id: element.id,
                        store_phone: element.data()['phone'],
                        store_category: element.data()['storecategory'],
                        store_photo_links:element.data()['photosLinks'],
                        createdby_store: element.data()['createdby'],
                        store_description: element.data()['storedescription']
                    )
                );

              }
            });
            isLoading = false;
          }
      );
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
    Size size = MediaQuery.of(context).size;
    return isLoading ?  Center(child: CircularProgressIndicator(),)
        :Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: size.height * 0.03, horizontal: size.width * 0.045),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Stores",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.5,
                    ),
                  ),
                  CircleAvatar(
                    radius: 14,
                    backgroundImage: AssetImage("assets/catering.jfif"),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.045),
              child: Container(
                height: size.height * 0.07,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black54,
                      blurRadius: 7,
                      spreadRadius: 0,
                      offset: Offset(-2, 2),
                    ),
                  ],
                ),
                child: TextField(
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.blue,
                    ),
                    contentPadding: EdgeInsets.all(size.width * 0.04),
                    border: InputBorder.none,
                    hintText: "Filter Store By Category?",
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: size.height * 0.04,
                horizontal: size.width * 0.045,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Stores",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2.5,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                          MaterialPageRoute
                            (builder: (context)=>Filtered_Stores(store_search_criteria: 'All-stores',)));
                    },
                    child: Text(
                      "See all",
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.20,
              margin: EdgeInsets.symmetric(vertical: 1),
              child:  ListView.builder(
                  itemCount: stores_for_display.length,
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 3),
                  itemBuilder: (context, index) {
                    return Store_Display_Card( store_model: stores_for_display[index],);
                  }),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: size.height * 0.04,
                horizontal: size.width * 0.045,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Categories",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2.5,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      print("pressed");
                    },
                    child: Text(
                      "See all",
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: size.height * 0.35,
              margin: EdgeInsets.all(6),
              child: ListView.builder(
                  itemCount: category_stores_display.length,
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 3),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {

                    return Store_Category_Card( store_model: category_stores_display[index],);

                  }),
            ),
          ],
        ),
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
            ]
        ),
      ),
    );
  }
}
