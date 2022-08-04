import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiraniapp/models/chatModel.dart';

import '../pages/serviceinfo.dart';

class ServiceTile extends StatelessWidget {
  const ServiceTile({Key? key, required this.services}) : super(key: key);
  final ChatModel services;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>ServiceInfo(groupServiceid: '',)));
      },
      child: Column(
        children: [
          ListTile(
            leading: Image.asset(
              "assets/catering.jfif",
              width: 100,
              height: 100,
              fit: BoxFit.fill,

            ),
            title: Text(services.name,
                style:TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                )),
            subtitle:Column(
              children: [
                ListTile(
                  title: Text("Muranga town",
                      style:TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold
                      )),
                ),
              ],
            ),
            trailing: Icon(Icons.read_more_sharp, color: Colors.blue,),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20, left: 80),
            child: Divider(
              thickness: 1,
            ),
          ),

        ],
      ),
    );
  }
}
