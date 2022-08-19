import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:share/share.dart';

import 'edit_service.dart';
import 'home.dart';
import 'login.dart';
import 'my_contributions.dart';

class ServiceInfo extends StatefulWidget {
  const ServiceInfo({Key? key,  required this.groupServiceid}) : super(key: key);
  final String groupServiceid;


  @override
  State<ServiceInfo> createState() => _ServiceInfoState();
}

class _ServiceInfoState extends State<ServiceInfo> {
  final db = FirebaseFirestore.instance;
  String service_name = "";
  bool onloaded = false;
  bool ownservice = false;
  String uidAccess = "0";
  String service_description = "";
  String phone_nuber = "";
  var location_data = "";
  List photosLinks = [];



  Future<void> getServiceDetails()
  async {
    final docref = db.collection("ServiceData").doc(widget.groupServiceid);
    await docref.get().then((res) {

      if(res.data() != null)
      {
        setState(
                (){
              service_name=  res.data()!['servicename'];
              service_description=  res.data()!['servicedesc'];
              phone_nuber=  res.data()!['phone'];
              location_data=  res.data()!['location']["formatted_address"];

                  photosLinks=  res.data()!['photosLinks'];
              onloaded = true;
              if(uidAccess == phone_nuber)
                {
                  ownservice= true;
                }
            }
        );


      }

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
        getServiceDetails();
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

    return Scaffold(

      backgroundColor: Colors.white,


      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0.0,
        iconTheme: IconThemeData(opacity: 20, color: Colors.white),
        actions: [
          ownservice ? IconButton(
              onPressed: (){
                Navigator.of(context).push(
                    MaterialPageRoute
                      (builder: (context)=>EditServiceInfo(serviceEditindId: widget.groupServiceid,)));
              },
              icon: Icon(Icons.edit, color: Colors.white,)): Container(),
        ],
      ),
      body: onloaded? Container(
        width:MediaQuery.of(context).size.width ,
        height: MediaQuery.of(context).size.height,

        child: Column(
          children:<Widget> [
            Container(
              height: MediaQuery.of(context).size.height* 0.3,
              width: double.infinity,
              child: Container(
              child: Center(
                  child: ListView(
                    children: [
                      onloaded == false ? SizedBox(
                        height:  MediaQuery.of(context).size.height* 0.3,
                        width: double.infinity,
                        child: Carousel(
                          dotSize: 6.0,
                          dotSpacing: 15.0,
                          dotPosition: DotPosition.bottomCenter,
                           images: [
                            Image.asset('assets/catering.jfif', fit: BoxFit.cover),
                            Image.asset('assets/catering.jfif', fit: BoxFit.cover),
                            Image.asset('assets/catering.jfif', fit: BoxFit.cover),
                          ],
                        ),
                      ):SizedBox(
                        height: MediaQuery.of(context).size.height* 0.3,
                        width: double.infinity,
                        child: (photosLinks.length== 1)? Carousel(
                          dotSize: 6.0,
                          dotSpacing: 15.0,
                          dotPosition: DotPosition.bottomCenter,
                          images: [

                                Image.network(photosLinks[0], fit: BoxFit.cover),


                          ],
                        ):(photosLinks.length== 2)? Carousel(
                          dotSize: 6.0,
                          dotSpacing: 15.0,
                          dotPosition: DotPosition.bottomCenter,
                          images: [

                            Image.network(photosLinks[0], fit: BoxFit.cover),
                            Image.network(photosLinks[1], fit: BoxFit.cover),


                          ],
                      ):(photosLinks.length== 3)?Carousel(
                          dotSize: 6.0,
                          dotSpacing: 15.0,
                          dotPosition: DotPosition.bottomCenter,
                          images: [

                            Image.network(photosLinks[0], fit: BoxFit.cover),
                            Image.network(photosLinks[1], fit: BoxFit.cover),
                            Image.network(photosLinks[2], fit: BoxFit.cover),

                          ],
                        ):(photosLinks.length== 4)?Carousel(
                          dotSize: 6.0,
                          dotSpacing: 15.0,
                          dotPosition: DotPosition.bottomCenter,
                          images: [
                            Image.network(photosLinks[0], fit: BoxFit.cover),
                            Image.network(photosLinks[1], fit: BoxFit.cover),
                            Image.network(photosLinks[2], fit: BoxFit.cover),
                            Image.network(photosLinks[3], fit: BoxFit.cover),

                          ],
                        ):Carousel(
                          dotSize: 6.0,
                          dotSpacing: 15.0,
                          dotPosition: DotPosition.bottomCenter,
                          images: [

                          ],
                        ) )
                    ],
                  )),
            ),),
            Container(

                child: Container(
              color: Colors.white,

              child: ListTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:<Widget> [

                    SizedBox(height: 20,),
                    Text(
                      service_name,
                      style: TextStyle
                        (
                        fontSize: 20,
                        fontWeight: FontWeight.bold,

                      ),
                    ),
                    SizedBox(height: 20,),

                  ],
                ),
              ),
            )),
            Text("About Us...",
                style:TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,

                )),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8),
              child: Text(service_description,
              style: TextStyle(
                fontSize: 16,
              ),),
            ),
            ListTile(
              leading: CircleAvatar(
                radius: 30,
                child: Icon(Icons.location_on_outlined, color:Colors.white),
                backgroundColor: Colors.blue,

              ),
              title: Text("Located in",
                  style:TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                  )),
              subtitle: Text(location_data,
                  style:TextStyle(
                      fontSize: 13
                  )),
              trailing: Icon(Icons.location_on_outlined, color: Colors.blue,),
            ),

            InkWell(
              onTap: (){
                // move to contact page
              },
              child: ListTile(
                leading: CircleAvatar(
                  radius: 30,
                  child: Icon(Icons.call, color:Colors.white),
                  backgroundColor: Colors.blue,

                ),
                title: Text("Call us on",
                    style:TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                    )),
                subtitle: Text(phone_nuber,
                    style:TextStyle(
                        fontSize: 13
                    )),
                trailing: Icon(Icons.call, color: Colors.blue,),
              ),
            ),
          ],
        ),
      ): Center(child: CircularProgressIndicator(),),

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
