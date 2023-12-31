import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:share/share.dart';

import 'home.dart';
import 'my_contributions.dart';

class EditItem extends StatefulWidget {
  const EditItem({Key? key}) : super(key: key);

  @override
  State<EditItem> createState() => _EditItemState();
}

class _EditItemState extends State<EditItem> {
  final _formKey = GlobalKey<FormState>();
  String _category = "not selected";

  var imagePath;
  var imageName;
  bool fileimage = false;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            if(_formKey.currentState!.validate())
            {

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
            Text("Edit Item",
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
              key: _formKey,
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
                              textAlignVertical:TextAlignVertical.center ,
                              textAlign: TextAlign.center,
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
                                        value:"Burial",
                                      ),
                                      PopupMenuItem(
                                        child: Text("Dress"),
                                        value:"school fees",
                                      ),
                                      PopupMenuItem(
                                        child: Text("Tshirts"),
                                        value:"dowry",
                                      ),
                                    ];
                                  }
                              ),
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
                              textAlignVertical:TextAlignVertical.center ,
                              textAlign: TextAlign.center,
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
                              textAlignVertical:TextAlignVertical.center ,
                              textAlign: TextAlign.center,
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
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
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
                      Icon(Icons.home_filled, color:Colors.black87),
                      Text(
                        'Home',
                        style: TextStyle(
                          color: Colors.black87,
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
                      Icon(Icons.payment, color:Colors.black87),
                      Text(
                        'Payments',
                        style: TextStyle(
                          color: Colors.black87,
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
                      Icon(Icons.rate_review, color:Colors.black87),
                      Text(
                        'Rate App',
                        style: TextStyle(
                          color: Colors.black87,
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
                      Icon(Icons.share, color:Colors.black87),
                      Text(
                        'Share',
                        style: TextStyle(
                          color: Colors.black87,
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

    );
  }
}
