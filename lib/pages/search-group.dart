import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiraniapp/pages/loading_screen.dart';

import '../models/grouplistmodel.dart';
import '../widget/grouptile_search.dart';
import 'login.dart';

class Groups_Search extends StatefulWidget {
  const Groups_Search({Key? key}) : super(key: key);

  @override
  State<Groups_Search> createState() => _Groups_SearchState();

}

class _Groups_SearchState extends State<Groups_Search> {

  List<GroupListModel> groupsfromdb =[];
  List<GroupListModel> search_results = [];
  bool isLoading = true;

  final db = FirebaseFirestore.instance;

  String uidAccess = "0";
  String search_filter = "";

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
        getGroupListings();
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

  Future<void> getGroupListings() async {

    print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~!!!!!!!!!!~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~${uidAccess}");

    final groupListingdb = db.collection("GroupData");
    final groupListing = groupListingdb.where("contributors", arrayContains: uidAccess.toString());
    print("checking if group data is workng  1${groupListing}");

    await groupListing.get().then((ref){
      print("redata 1${ref.docs}");
      setState(
              (){
            ref.docs.forEach((element) {
              groupsfromdb.add(
                  GroupListModel(
                      groupname: element.data()['groupname'],
                      groupid: element.id.toString(),
                      category: element.data()['category'],
                      groupprofilepic:element.data()['groupprofilepic']
                  ));
              search_results.add(
                  GroupListModel(
                      groupname: element.data()['groupname'],
                      groupid: element.id.toString(),
                      category: element.data()['category'],
                      groupprofilepic:element.data()['groupprofilepic']
                  ));
              print("checking if group data is workng  ${element.data()['groupname']}");
            });
            isLoading = false;
          }
      );
    });
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
    return isLoading? Loading_Screen() :Scaffold(

      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: TextFormField(
            onChanged: (value){


              if(value.trim().length == 0)
              {
                setState(
                        (){
                      search_filter = "";
                      search_results.clear();
                      search_filter = value.trim();
                      groupsfromdb?.forEach((element) {


                          search_results.add(element);


                      });

                    }
                );

              }
              else
              {
                setState(
                        (){
                      search_results.clear();
                      search_filter = value.trim();
                      groupsfromdb?.forEach((element) {

                        if(element.groupname.contains(search_filter))
                        {
                          search_results.add(element);
                        }

                      });
                    }
                );
              }

            },
            decoration: InputDecoration(
                hintStyle: TextStyle(
                  color: Colors.black87,
                ),
                hintText: "Search",
                prefix: Icon(Icons.search, color: Colors.white,)
            ),
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.only(top:8.0),
        child: ListView.builder(
            itemCount: search_results.length,
            itemBuilder: (context, index){
              return GroupTileSearch(groupModel: search_results[index],);
            },
          ),
      ),

    );
  }
}
