import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz_unsafe.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:jiraniapp/models/contactfr.dart';
import 'package:jiraniapp/pages/loading_screen.dart';
import 'package:jiraniapp/pages/location.dart';
import 'package:line_icons/line_icons.dart';
import 'package:share/share.dart';
import 'package:toast/toast.dart';

import '../firebasest/storage.dart';
import '../models/chatModel.dart';
import '../widget/contributoringroup.dart';
import '../widget/newgroupcontributor.dart';
import 'group_category_page.dart';
import 'home.dart';
import 'ingrouppage.dart';
import 'login.dart';
import 'my_contributions.dart';

class GroupActivation extends StatefulWidget {

  const GroupActivation( {Key? key, required this.groups}) : super(key: key);
  final List<ContactModel> groups;
  @override
  State<GroupActivation> createState() => _GroupActivationState();
}

class _GroupActivationState extends State<GroupActivation> {

  String contributors = "contributors = 10";
  String _category = "not selected";
  String _locationcheck = "not selected";
  List<File> ? pdffile;
  TextEditingController _groupnameController = TextEditingController();

  var imagePath;
  var imageName;
  bool fileimage = false;
  bool isLoading = false;
  String user_name = "";

  String tappedLocation = "not selected";
  String imageprofilelink = "none";
  final storage _storage = storage();
  final dbfr = FirebaseFirestore.instance;
  var locationinfoval;
  List<String> ?contributorsval = [];
  List<ContactModel> groups2 = [  ContactModel(
    name:"name",
    uid: "uid",
    phone: "phone",
    select: false,
  ),];

  List<String> ? fileDownloadUris= [];

  Future<String> uploadGroupData(groupname,groupprofilepic, groupcategory, location, documentlinks, contributorsPhones)
  async {



   String documentid2 = "";
    final groupinfo = <String, dynamic>{

      "groupname":groupname,
      "groupprofilepic":groupprofilepic,
      "category": groupcategory,
      "location": location,
      "documentlinks":documentlinks,
      "contributors":contributorsPhones,
      "toppingClassifier":FieldValue.serverTimestamp(),
      "latestContribution":"Group Created by: name",
      "createdby": {
        "phonenumber":uidAccess,
        "name": user_name,
      },
      // remember to get the user data;

    };

   await dbfr.collection("GroupData").add(groupinfo).then(
            (DocumentReference doc) {
              documentid2 = doc.id;
            }
    );
   return documentid2;

  }

  Future<void> uploadPdfThread (groupidin) async
  {
  }

  String uidAccess = "0";

