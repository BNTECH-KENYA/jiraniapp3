import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:share/share.dart';

import '../blocs/constants.dart';
import '../components/product_card.dart';
import '../components/section_title.dart';
import '../components/service_form.dart';
import '../components/shoppingcateggories.dart';
import '../detail/detail_screen.dart';
import '../models/Item_model.dart';
import 'addNewItem.dart';
import 'home.dart';
import 'loading_screen.dart';
import 'my_contributions.dart';

class All_Items extends StatefulWidget {
  const All_Items({Key? key}) : super(key: key);

  @override
  State<All_Items> createState() => _All_ItemsState();
}

class _All_ItemsState extends State<All_Items> {

  FirebaseFirestore db = FirebaseFirestore.instance;

  List<Item_Model> ? item_model = [];
  List<Item_Model>  item_model_categories = [];
  List<String>  categories_strings = [];
  bool isLoading = true;


  Future<void> getItemData() async {
    final itemsListings = db.collection("ItemData");
    await itemsListings.get().then((ref){
      print("redata 1${ref.docs}");
      setState(
              (){
            ref.docs.forEach((element) {
              item_model?.add(
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

              if(!categories_strings.contains(element.data()['itemcategory']))
                {
                  categories_strings.add(element.data()['itemcategory']);


                  item_model_categories.add(
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    () async {
      await getItemData();
    }();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading ? Loading_Screen():Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
          onPressed: (){

            Navigator.of(context).push(
                MaterialPageRoute
                  (builder: (context) => AddNewItem(store_id: "store_cloud_id",))
            );

          },
          child: Icon(Icons.add, color:Colors.white),
        ),
        appBar: AppBar(
          backgroundColor: Colors.blue,
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              Text(
                "Jirani Products",
                style: TextStyle(
                  color:Colors.white
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.notifications, color:Colors.white),
              onPressed: () {},
            ),
          ],
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          padding:  EdgeInsets.all(defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Explore",
                style: Theme.of(context)
                    .textTheme
                    .headline4!
                    .copyWith(fontWeight: FontWeight.w500, color: Colors.black),
              ),
              const Text(
                "best Products for you",
                style: TextStyle(fontSize: 18),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: defaultPadding),
                child: SearchForm(),
              ),

              SizedBox(
                height: 84,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: item_model_categories.length,
                  itemBuilder: (context, index) => CategoryCard(
                    icon: item_model_categories[index].photosLinks,
                    title: item_model_categories[index].category,
                    press: () {},
                  ),
                  separatorBuilder: (context, index) =>
                  const SizedBox(width: defaultPadding),
                ),
              ),
              Column(
                children: [
                  Padding(
                    padding:  EdgeInsets.symmetric(vertical: defaultPadding),
                    child: SectionTitle(
                      title: "New Arrival",
                      pressSeeAll: () {},
                    ),
                  ),
                  SingleChildScrollView(
                    physics: const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(
                        item_model!.length,
                            (index) => Padding(
                          padding: const EdgeInsets.only(right: defaultPadding),
                          child: ProductCard(
                            title: item_model![index].itemname,
                            image: item_model![index].photosLinks,
                            price: int.parse(item_model![index].itemprice),
                            press: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        DetailsScreen(
                                            product: item_model![index]),
                                  ));
                            }, bgColor: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
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
