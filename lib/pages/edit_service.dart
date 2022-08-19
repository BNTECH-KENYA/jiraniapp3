import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:jiraniapp/pages/edit_item_photoas.dart';
import 'package:jiraniapp/pages/serviceinfo.dart';
import 'package:line_icons/line_icons.dart';
import 'package:share/share.dart';

import '../firebasest/storage.dart';
import 'group_category_page.dart';
import 'home.dart';
import 'loading_screen.dart';
import 'login.dart';
import 'my_contributions.dart';

class EditServiceInfo extends StatefulWidget {
  const EditServiceInfo({Key? key, required this.serviceEditindId}) : super(key: key);
  final String serviceEditindId;

  @override
  State<EditServiceInfo> createState() => _EditServiceInfoState();
}

class _EditServiceInfoState extends State<EditServiceInfo> {

  FirebaseFirestore db = FirebaseFirestore.instance;

  TextEditingController _controllername = TextEditingController();
  TextEditingController _controllerdesc = TextEditingController();
  TextEditingController _phoneNumberSet = TextEditingController();
  String _category = "not selected";

  String tappedLocation = "not selected";
  List<File> ? photoFiles;

  String countryname = "";
  String countrycode = "";
  String uidAccess = "0";

  bool isLoading = false;
  var locationinfoval;
  List ? fileDownloadUris= [];
  final storage _storage = storage();

  Future<String> uploadServiceData(servicename,phone, servicedesc, location)
  async {

    String documentid2 = "";
    final groupinfo = <String, dynamic>{


      "servicename":_controllername.text.toString(),
      "phone":countrycode+_phoneNumberSet.text.toString(),
      "servicedesc":_controllerdesc.text.toString(),
      "location": locationinfoval,

    };

    await db.collection("ServiceData").doc(widget.serviceEditindId).update(groupinfo).then((value){


      setState(
          (){
            isLoading = false;

          }
      );
    });
    return documentid2;

  }