  Future<void> getUserData()
  async {
    final docref = dbfr.collection("userdd").doc(uidAccess);
    await docref.get().then((res) {

      if(res.data() != null)
      {
        print("###########################################${res.data()!['name']} group information");
        setState(
                (){
              user_name= res.data()!['name'];
              isLoading = false;


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
        getUserData();
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


    return isLoading? Loading_Screen()
        : Scaffold(
      //groupname, Location,groupicon,Supporting documents
    backgroundColor: Colors.grey[200],
        floatingActionButton:FloatingActionButton(
          backgroundColor: Colors.blue,
          onPressed: () async {

            contributorsval?.clear();
          widget.groups.forEach((element) {
            if(contributorsval!.contains(element.phone))
              {

              }
            else
              {
                print("********************************************");
                print(element.phone);
                print("********************************************");
                contributorsval?.add(element.phone);
              }

            });

            if(_groupnameController.text.toString().isEmpty)
              {
                Toast.show("Enter Group Name".toString(), context,duration:Toast.LENGTH_SHORT,
                    gravity: Toast.BOTTOM);
              }
            else if(_category.toString() == "not selected")
              {

                Toast.show("Select Category".toString(), context,duration:Toast.LENGTH_SHORT,
                    gravity: Toast.BOTTOM);

              }
            else if( pdffile?.length == 0)
              {

                Toast.show("Select atLeast one supporting document".toString(), context,duration:Toast.LENGTH_SHORT,
                    gravity: Toast.BOTTOM);
              }
            else if(_locationcheck == "not selected")
              {
                Toast.show("Select location supporting document".toString(), context,duration:Toast.LENGTH_SHORT,
                    gravity: Toast.BOTTOM);
              }
            else if(fileimage == false)
              {
                Toast.show("Select Group Profile Picture".toString(), context,duration:Toast.LENGTH_SHORT,
                    gravity: Toast.BOTTOM);
              }
            else if(contributorsval!.length == 0)
              {
                Toast.show("Add contributors".toString(), context,duration:Toast.LENGTH_SHORT,
                    gravity: Toast.BOTTOM);
              }
            else if(uidAccess == "0")
              {
                Toast.show("error on auth value", context,duration:Toast.LENGTH_SHORT,
                    gravity: Toast.BOTTOM);
              }
            else if(user_name == "")
              {
              Toast.show("Enter Item price".toString(), context,duration:Toast.LENGTH_SHORT,
              gravity: Toast.BOTTOM);
              }
            else
              {
                setState(
                    (){
                      isLoading = true;
                    }
                );

                contributorsval?.add(uidAccess);

                String groupId = await uploadGroupData(
                    _groupnameController.text.toString(),
                    imageprofilelink,
                    _category.toString(),
                    locationinfoval,
                    fileDownloadUris,
                    contributorsval);

            /*

             await pdffile?.forEach((element) async {
               String? dowbloaduri =  await _storage.uploadImage(element.path, groupid+"/"+element.path.toString());
               print(" download pdf at ->   ${dowbloaduri.toString()}");
               fileDownloadUris?.add(dowbloaduri!);
             });
             */
             for (var pdf in pdffile!)
               {
                 String? dowbloaduri =  await _storage.uploadImage(pdf.path, groupId+"/"+pdf.path.toString());
                 print(" download pdf at ->   ${dowbloaduri.toString()}");
                 fileDownloadUris?.add(dowbloaduri!);
               }

                String? dowbloaduri2 =  await _storage.uploadImage(imagePath, imageName);
                print(" download image at ->   ${dowbloaduri2.toString()}");
                final dataupdate = <String, dynamic>
                {
                  "documentlinks":fileDownloadUris,
                  "groupprofilepic":dowbloaduri2,
                };

                await dbfr.collection("GroupData").doc(groupId).update(dataupdate)
                    .then((value) {
                  setState(
                          (){
                        isLoading = false;

                      }
                  );

                      print("~~~~~~~~~~~~~~Success in Jesus Name~~~~~~~~~~~~~");
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>InGroupPage(

                    groupid: groupId
                  )));
                    });


              }

            // add data ro firebase
            //Navigator.push(context, MaterialPageRoute(builder: (context)=>InGroupPage()));
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
            Text("New Group",
                style:TextStyle(
                  color: Colors.white,
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                )),
            Text("Add Group Details",
                style:TextStyle(
                  color:Colors.white,
                  fontSize: 13,
                )),

          ],
        ),

      ),

      body:  Container(
        width: MediaQuery.of(context).size.width,

        child: ListView(
          children: [

            Container(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  color: Colors.white,
                  elevation: 1,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          InkWell(
                            onTap:()
                            async {
                              final result = await FilePicker.platform.pickFiles(
                                allowMultiple: false,
                                type:FileType.custom,
                                allowedExtensions: ['png','jpg'],
                              );
                              if(result != null)
                              {
                                imagePath = result.files.single.path!;
                                imageName = result.files.single.name;
                                setState(() {

                                  fileimage = true;
                                });

                              }
                              else
                              {

                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(left:8.0),
                              child: fileimage ? CircleAvatar(
                              radius: 23,
                              backgroundImage: FileImage(File(imagePath) ),
                            ): CircleAvatar(
                              radius: 23,
                              backgroundColor: Colors.blueGrey[200],
                              child: Icon(Icons.camera_alt, color:Colors.white,),
                            ),
                            ),
                          ),
                          SizedBox(width: 10,),
                          Container(
                            width: MediaQuery.of(context).size.width-120,
                            height: 60,
                            child: TextFormField(
                              controller: _groupnameController,
                              textAlignVertical:TextAlignVertical.center ,
                              maxLength: 30,
                              textAlign: TextAlign.left,

                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText:"Enter Group Name",
                                  contentPadding: EdgeInsets.all(5)
                              ),
                              keyboardType: TextInputType.text,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () async {

                String group_category = await Navigator.push(context,
                    MaterialPageRoute(builder:
                        (context) => Group_Categories(collection_name: 'Group',)));

                if(group_category != null)
                  {
                    setState(() {
                      _category = group_category;
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
                trailing: Icon(Icons.navigate_next_sharp, color: Colors.black87,),
              ),
            ),

            InkWell(
              onTap: () async {

                var locationlist = await Navigator.push(context,
                    MaterialPageRoute(builder:
                        (context) => Location()));
                if(locationlist != null)
                  {
                    setState(
                            () {
                              locationinfoval = locationlist;
                              print(">>>>>>>>>>>>>>>>>>>>>>>> in the ${locationlist}");
                          tappedLocation = locationlist["formatted_address"];
                              _locationcheck = tappedLocation;
                            }
                    );
                  }
                else
                  {

                  }

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
                subtitle:Text(tappedLocation,
                    style:TextStyle(
                        fontSize: 13
                    )),
                trailing: Icon(Icons.edit, color: Colors.blue,),
              ),
            ),
            InkWell(
              onTap: () async {
                print(">>>>>>>>>>>>>>>>>>|-pdflength${pdffile?.length}");
                final result = await FilePicker.platform.pickFiles(
                  allowMultiple:true,
                type: FileType.custom,
                allowedExtensions: ['doc','pdf','png','jpg'],

                );
                if(result == null) return;
                print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>> |-result ${result.count}");
                if(result.count <= 3){
                  setState(
                          (){
                        pdffile =result.paths.map((path) => File(path!)).toList() ;
                      }
                  );
                }
                else
                  {

                  }

              },
              child: ListTile(
                leading: CircleAvatar(
                  radius: 30,
                  child: Icon(Icons.picture_as_pdf_outlined, color: Colors.white,),
                  backgroundColor: Colors.blue,
                ),
                title: Text("Add Supporting Documents",
                    style:TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                    )),
                    subtitle:(pdffile== null)?  Text("${0} added",
                        style:TextStyle(
                            fontSize: 13
                        )):(pdffile!.length>3) ?
                    Text("${3} added",
                        style:TextStyle(
                            fontSize: 13
                        ))
                    :Text("${pdffile?.length} added",
                    style:TextStyle(
                        fontSize: 13
                    )),
                trailing: Icon(Icons.file_upload, color: Colors.blue,),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16),
              child: Container(
                height: 100,
                color: Colors.white,
                child: ListView.builder(
                  itemCount: (pdffile?.length == null)? 0:pdffile?.length,
                      scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                   return SizedBox(
                        height:90,
                        width: 100,
                        child: Card(
                          color: Colors.white,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                          Stack(
                          children: [
                          CircleAvatar(
                          radius: 23,
                            child: Icon(Icons.picture_as_pdf_sharp, color: Colors.white,),
                            backgroundColor: Colors.blueGrey[200],
                          ),
                          ],
                        ),
                        SizedBox(height: 2,),
                        Text('Doc ${index +1}',
                          style: TextStyle(
                              fontSize: 12
                          ),)
                          ]
                    ),
                    ),
                    );
                  },

                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text("Contributors:${widget.groups.length}"
                  ,style: TextStyle(
                      fontWeight: FontWeight.bold
                    ),),
                  Container(
                    height: 200,
                    color: Colors.white,
                    width:MediaQuery.of(context).size.width-20,
                      child: GridView.builder(
                          itemCount: widget.groups.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            childAspectRatio: 1,
                          ),
                          itemBuilder:(context,index) {
                      return InkWell(
                      onTap: (){
                      },
                      child: NewGroupContributor(contact: (widget.groups[index]==null)?
                            groups2[index]
                            :widget.groups[index]
                            ));
                      })
                  ),
                ],
              ),
            )
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

/*
{address_components:
[
  {long_name: Utawala Complex, short_name: Utawala Complex, types: [premise]},
{long_name: Eastern Bypass, short_name: Eastern Bypass, types: [route]},
{long_name: Mihango, short_name: Mihango, types: [sublocality_level_1, sublocality, political]},
{long_name: Nairobi, short_name: Nairobi, types: [locality, political]},
{long_name: Nairobi County, short_name: Nairobi County, types: [administrative_area_level_1, political]},
{long_name: Kenya, short_name: KE, types: [country, political]}],
adr_address:
Utawala Complex,
<span class="street-address">Eastern Bypass</span>,
<span class="locality">Nairobi</span>,
<span class="country-name">Kenya</span>,
formatted_address: Utawala Complex, Eastern Bypass, Nairobi, Kenya,
geometry:
{location: {lat: -1.2803889, lng: 36.9639637},
viewport: {northeast: {lat: -1.279096069708498, lng: 36.9653388302915},
southwest: {lat: -1.281794030291502, lng: 36.9626408697085}}}
}
 */