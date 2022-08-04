
import 'package:flutter/material.dart';

import '../models/freelancemodel.dart';
import 'cleanrooms.dart';

class rcbody extends StatefulWidget {
  rcbody({Key ? key}) : super(key: key);

  @override
  _rcbodyState createState() => _rcbodyState();
}
class _rcbodyState extends State<rcbody> {
  int count = 73;
  List<freelancer> freelancerlist = freelancer.freelancer1;
  late List val;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            Text("Services",
                style:TextStyle(
                  color: Colors.white,
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                )),
            Text("${count} Services",
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
                itemCount: freelancerlist.length,
                physics: BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 3),
                itemBuilder: (context, index) {
                  return Container(
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
                                      "${freelancerlist[index].name}",
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
                                        "${freelancerlist[index].role}",
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
                          height: 160,
                          width: 90,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: AssetImage(
                                      "assets/catering.jfif"))),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}