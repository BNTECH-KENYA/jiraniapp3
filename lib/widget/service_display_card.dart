import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/service_list_display.dart';
import '../pages/serviceinfo.dart';

class Service_Display_Card extends StatelessWidget {
  const Service_Display_Card({Key? key, required this.service_list}) : super(key: key);
  final Service_List_Display service_list;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      width: MediaQuery.of(context).size.width * 0.30,
      child: Card(
        child: InkWell(
          splashColor: Colors.black,
          onTap: () {

            Navigator.of(context).push(
                MaterialPageRoute
                  (builder: (context)=>ServiceInfo(groupServiceid: service_list.service_cloud_id,)));
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            color: Colors.white
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 10.0,
                  ),
                  child: Container(
                      height: 70,
                      width: MediaQuery.of(context).size.width * 0.30,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage(
                              service_list.service_photo_links[0].toString()),
                        ),
                      ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 14.0, bottom: 6),
                  child: Text(service_list.service_name),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
