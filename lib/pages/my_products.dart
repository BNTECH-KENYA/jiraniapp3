import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:jiraniapp/detail/detail_screen.dart';
import 'package:jiraniapp/models/Item_model.dart';
import 'package:line_icons/line_icons.dart';
import 'package:share/share.dart';

import 'addNewItem.dart';
import 'home.dart';
import 'loading_screen.dart';
import 'login.dart';
import 'my_contributions.dart';
import 'newStore.dart';

class My_Products extends StatefulWidget {
  const My_Products({Key? key}) : super(key: key);
  @override
  State<My_Products> createState() => _My_ProductsState();
}

class _My_ProductsState extends State<My_Products> {

  List<Item_Model> my_Products=[];
  String search_criteria = "My items";
  String uidAccess = "0";
  bool isLoading = true;
  final db = FirebaseFirestore.instance;

  Future<void> get_My_Products() async {

    final service_listings = db.collection("ItemData").where("createdby", isEqualTo: uidAccess);

    await service_listings.get().then((ref) {
      print("redata 1${ref.docs}");
      setState(
              () {
            ref.docs.forEach((element) {
              print("${element.data()['createdby']} ${uidAccess} " );
              if(element.data()['createdby'] == uidAccess)
              {
                print('4*************************************');
                print(element.data()['location']);

                print('4*************************************');

                my_Products.add(
                    Item_Model(
                      createdby: element.data()['createdby'],
                      itemId: element.id.toString(),
                      itemname: element.data()['itemname'],
                      itemprice: element.data()['itemprice'],
                      category: element.data()['itemcategory'],
                      itemdescription: element.data()['itemdescription'],
                      location: element.data()['location']["formatted_address"],
                      photosLinks: element.data()['photosLinks'],

                    ));
              }

            });
            isLoading = false;
          }
      );
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
        get_My_Products();
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
        :Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute
                  (builder: (context)=>AddNewItem(store_id: '',)));
          },
          child: Icon(Icons.add_circle, color:Colors.white),

        ),
        appBar:  AppBar(
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
              Text(search_criteria,
                  style:TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  )),
              Text("${my_Products.length} products",
                  style:TextStyle(
                    color:Colors.white,
                    fontSize: 13,
                  )),

            ],
          ),

          actions: [
            IconButton(
                onPressed: (){},
                icon: Icon(Icons.search, color:Colors.white))
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: ListView.builder(
                  itemCount: my_Products.length,
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 3),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: (){
                        Navigator.of(context).push(
                            MaterialPageRoute
                              (builder: (context)=>DetailsScreen(product: my_Products[index])));
                      },
                      child: Container(
                        margin: EdgeInsets.only(top:16),
                        padding: EdgeInsets.only(left: 20),
                        child: Stack(
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 30),
                              child: Card(
                                child: Container(
                                  width: MediaQuery.of(context).size.width * 0.8,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black12.withOpacity(0.1),
                                          blurRadius: 1,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    padding: EdgeInsets.only(left: 80),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Text(
                                          "${my_Products[index].itemname}",
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.only(
                                            left: 10,
                                            bottom: 15,
                                          ),
                                          child: Text(

                                            "${my_Products[index].itemname}",
                                            style: TextStyle(
                                              color: Colors.brown,
                                            ),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                          children: [
                                            /*
                                          Text(
                                              "Jobs\n${freelancerlist[index].jobsdone}"),
                                          Text(
                                              "Ratings\n${freelancerlist[index].rating}"),
                                          Text(
                                              "Salary\n${freelancerlist[index].sal}"),

                                           */
                                          ],
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(""),
                                            IconButton(
                                                onPressed: (){
                                                }, icon: Icon(Icons.read_more_sharp, color:Colors.blue)),

                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.4,
                            ),

                            Container(
                              alignment: Alignment.centerLeft,
                              height: 145,
                              width: 90,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: NetworkImage(
                                          my_Products[index].photosLinks)))),

                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
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
