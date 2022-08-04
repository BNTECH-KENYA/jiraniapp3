import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:jiraniapp/pages/location.dart';
import 'package:line_icons/line_icons.dart';
import 'package:share/share.dart';
import 'package:toast/toast.dart';
import 'dart:io';

import '../firebasest/storage.dart';
import 'home.dart';
import 'location_check.dart';
import 'login.dart';
import 'my_contributions.dart';

class AddNewItem extends StatefulWidget {
  const AddNewItem({Key? key, required this.store_id}) : super(key: key);
  final String store_id;

  @override
  State<AddNewItem> createState() => _AddNewItemState();
}

class _AddNewItemState extends State<AddNewItem> {

  FirebaseFirestore db = FirebaseFirestore.instance;
  final storage _storage = storage();

  final _formKey = GlobalKey<FormState>();
  String _category = "not selected";
  String tappedLocation = "not selected";
  String _locationcheck = "not selected";
  var locationinfoval;


  var imagePath;
  var imageName;
  String imageLink = "";
  bool fileimage = false;
  bool isLoading = true;

  String uidAccess = "0";

  TextEditingController _controllername = TextEditingController();
  TextEditingController _controllerdesc = TextEditingController();
  TextEditingController _itemprice = TextEditingController();

  Future<String> uploadingItemData(itemname, itemdescription, itemcategory, itemprice, imagelink)
  async {

    setState(
            (){
          isLoading = true;
        }
    );
    String documentid2 = "";
    final data = <String, dynamic>
    {
      "createdby":uidAccess,
      "itemname":itemname,
      "itemcategory":_category,
      "itemdescription":itemdescription,
      "itemprice":itemprice,
      "location":locationinfoval,
      "photosLinks":imagelink,
    };

    await db.collection("ItemData").add(data).then(
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
    Size size = MediaQuery.of(context).size;
    return isLoading ? Center(child: CircularProgressIndicator(),)  : Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {

            if(_category == "not selected")
              {
                Toast.show("Select Item Category".toString(), context,duration:Toast.LENGTH_SHORT,
                    gravity: Toast.BOTTOM);
              }
            else if(fileimage == false)
              {
                Toast.show("Select Item photo".toString(), context,duration:Toast.LENGTH_SHORT,
                    gravity: Toast.BOTTOM);

              }
            else if(_locationcheck == "not selected")
            {
              Toast.show("Select location supporting document".toString(), context,duration:Toast.LENGTH_SHORT,
                  gravity: Toast.BOTTOM);
            }
            else if(_controllername.text.trim().toString() == "")

              {
                Toast.show("Enter Item Name".toString(), context,duration:Toast.LENGTH_SHORT,
                    gravity: Toast.BOTTOM);
              }
            else if(_controllerdesc.text.trim().toString() == "")
              {
                Toast.show("Enter Item description".toString(), context,duration:Toast.LENGTH_SHORT,
                    gravity: Toast.BOTTOM);
              }
            else if(_itemprice.text.trim().toString() == "")
              {
                Toast.show("Enter Item price".toString(), context,duration:Toast.LENGTH_SHORT,
                    gravity: Toast.BOTTOM);
              }
            else {
              //itemname, itemdescription, itemcategory, itemprice, imagelink
              String item_cloud_id = await uploadingItemData(
                  _controllername.text.toString(),
                  _controllerdesc.text.toString(),
                  _category,
                  _itemprice.text.toString(),
                  ""

              );

              imageLink = (await _storage.uploadImage(
                  imagePath, item_cloud_id + "/" + imagePath.toString()))!;
              print(" download image at ->   ${imageLink.toString()}");

              final dataupdate = <String, dynamic>
              {
                "photosLinks": imageLink,
              };

              await db.collection("ItemData").doc(item_cloud_id).update(
                  dataupdate)
                  .then((value) {
                setState(
                        () {

                      isLoading = false;
                      imagePath = null;
                      fileimage = false;
                      imageName = null;
                      tappedLocation = "not selected";
                      imageLink = "";
                      _category = "not selected";
                      _controllername.text = "";
                      _controllerdesc.text = "";
                      _itemprice.text = "";

                      // have a toast snack bar item added successfully

                    }
                );
              });
            }


        },
        backgroundColor: Colors.blue,
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
            Text("Add New Item",
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
            Form(
              child: Column(
                children: [

                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Card(
                      color: Colors.white,
                      elevation: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20,),
                          Padding(
                            padding: const EdgeInsets.only(left:16.0),
                            child: Text("Item Name", style: TextStyle(
                              color: Colors.black,
                              fontSize: 15,
                              fontWeight: FontWeight.bold

                            ),),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: _controllername,
                              textAlignVertical:TextAlignVertical.center ,
                              textAlign: TextAlign.left,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText:"Enter Item Name",
                                  contentPadding: EdgeInsets.all(5)
                              ),
                              validator: (value){
                                if(value!.isEmpty || value!.trim().isEmpty)
                                  {
                                    return 'Please Enter Item Name';
                                  }
                                return null;
                              },

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
                              title: Text(" Select Category",
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
                                        child: Text("Shirts"),
                                        value:"Shirts",
                                      ),
                                      PopupMenuItem(
                                        child: Text("Dress"),
                                        value:"Dress",
                                      ),
                                      PopupMenuItem(
                                        child: Text("Tshirts"),
                                        value:"Tshirts",
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
                              subtitle:(fileimage == false)?  Text("${0} added",
                                  style:TextStyle(
                                      fontSize: 13
                                  ))
                                  :Text("${1} added",
                                  style:TextStyle(
                                      fontSize: 13
                                  )),
                              trailing: Icon(Icons.file_upload, color: Colors.blue,),
                            ),
                          ),

                         fileimage? Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: Container(
                              height: size.height * 0.24,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: FileImage(File(imagePath)),
                                ),
                              ),
                            ),
                         ):Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: Container(
                             height: size.height * 0.24,
                             decoration: BoxDecoration(
                               image: DecorationImage(
                                 fit: BoxFit.fill,
                                   image: AssetImage(
                                     "assets/catering.jfif",
                                   )
                               ),
                             ),
                           ),
                         ),
                          SizedBox(height: 20,),
                          Padding(
                            padding: const EdgeInsets.only(left:16.0),
                            child: Text("Item Description", style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.bold

                            ),),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: _controllerdesc,
                              textAlignVertical:TextAlignVertical.center ,
                              textAlign: TextAlign.left,
                              maxLines: 5,
                              minLines: 2,
                              maxLength: 50,
                              keyboardType: TextInputType.multiline,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText:"Enter Item Description",
                                  contentPadding: EdgeInsets.all(5)
                              ),
                              validator: (value){
                                if(value!.isEmpty || value!.trim().isEmpty)
                                {
                                  return 'Please Enter Description';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(height: 20,),
                          Padding(
                            padding: const EdgeInsets.only(left:16.0),
                            child: Text("Item Price", style: TextStyle(
                                color: Colors.black,
                                fontSize: 15,
                                fontWeight: FontWeight.bold

                            ),),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: _itemprice,
                              textAlignVertical:TextAlignVertical.center ,
                              textAlign: TextAlign.left,
                              keyboardType: TextInputType.numberWithOptions(decimal: true),
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText:"Enter Sales Price",
                                  contentPadding: EdgeInsets.all(5)
                              ),
                              validator: (value){
                                if(value!.isEmpty || value!.trim().isEmpty)
                                {
                                  return 'Please Enter Sales price';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                ],
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
