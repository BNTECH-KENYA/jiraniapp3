import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Group_Categories extends StatefulWidget {
  const Group_Categories({Key? key, required this.collection_name}) : super(key: key);
  final String collection_name;

  @override
  State<Group_Categories> createState() => _Group_CategoriesState();
}

class _Group_CategoriesState extends State<Group_Categories> {

  List<String> group_categories = [
    "Wedding","Dowery","Medical Financing", "Sacco", "Women Empowernment Group",
    "Saving Account",

  ];

  bool searchToggle = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         backgroundColor: !searchToggle? Colors.blue: Colors.white,

        title: !searchToggle? Text("Select ${widget.collection_name} Category",

          style: TextStyle(color: Colors.white),


        ): TextField(
        decoration: InputDecoration(
          hintText: "Search",
          hintStyle: TextStyle(
            color: Colors.black,
          )
        ),
        ),

        iconTheme: IconThemeData(
          color: !searchToggle? Colors.white: Colors.black
        ),

        actionsIconTheme: IconThemeData(
          color: Colors.white
        ),

        actions: [
          IconButton(
              onPressed: () {

                setState(
                    (){
                      searchToggle = !searchToggle;
                    }
                );
              },
              icon: !searchToggle? Icon(Icons.search, color: Colors.white,):Icon(Icons.cancel, color: Colors.grey,) ),

        ],
      ),

      body: ListView.separated(
          scrollDirection: Axis.vertical,
          itemCount: group_categories.length,
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, index){
            return InkWell(
              onTap: (){
                Navigator.pop(context, group_categories[index] );
              },
              child: ListTile(
                leading: Icon(Icons.star, color: Colors.blue,),
                title: Text("${group_categories[index]}",
                style:TextStyle(
                  color: Colors.black87
                )),
                trailing: Icon(Icons.navigate_next_sharp, color: Colors.black87,),
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 20,),


      )
    );
  }
}
