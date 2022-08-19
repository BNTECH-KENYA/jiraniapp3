import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:jiraniapp/pages/loading_screen.dart';
import 'package:jiraniapp/pages/location.dart';
import 'package:line_icons/line_icons.dart';
import 'package:share/share.dart';

import '../firebasest/storage.dart';
import 'addNewItem.dart';
import 'home.dart';
import 'login.dart';
import 'my_contributions.dart';

class AddStore extends StatefulWidget {
  const AddStore({Key? key}) : super(key: key);

  @override
  State<AddStore> createState() => _AddStoreState();
}

class _AddStoreState extends State<AddStore> {

  FirebaseFirestore db = FirebaseFirestore.instance;
  final storage _storage = storage();

  TextEditingController _controllername = TextEditingController();
  TextEditingController _controllerdesc = TextEditingController();
  TextEditingController _phoneNumberSet = TextEditingController();
  String _category = "not selected";
  String uidAccess = "";
  String tappedLocation = "not selected";
  List<File> ? photoFiles;
  List<String>  filedownloaduris = [];

  var locationval;

  String countryname = "";
  String countrycode = "";

  bool isLoading = false;

  Future<String> uploadingStoreData(storename, storedescription, storephonenumber)
  async {

    String documentid2 = "";
    final data = <String, dynamic>
    {
      "createdby":uidAccess,
      "storename":storename,
      "phone":storephonenumber,
      "storecategory":_category,
      "storedescription":storedescription,
      "location": locationval,
      "photosLinks":filedownloaduris,
    };

    await db.collection("StoreData").add(data).then(
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
              isLoading = false;

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
    return isLoading? Loading_Screen():
    Scaffold(
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
            else if( tappedLocation == "not selected")
              {

              }
            else if( uidAccess == "0")
              {

              }
            else if( photoFiles?.length == 0)
              {

              }

            else {
              setState(() {
                isLoading = true;
              });

              String store_cloud_id = await uploadingStoreData(
                  _controllername.text.toString(),
                  _controllerdesc.text.toString(),
                  _phoneNumberSet.text.toString());

              for (var image in photoFiles!) {
                String? dowbloaduri = await _storage.uploadImage(
                    image.path, store_cloud_id + "/" + image.path.toString());
                print(" download image at ->   ${dowbloaduri.toString()}");
                filedownloaduris?.add(dowbloaduri!);
              }


              final dataupdate = <String, dynamic>
              {
                "photosLinks": filedownloaduris,
              };


              await db.collection("StoreData").doc(store_cloud_id).update(
                  dataupdate)
                  .then((value) {
                setState(
                        () {
                      isLoading = false;
                    }
                );

                print("~~~~~~~~~~~~~~Success in Jesus Name~~~~~~~~~~~~~");
                Navigator.of(context).push(
                    MaterialPageRoute
                      (builder: (context) => AddNewItem(store_id: store_cloud_id,))
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

            Text("New Store",
                style:TextStyle(
                  color: Colors.white,
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                )),

          ],
        ),

      ),

      body: Container(
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
                              hintText:"Enter Store name",
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
                    maxLines: 5,
                    minLines: 2,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText:"Enter Store Description..",

                        contentPadding: EdgeInsets.all(5)
                    ),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: (){},
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
                trailing: PopupMenuButton<String>(
                    color:Colors.white,
                    onSelected: (value)
                    {
                      setState(
                              (){
                            _category = value;
                          }
                      );
                    },
                    itemBuilder: (BuildContext context){
                      return[
                        PopupMenuItem(
                          child: Text("Grocery"),
                          value:"Grocery",
                        ),
                        PopupMenuItem(
                          child: Text("Botique"),
                          value:"Botique",
                        ),
                        PopupMenuItem(
                          child: Text("Others"),
                          value:"Others",
                        ),
                      ];
                    }
                ),
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
                            locationval = locationlist;
                        tappedLocation = (locationlist["address_components"][2][ "short_name"]).toString()
                            + ", "+(locationlist["address_components"][5][ "short_name"]).toString()
                            + ", "+(locationlist["address_components"][6][ "short_name"]).toString();
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
                  type: FileType.image,
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
                Text("${0} added",
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
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  controller: _phoneNumberSet,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText:"Enter Store Number..",
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
          color: Colors.white,
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
                          Icon(Icons.home_filled, color:Colors.grey),
                          Text(
                            'Home',
                            style: TextStyle(
                              color: Colors.grey,
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
                          Icon(Icons.payment, color:Colors.grey),
                          Text(
                            'Payments',
                            style: TextStyle(
                              color: Colors.grey,
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
                          Icon(Icons.rate_review, color:Colors.grey),
                          Text(
                            'Rate App',
                            style: TextStyle(
                              color: Colors.grey,
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
                          Icon(Icons.share, color:Colors.grey),
                          Text(
                            'Share',
                            style: TextStyle(
                              color: Colors.grey,
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
