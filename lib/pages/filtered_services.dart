import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:jiraniapp/pages/serviceinfo.dart';
import 'package:line_icons/line_icons.dart';
import 'package:share/share.dart';

import '../models/service_list_display.dart';
import '../widget/filtered_searches_widget.dart';
import 'home.dart';
import 'loading_screen.dart';
import 'login.dart';
import 'my_contributions.dart';

class Filtered_Services extends StatefulWidget {
  const Filtered_Services({Key? key, required this.search_criteria}) : super(key: key);
  final String search_criteria;

  @override
  State<Filtered_Services> createState() => _Filtered_ServicesState();
}

class _Filtered_ServicesState extends State<Filtered_Services> {

  List<Service_List_Display> service_filtered_list=[];
  String search_criteria = "Services";
  String uidAccess = "0";
  bool isLoading = true;
  final db = FirebaseFirestore.instance;

  Future<void> get_Filtered_Services() async {

    if( widget.search_criteria == "All-services"){
      // get all service

      final service_listings = db.collection("ServiceData");

      await service_listings.get().then((ref) {
        print("redata 1${ref.docs}");
        setState(
                () {
              ref.docs.forEach((element) {
                service_filtered_list.add(
                    Service_List_Display(
                        service_location:element.data()['location']["formatted_address"],
                        service_name: element.data()['servicename'],
                        service_cloud_id: element.id,
                        phone: element.data()['phone'],
                        service_category: element.data()['category'],
                        service_photo_links:element.data()['photosLinks'],
                        created_by: element.data()['createdby']


                    )

                );
              });
              search_criteria = "${widget.search_criteria.split("-")[0]} ${widget.search_criteria.split("-")[1]}";
              isLoading = false;
            }
        );
      });

    }
    else if(widget.search_criteria.split("-")[0] == "category")
      {
        final service_listings = db.collection("ServiceData").where("category", isEqualTo:widget.search_criteria.split("-")[1] );


        await service_listings.get().then((ref) {
          print("redata 1${ref.docs}");
          setState(
                  () {
                    if(ref.docs.length == 0) Navigator.pop(context);


                ref.docs.forEach((element) {
                  service_filtered_list.add(
                      Service_List_Display(
                          service_location:element.data()['location']["formatted_address"],
                          service_name: element.data()['servicename'],
                          service_cloud_id: element.id,
                          phone: element.data()['phone'],
                          service_category: element.data()['category'],
                          service_photo_links:element.data()['photosLinks'],
                          created_by: element.data()['createdby']


                      )

                  );
                });

                    search_criteria = "${widget.search_criteria.split("-")[1]} Services";
                    isLoading = false;
                  }
          );
        });
        
      }
  }
  // all services
  //categories

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
        get_Filtered_Services();
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
    return isLoading ? Loading_Screen()
        : Scaffold(
      appBar:  AppBar(
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
            Text(search_criteria,
                style:TextStyle(
                  color: Colors.white,
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                )),
            Text("${service_filtered_list.length} Services",
                style:TextStyle(
                  color:Colors.white,
                  fontSize: 13,
                )),

          ],
        ),

        actions: [
          IconButton(
              onPressed: (){},
              icon: Icon(Icons.search, color:Colors.white))
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ListView.builder(
                itemCount: service_filtered_list.length,
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 3),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: (){
                      Navigator.of(context).push(
                          MaterialPageRoute
                            (builder: (context)=>ServiceInfo(groupServiceid: service_filtered_list[index].service_cloud_id,)));
                    },
                    child: Searched_Data_Filteres(
                      photolink: service_filtered_list[index].service_photo_links[0].toString(),
                      desccription: "Located at ${service_filtered_list[index].service_location}",
                       itemname: '${service_filtered_list[index].service_name}',)
                  );
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(top:0.0),
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

/*

 Container(
                      margin: EdgeInsets.only(top:16),
                      padding: EdgeInsets.only(left: 20),
                      child: Stack(
                        children: [
                          Container(
                            padding: EdgeInsets.only(left: 30),
                            child: Card(
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                height: 145,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8)),
                                child: Container(
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black12.withOpacity(0.1),
                                        blurRadius: 1,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  padding: EdgeInsets.only(left: 80),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Text(
                                        "${service_filtered_list[index].service_name}",
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.only(
                                          left: 10,
                                          bottom: 15,
                                        ),
                                        child: Text(

                                          "${service_filtered_list[index].service_location}",
                                          style: TextStyle(
                                            color: Colors.brown,
                                          ),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                        children: [
                                          /*
                                          Text(
                                              "Jobs\n${freelancerlist[index].jobsdone}"),
                                          Text(
                                              "Ratings\n${freelancerlist[index].rating}"),
                                          Text(
                                              "Salary\n${freelancerlist[index].sal}"),

                                           */
                                        ],
                                      ),
                                      SizedBox(
                                        height: 2,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(""),
                                          IconButton(
                                              onPressed: (){


                                              }, icon: Icon(Icons.read_more_sharp, color:Colors.blue)),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.4,
                          ),

                          Container(
                            alignment: Alignment.centerLeft,
                            height: 150,
                            width: 90,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: NetworkImage(
                                        service_filtered_list[index].service_photo_links[0].toString()))),
                          ),
                        ],
                      ),
                    ),
 */