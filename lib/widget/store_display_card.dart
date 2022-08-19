import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/stores_model.dart';
import '../pages/allItemsDisplay.dart';

class Store_Display_Card extends StatelessWidget {
  const Store_Display_Card({Key? key, required this.store_model}) : super(key: key);
  final Store_Model store_model;

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
                  (builder: (context)=>All_Items()));
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
             color: Colors.white,
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
                              store_model.store_photo_links[0].toString()),
                        ),
                    ),

                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 14.0, bottom: 6),
                  child: Text(store_model.storename),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
