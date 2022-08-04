import 'package:carousel_pro/carousel_pro.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:share/share.dart';

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
