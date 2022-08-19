import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiraniapp/pages/edit_service.dart';
import 'package:jiraniapp/pages/loading_screen.dart';
import 'package:toast/toast.dart';

import '../firebasest/storage.dart';
import '../widget/previous_photos_holder.dart';

class Edit_Photos extends StatefulWidget {
  const Edit_Photos({Key? key, required this.uid, required this.name}) : super(key: key);
  final String uid, name;

  @override
  State<Edit_Photos> createState() => _Edit_PhotosState();
}

class _Edit_PhotosState extends State<Edit_Photos> {

  List photosLinks = [];
  List newphotosLinks = [];
  final db = FirebaseFirestore.instance;
  bool onloaded = false;
  List<File> ? photoFiles;
  final storage _storage = storage();
  bool isLoading = true;

  Future <void> deletephoto(imagetoremove)
  async {

    setState((){

      isLoading = true;
    });

    final dataupdate = <String, dynamic>
    {
      "photosLinks":FieldValue.arrayRemove(
        [imagetoremove]
      ),
    };

    await db.collection("ServiceData")
        .doc(widget.uid)
        .update(dataupdate)
        .then((value) {
       getServiceDetails();
    }
    );

  }

  Future <void> addPhotolinks()
  async {
    final dataupdate = <String, dynamic>
    {
      "photosLinks":FieldValue.arrayUnion(
          newphotosLinks
      ),
    };


    await db.collection("ServiceData")
        .doc(widget.uid)
        .update(dataupdate)
        .then((value) {
      setState(
              () {
            isLoading = false;
          }
      );
    }
    );

  }


  Future<void> uploadimages()
  async {
    for (var image in photoFiles!)
    {
      String? dowbloaduri =  await _storage.uploadImage(image.path, widget.uid+"/"+image.path.toString());
      print(" download image at ->   ${dowbloaduri.toString()}");
      newphotosLinks?.add(dowbloaduri!);
    }
    await addPhotolinks();
  }

  Future<void> getServiceDetails()
  async {
    final docref = db.collection("ServiceData").doc(widget.uid);
    await docref.get().then((res) {

      if(res.data() != null)
      {
        setState(
                (){

              photosLinks=  res.data()!['photosLinks'];
              isLoading = false;

            }
        );


      }

    });

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

        () async {
      await getServiceDetails();
    }();
  }


  @override
  Widget build(BuildContext context) {
    return  isLoading? Loading_Screen() :Scaffold(

      floatingActionButton: FloatingActionButton(
          onPressed: () async {

            if(photoFiles!.length >0)
              {

               await uploadimages();
               Navigator.of(context).push(
                   MaterialPageRoute
                     (builder: (context)=>EditServiceInfo(serviceEditindId: widget.uid))
               );

              }
            else if(photosLinks.length <1){

              Toast.show("Add atleast one Photo".toString(), context,duration:Toast.LENGTH_SHORT,
                  gravity: Toast.BOTTOM);

            }
            else
              {
                Navigator.of(context).push(
                    MaterialPageRoute
                      (builder: (context)=>EditServiceInfo(serviceEditindId: widget.uid))
                );
              }

          },
        backgroundColor: Colors.blue,
        child: Icon(Icons.done,color:Colors.white),

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
            Text("Edit ${widget.name} photos",
                style:TextStyle(
                  color: Colors.white,
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                )),
          ],
        ),

      ),

      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,

          child: Padding(
            padding: const EdgeInsets.only(left:8.0, right:8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                SizedBox(
                  height: 20,
                ),
                Text("Previously Added Photos",

                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,

                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 150,
                  child:ListView.builder(
                      itemCount: photosLinks.length,
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 3),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {

                        return Photo_Holder(imageLink: photosLinks[index], fundelphoto: (){deletephoto(photosLinks[index]);},);

                      })
                ),

        SizedBox(height: 20,),

        InkWell(
            onTap: () async {

              print(">>>>>>>>>>>>>>>>>>|-pdflength${photoFiles?.length}");
              final result = await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['png','jpg'],
                  allowMultiple: true
              );
              if(result == null) return;
              print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>> |-result ${result.count}");
              if(result.count <= 3-photosLinks.length){
                setState(
                        (){

                      photoFiles =result.paths.map((path) => File(path!)).toList() ;
                    }
                );
              }
              else
              {

                Toast.show("Max Photos Reached 4".toString(), context,duration:Toast.LENGTH_SHORT,
                    gravity: Toast.BOTTOM);


              }
            },
            child: ListTile(
              leading: CircleAvatar(
                radius: 30,
                child: Icon(Icons.add_a_photo,color: Colors.white,),
                backgroundColor: Colors.blue,
              ),
              title: Text("Add New Photos",
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

      SizedBox(height: 20,),

                Text("New Photos",

                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,

                  ),
                ),
                SizedBox(height: 20,),
      Padding(
        padding: const EdgeInsets.only(left:0.0, right: 0),
        child: Container(
              height: 100,
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

              ],
            ),
          ),
        ),
      ),

    );
  }

}