  Future<void> getOneServiceDetails()
  async {
    final docref = db.collection("ServiceData").doc(widget.serviceEditindId);
    await docref.get().then((res) {

      if(res.data() != null)
      {
        setState(
                (){
              _controllername.text=  res.data()!['servicename'].toString();
              _controllerdesc.text=  res.data()!['servicedesc'].toString();
              _phoneNumberSet.text=  res.data()!['phone'].toString();
              locationinfoval=  res.data()!['location'];
              tappedLocation=  res.data()!['location']['formatted_address'];
              fileDownloadUris=  res.data()!['photosLinks'];
              _category=  res.data()!['category'];
              isLoading = false;
              if(uidAccess == _phoneNumberSet.text)
              {
                isLoading = false;
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
        getOneServiceDetails();
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
          setState(){
            isLoading = true;
          }
      await checkAuth();
    }();

  }
  @override
  Widget build(BuildContext context) {
    return !isLoading ? Scaffold(
      backgroundColor: Colors.grey[200],
      floatingActionButton:FloatingActionButton(
          backgroundColor: Colors.blue,
          onPressed: () async {
            // add data ro firebase

            if(_controllername.text.toString().trim().isEmpty)
            {

            }
            else if(_controllerdesc.text.toString().trim().isEmpty)
            {

            }
            else if(_phoneNumberSet.text.toString().trim().isEmpty ||
                _phoneNumberSet.text.toString().length < 9)
            {
            }
            else if(tappedLocation == "not selected")
            {

            }
            else{

              setState(() {
                isLoading = true;
              });

              String groupServiceId = await uploadServiceData(

                  _controllername.text.toString(),
                  countrycode+_phoneNumberSet.text.toString(),
                  _controllerdesc.text.toString(),
                  locationinfoval
              );



            }

          },
          child:Icon(Icons.done,color:Colors.white)
      ),
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
            Text("Edit Service",
                style:TextStyle(
                  color: Colors.white,
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                )),
          ],
        ),

      ),

      body:isLoading ? Center(child: CircularProgressIndicator(),)
          :Container(
        width: MediaQuery.of(context).size.width,

        child: ListView(
          children: [

            Container(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  color: Colors.white,
                  elevation: 1,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: _controllername,
                          textAlignVertical:TextAlignVertical.center ,
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText:"Enter Service name",
                              contentPadding: EdgeInsets.all(5)
                          ),

                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 16.0,right: 16),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _controllerdesc,
                    textAlignVertical:TextAlignVertical.center ,
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText:"Enter Service Description..",

                        contentPadding: EdgeInsets.all(5)
                    ),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () async {

                String item_category = await Navigator.push(context,
                    MaterialPageRoute(builder:
                        (context) => Group_Categories(collection_name: 'Service',)));

                if(item_category != null)
                {
                  setState(() {
                    _category = item_category;
                  });
                }
              },
              child: ListTile(
                leading: CircleAvatar(
                  radius: 30,
                  child: Icon(Icons.category_outlined, color: Colors.white,),
                  backgroundColor: Colors.blue,
                ),
                title: Text("Category",
                    style:TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                    )),
                subtitle: Text(_category,
                    style:TextStyle(
                        fontSize: 13
                    )),
                trailing:Icon(Icons.navigate_next_sharp, color: Colors.blue,),
              ),
            ),
            InkWell(
              onTap: () async {

                /*
                var locationlist = await Navigator.push(context,
                    MaterialPageRoute(builder:
                        (context) => Location()));
                if(locationlist != null)
                {
                  setState(
                          () {
                        tappedLocation = (locationlist["address_components"][2][ "short_name"]).toString()
                            + ", "+(locationlist["address_components"][5][ "short_name"]).toString()
                            + ", "+(locationlist["address_components"][6][ "short_name"]).toString();
                      }
                  );
                }
                else
                {

                }
                */
              },
              child: ListTile(
                leading: CircleAvatar(
                  radius: 30,
                  child: Icon(Icons.location_on, color: Colors.white,),
                  backgroundColor: Colors.blue,
                ),
                title: Text("Location",
                    style:TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                    )),
                subtitle: Text(tappedLocation,
                    style:TextStyle(
                        fontSize: 13
                    )),
                trailing: Icon(Icons.edit, color: Colors.blue,),
              ),
            ),
            InkWell(
              onTap: () async {

                Navigator.of(context).push(
                    MaterialPageRoute
                      (builder: (context)=>Edit_Photos(uid: widget.serviceEditindId, name: "Service")));

              },
              child: ListTile(
                leading: CircleAvatar(
                  radius: 30,
                  child: Icon(Icons.add_a_photo,color: Colors.white,),
                  backgroundColor: Colors.blue,
                ),
                title: Text("Edit Service Photos",
                    style:TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                    )),
                trailing: Icon(Icons.navigate_next_sharp, color: Colors.blue,),
              ),
            ),


            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                color: Colors.white,
                child:Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text("Select Country",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),),
                    ),
                    SizedBox(
                      width: 150,
                      height: 50,
                      child: CountryCodePicker(
                        initialSelection:'IN',
                        showCountryOnly:false,
                        showOnlyCountryWhenClosed:false,
                        favorite:['+254','KE'],
                        enabled:true,
                        alignLeft:true,
                        padding:EdgeInsets.all(4.0),
                        onChanged:(code) =>{

                          countrycode = code.dialCode!,
                          countryname = code.name!
                        },
                        onInit:(code) async => {

                          countrycode = (await code?.dialCode)!,
                          countryname = (await code?.name)!
                        } ,
                      ),

                    ),
                  ],

                ),

              ),
            ),


            Padding(
              padding: const EdgeInsets.only(left: 16.0,right: 16),
              child: Card(

                child: TextFormField(
                  textAlignVertical:TextAlignVertical.center ,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  controller: _phoneNumberSet,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText:"Enter Phone Number..",
                      contentPadding: EdgeInsets.all(8)
                  ),
                ),
              ),
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


    ): Loading_Screen();
  }
}
