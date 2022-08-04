import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:share/share.dart';

import '../models/service_list_display.dart';
import '../widget/service_category_card.dart';
import 'home.dart';
import 'login.dart';
import 'my_contributions.dart';

class All_Service_Categories extends StatefulWidget {
  const All_Service_Categories({Key? key}) : super(key: key);

  @override
  State<All_Service_Categories> createState() => _All_Service_CategoriesState();
}

class _All_Service_CategoriesState extends State<All_Service_Categories> {
  
  List<Service_List_Display> all_service_categories = [];

  String search_criteria = "Services";
  String uidAccess = "0";
  bool isLoading = true;
  final db = FirebaseFirestore.instance;

 Future<void> get_All_Categories()
  async {
    final service_listings = db.collection("ServiceData");

    await service_listings.get().then((ref) {
      print("redata 1${ref.docs}");
      setState(
              () {
            ref.docs.forEach((element) {
              all_service_categories.add(
                  Service_List_Display(
                      service_location:
                      (element.data()['location']["address_components"][2][ "short_name"]).toString()+
                          (element.data()['location']["address_components"][5][ "short_name"]).toString()+
                          (element.data()['location']["address_components"][6][ "short_name"]).toString()
                      ,
                      service_name: element.data()['servicename'],
                      service_cloud_id: element.id,
                      phone: element.data()['phone'],
                      service_category: element.data()['category'],
                      service_photo_links:element.data()['photosLinks'],
                      created_by: element.data()['createdby']

                  )

              );
            });
            isLoading = false;
          }
      );
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
                (){
              uidAccess =  user.phoneNumber!;
            }
        );
        get_All_Categories();
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
    return isLoading?
        Center(child: CircularProgressIndicator(),)
    :Scaffold(

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
            Text("ALL Service Categories",
                style:TextStyle(
                  color: Colors.white,
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                )),


          ],
        ),

        actions: [
          
          IconButton(
              onPressed: (){},
              icon: Icon(Icons.search, color: Colors.white,))
          
        ],
      ),

      body: Expanded(
        child: Padding(
          padding: const EdgeInsets.only(top:8.0),
          child: ListView.builder(
              itemCount:  all_service_categories.length,
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 3),
            itemBuilder: (BuildContext context, int index) { 
                
                return Service_Category_Card(service_model: all_service_categories[index],);
                
            },
            
          ),
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
