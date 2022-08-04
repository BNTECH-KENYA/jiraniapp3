import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiraniapp/models/service_list_display.dart';

import '../pages/filtered_services.dart';

class Service_Category_Card extends StatelessWidget {
  const Service_Category_Card({Key? key, required this.service_model}) : super(key: key);
  final Service_List_Display service_model;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(),
      width: size.width * 0.7,
      child: Card(
        child: InkWell(
          onTap: () {
            Navigator.of(context).push(
                MaterialPageRoute
                  (builder: (context)=>Filtered_Services(search_criteria: 'category-${service_model.service_category}',)));
          },
          hoverColor: Colors.black,
          splashColor: Colors.black38,
          child: Column(
            children: [
              Container(
                height: size.height * 0.24,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: NetworkImage(
                      service_model.service_photo_links[0].toString(),
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      service_model.service_category,
                      style: TextStyle(fontSize: 18),
                    ),
                    Stack(
                      children: [
                        Container(
                          child: CircleAvatar(
                            radius: 15,
                            backgroundImage: NetworkImage(
                                service_model.service_photo_links[0].toString()),
                          ),
                        ),

                        Container(
                          padding: EdgeInsets.only(left: 15),
                          child: CircleAvatar(
                              backgroundColor: Colors.blue,
                              radius: 15, child: Icon(Icons.more_horiz)),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
