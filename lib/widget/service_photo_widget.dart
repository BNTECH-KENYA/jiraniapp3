import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Service_Photo_Widget extends StatelessWidget {
  const Service_Photo_Widget({Key? key, required this.photo_link, required this.remove_function}) : super(key: key);
  final String photo_link;
  final Function remove_function;

  @override
  Widget build(BuildContext context) {
    var device_size = MediaQuery.of(context).size;
    return Card(
      color: Colors.blue,
      child: Row(
        children: [

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: device_size.height * 0.24,
              width: device_size.width*0.75,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(photo_link),
                ),
              ),
            ),
          ),
          Container(
            height: device_size.height * 0.24,
            width: device_size.width*0.75,

            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(
                    onPressed: (){
                      remove_function();
                    },
                    icon: Icon(Icons.delete_forever, color: Colors.red,)

                )
              ],
            ),
          ),

        ],
      ),

    );
  }
}
