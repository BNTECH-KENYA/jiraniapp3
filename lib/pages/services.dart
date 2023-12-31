
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:share/share.dart';
import '../models/categoryservices.dart';
import '../models/service_list_display.dart';
import '../models/taskModel.dart';
import '../widget/categorycard.dart';
import '../widget/service_category_card.dart';
import '../widget/service_display_card.dart';
import '../widget/taskcard.dart';
import 'addService.dart';
import 'filtered_services.dart';
import 'home.dart';
import 'loading_screen.dart';
import 'login.dart';
import 'my_contributions.dart';

class ServiceHome extends StatefulWidget {
  ServiceHome({Key? key}) : super(key: key);

  @override
  _ServiceHomeState createState() => _ServiceHomeState();
}

class _ServiceHomeState extends State<ServiceHome> {
  int _currentindex = 0;
  List<Service_List_Display> services_for_display = [];
  List<Service_List_Display> categories_display = [];
  List<String> categories_tracker = [];


  //firebase pull data
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
        get_All_Services();
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

  Future<void> get_All_Services() async {

    final service_listings = db.collection("ServiceData");


    await service_listings.get().then((ref){
      print("redata 1${ref.docs}");
      setState(
              (){
            ref.docs.forEach((element) {
              services_for_display.add(
                  Service_List_Display(
                      service_location:
                      element.data()['location']["formatted_address"],
                      service_name: element.data()['servicename'],
                      service_cloud_id: element.id,
                      phone: element.data()['phone'],
                      service_category: element.data()['category'],
                      service_photo_links:element.data()['photosLinks'],
                      created_by:element.data()['createdby'],
                  )

              );

              if(!categories_tracker.contains(

                  element.data()['category']
              ))
                {
                  categories_tracker.add(element.data()['category']);
                  categories_display.add(
                      Service_List_Display(
                          service_location: element.data()['location']["formatted_address"],

                          service_name: element.data()['servicename'],
                          service_cloud_id: element.id,
                          phone: element.data()['phone'],
                          service_category: element.data()['category'],
                          service_photo_links:element.data()['photosLinks'],
                          created_by:element.data()['createdby'],
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
    return isLoading ? Loading_Screen()
        :Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute
                  (builder: (context)=>AddService()));
          },
          child: Icon(Icons.add, color:Colors.white),

        ),
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
                    "Services",
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
                    hintText: "What service you looking for?",
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
                    "Services",
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
                            (builder: (context)=>Filtered_Services(search_criteria: 'All-services',)));
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
              child: ListView.builder(
                  itemCount: services_for_display.length,
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 3),
                  itemBuilder: (context, index) {
                   return Service_Display_Card(service_list: services_for_display[index],);
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
               itemCount: categories_display.length,
                 physics: BouncingScrollPhysics(),
                 padding: EdgeInsets.symmetric(horizontal: 3),
                 scrollDirection: Axis.horizontal,
                 itemBuilder: (context, index) {

                 return Service_Category_Card(service_model: categories_display[index],);

           }),
           ),
          ],
        ),
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