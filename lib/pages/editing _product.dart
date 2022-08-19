
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:toast/toast.dart';

import '../firebasest/storage.dart';
import 'group_category_page.dart';
import 'home.dart';
import 'loading_screen.dart';
import 'location.dart';
import 'login.dart';
import 'my_contributions.dart';
class Edit_Product extends StatefulWidget {
  const Edit_Product({Key? key, required this.productid}) : super(key: key);
  final String productid;

  @override
  State<Edit_Product> createState() => _Edit_ProductState();
}

class _Edit_ProductState extends State<Edit_Product> {

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
  String user_name = "";

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
      "itemname":itemname,
      "itemcategory":_category,
      "itemdescription":itemdescription,
      "itemprice":itemprice,
      "location":locationinfoval,
      "photosLinks":imagelink,
    };

    await db.collection("ItemData").doc(widget.productid).update(data).then((value) {
      setState(
          (){
            isLoading = false;
          }
      );
    });
    return documentid2;

  }

  Future<void> getOneProductDetail()
  async {
    final docref = db.collection("ItemData").doc(widget.productid);
    await docref.get().then((res) {

      if(res.data() != null)
      {
        setState(
                (){

              _controllername.text=  res.data()!['servicename'].toString();
              _controllerdesc.text=  res.data()!['servicedesc'].toString();
              locationinfoval=  res.data()!['location'];
              tappedLocation=  res.data()!['location']['formatted_address'];
              imageLink=  res.data()!['photosLinks'];
              _category=  res.data()!['category'];
              isLoading = false;

            }
        );


      }

    });

  }

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
    return isLoading ? Loading_Screen()  : Scaffold(
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
            else if(user_name == "")
            {
              Toast.show("Error Please try again".toString(), context,duration:Toast.LENGTH_SHORT,
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
                    padding: const EdgeInsets.all(0.0),
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
                          onTap: () async {
                            String item_category = await Navigator.push(context,
                                MaterialPageRoute(builder:
                                    (context) => Group_Categories(collection_name: 'Item',)));

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
                            title: Text(" Select Category",
                                style:TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold
                                )),
                            subtitle: Text(_category,
                                style:TextStyle(
                                    fontSize: 13
                                )),
                            trailing: Icon(Icons.navigate_next_sharp, color: Colors.blue,),
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

                ],
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
