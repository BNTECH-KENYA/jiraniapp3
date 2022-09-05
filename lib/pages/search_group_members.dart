import 'package:flutter/material.dart';

class Search_Contributor extends StatefulWidget {
  const Search_Contributor({Key? key}) : super(key: key);

  @override
  State<Search_Contributor> createState() => _Search_ContributorState();
}

class _Search_ContributorState extends State<Search_Contributor> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: TextFormField(
            decoration: InputDecoration(
                hintStyle: TextStyle(
                  color: Colors.black87,

                ),
                hintText: "Search",
                prefix: Icon(Icons.search, color: Colors.white,)
            ),
          ),
        ) ,
      ),

      body: ListView(

      ),
    );
  }
}
