import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Searched_Data_Filteres extends StatelessWidget {
  const Searched_Data_Filteres({Key? key, required this.photolink, required this.itemname, required this.desccription}) : super(key: key);

  final String photolink, itemname, desccription;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top:16.0),
      child: Card(
        color: Colors.white,
        child: Container(

          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height *0.25,

          child: Row(
            children: [
              Image(
                  image: NetworkImage(photolink),
                height: MediaQuery.of(context).size.height *0.25,
                width: MediaQuery.of(context).size.width *0.4,
                fit: BoxFit.cover,
              ),
              SizedBox(width: 10,),
              Container(
                width: MediaQuery.of(context).size.width *0.45,
                height: MediaQuery.of(context).size.height *0.25,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: double.infinity,

                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10,),
                          Text("${itemname}", style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            fontSize: 16,

                          ),),
                          SizedBox(height: 7,),
                          Text("${desccription}", style: TextStyle(
                            color: Colors.black,

                          ),),
                        ],
                      ),
                    ),

                    Card(
                      color: Colors.blue,
                      child: Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Container(
                          width: double.infinity,
                          height: 30,
                          child: Center(
                            child: Text(
                              "Read More",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ),

                      ),
                    )
                  ],
                ),
              )

            ],
          ),

        ),
      ),
    );
  }
}
