import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:jiraniapp/pages/serviceinfo.dart';
import 'package:line_icons/line_icons.dart';

import '../firebasest/storage.dart';
import 'login.dart';

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
  List<String> ? fileDownloadUris= [];
  final storage _storage = storage();

  Future<String> uploadServiceData(servicename,phone, servicedesc, location, photosLinks)
  async {

    String documentid2 = "";
    final groupinfo = <String, dynamic>{


      "servicename":_controllername.text.toString(),
      "phone":countrycode+_phoneNumberSet.text.toString(),
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

  Future<void> getOneServiceDetails()
  async {
    final docref = db.collection("ServiceData").doc(widget.serviceEditindId);
    await docref.get().then((res) {

      if(res.data() != null)
      {
        setState(
                (){
              _controllername.text=  res.data()!['servicename'];
              _controllerdesc.text=  res.data()!['servicedesc'];
              _phoneNumberSet.text=  res.data()!['phone'].toString().split("-")[1];
              locationinfoval=  res.data()!['location'];
              fileDownloadUris=  res.data()!['photosLinks'];
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
    return isLoading ? Scaffold(
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
                  locationinfoval,
                  fileDownloadUris
              );

              /*
              for (var image in photoFiles!)
              {
                String? dowbloaduri =  await _storage.uploadImage(image.path, groupServiceId+"/"+image.path.toString());
                print(" download image at ->   ${dowbloaduri.toString()}");
                fileDownloadUris?.add(dowbloaduri!);
              }

               */



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
                          child: Text("Catering"),
                          value:"Burial",
                        ),
                        PopupMenuItem(
                          child: Text("Auditing"),
                          value:"school fees",
                        ),
                        PopupMenuItem(
                          child: Text("Others"),
                          value:"dowry",
                        ),
                      ];
                    }
                ),
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
                            /*
                        photoFiles =result.paths.map((path) => File(path!)).toList() ;

                             */
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
                            /*
                            child: Image.file(File(photoFiles![index].path),
                              fit: BoxFit.cover,
                              width: 100,
                              height: 100,),

                             */
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
                      hintText:"Enter Phone Number..",
                      contentPadding: EdgeInsets.all(8)
                  ),
                ),
              ),
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

    ): Center(child: CircularProgressIndicator(),);
  }
}
