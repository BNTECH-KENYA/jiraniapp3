import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:jiraniapp/pages/loading_screen.dart';
import 'package:jiraniapp/pages/serviceinfo.dart';
import 'package:line_icons/line_icons.dart';
import 'package:share/share.dart';
import 'package:toast/toast.dart';

import '../firebasest/storage.dart';
import 'group_category_page.dart';
import 'home.dart';
import 'location.dart';
import 'login.dart';
import 'my_contributions.dart';

class AddService extends StatefulWidget {
  const AddService({Key? key}) : super(key: key);
  @override
  State<AddService> createState() => _AddServiceState();
}

class _AddServiceState extends State<AddService> {
  FirebaseFirestore db = FirebaseFirestore.instance;

  TextEditingController _controllername = TextEditingController();
  TextEditingController _controllerdesc = TextEditingController();
  TextEditingController _phoneNumberSet = TextEditingController();
  String _category = "not selected";

  String tappedLocation = "not selected";
  List<File> ? photoFiles;

  String countryname = "";
  String countrycode = "";



  var locationinfoval;
  List<String> ? fileDownloadUris= [];
  final storage _storage = storage();

  String uidAccess = "0";
  bool isLoading = true;
  String user_name =  "";


  Future<void> getUserData()
  async {
    final docref = db.collection("userdd").doc(uidAccess);
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

  Future<String> uploadServiceData(servicename,phone, servicedesc, location, photosLinks)
  async {

    String documentid2 = "";
    final groupinfo = <String, dynamic>{


      "servicename":_controllername.text.toString(),
      "createdby":{
        "phonenumber": uidAccess,
        "name": user_name,
      },
      "phone":countrycode+_phoneNumberSet.text.toString(),
      "category":_category,
      "servicedesc":_controllerdesc.text.toString(),
      "location": locationinfoval,
      "photosLinks": [],


    };

    await db.collection("ServiceData").add(groupinfo).then(
            (DocumentReference doc) {
          documentid2 = doc.id;
        }
    );
    return documentid2;

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
              getUserData();

                }
        );
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
      backgroundColor: Colors.grey[200],
      floatingActionButton:FloatingActionButton(
          backgroundColor: Colors.blue,
          onPressed: () async {
            // add data ro firebase

            if(_controllername.text.toString().trim().isEmpty)
              {
                Toast.show("Enter Service Name".toString(), context,duration:Toast.LENGTH_SHORT,
                    gravity: Toast.BOTTOM);
              }
            else if(uidAccess == "0")
              {
                Toast.show("Error please try again".toString(), context,duration:Toast.LENGTH_SHORT,
                    gravity: Toast.BOTTOM);
              }
            else if(_controllerdesc.text.toString().trim().isEmpty)
              {

                Toast.show("Enter Service Description".toString(), context,duration:Toast.LENGTH_SHORT,
                    gravity: Toast.BOTTOM);
              }
            else if(_phoneNumberSet.text.toString().trim().isEmpty ||
                _phoneNumberSet.text.toString().length < 9)
              {
                Toast.show("Enter Contacts to from which users can reach out to you".toString(), context,duration:Toast.LENGTH_SHORT,
                    gravity: Toast.BOTTOM);
              }
            else if(tappedLocation == "not selected")
              {
                Toast.show("Select Location".toString(), context,duration:Toast.LENGTH_SHORT,
                    gravity: Toast.BOTTOM);

              }
            else if(_category == "not selected")
              {
                Toast.show("Select Category".toString(), context,duration:Toast.LENGTH_SHORT,
                    gravity: Toast.BOTTOM);

              }
            else if(user_name == "")
            {
              Toast.show("Error please try again".toString(), context,duration:Toast.LENGTH_SHORT,
                  gravity: Toast.BOTTOM);
            }
            else{

              setState(() {
                isLoading = true;
              });

              String groupServiceId = await uploadServiceData(

                  _controllername.text.toString(),
                  countrycode+_phoneNumberSet.text.toString(),
                  _controllerdesc.text.toString(),
                  locationinfoval,
                  fileDownloadUris

              );

              for (var image in photoFiles!)
              {
                String? dowbloaduri =  await _storage.uploadImage(image.path, groupServiceId+"/"+image.path.toString());
                print(" download image at ->   ${dowbloaduri.toString()}");
                fileDownloadUris?.add(dowbloaduri!);
              }



              final dataupdate = <String, dynamic>
              {
                "photosLinks":fileDownloadUris,
              };


              await db.collection("ServiceData").doc(groupServiceId).update(dataupdate)
                  .then((value) {
                setState(
                        (){
                      isLoading = false;

                    }
                );

                print("~~~~~~~~~~~~~~Success in Jesus Name~~~~~~~~~~~~~");
                Navigator.of(context).push(
                    MaterialPageRoute
                      (builder: (context)=>ServiceInfo(groupServiceid: groupServiceId,))
                );
              });

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
            Text("New Service",
                style:TextStyle(
                  color: Colors.white,
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                )),
          ],
        ),

      ),

      body:Container(
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
                          textAlign: TextAlign.left,
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
                      textAlign: TextAlign.left,
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

                var locationlist = await Navigator.push(context,
                    MaterialPageRoute(builder:
                        (context) => Location()));
                if(locationlist != null)
                {
                  setState(
                          () {
                            locationinfoval = locationlist;
                            print("?????????????????????????");
                            print(locationinfoval);
                        tappedLocation = locationlist['formatted_address'];
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
                subtitle: Text(tappedLocation,
                    style:TextStyle(
                        fontSize: 13
                    )),
                trailing: Icon(Icons.edit, color: Colors.blue,),
              ),
            ),
            InkWell(
              onTap: () async {

                print(">>>>>>>>>>>>>>>>>>|-pdflength${photoFiles?.length}");
                final result = await FilePicker.platform.pickFiles(
                  allowMultiple:true,
                  type: FileType.custom,
                    allowedExtensions: ['png','jpg']
                );
                if(result == null) return;
                print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>> |-result ${result.count}");
                if(result.count <= 4){
                  setState(
                          (){

                            photoFiles =result.paths.map((path) => File(path!)).toList() ;
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
                  child: Icon(Icons.add_a_photo,color: Colors.white,),
                  backgroundColor: Colors.blue,
                ),
                title: Text("Add Photos",
                    style:TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold
                    )),
                subtitle:(photoFiles== null)?  Text("${0} added",
                    style:TextStyle(
                        fontSize: 13
                    )):(photoFiles!.length>3) ?
                Text("${photoFiles!.length} added",
                    style:TextStyle(
                        fontSize: 13
                    ))
                    :Text("${photoFiles?.length} added",
                    style:TextStyle(
                        fontSize: 13
                    )),
                trailing: Icon(Icons.file_upload, color: Colors.blue,),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(left:16.0, right: 16),
              child: Card(
                color: Colors.white,
                child: Container(
                  height: 100,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 4.0, right: 4.0),
                    child: ListView.builder(
                          itemCount: (photoFiles?.length == null)? 0:photoFiles?.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (BuildContext context, int index) {
                          return  Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Image.file(File(photoFiles![index].path),
                                fit: BoxFit.cover,
                                width: 100,
                                height: 100,),
                            );

                          }),

                    ),
                  ),

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
                  textAlign: TextAlign.left,
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


    );
  }
}

/*
scrollDirection: Axis.horizontal,
                    children: [

                    ],


          //contacts

 */
