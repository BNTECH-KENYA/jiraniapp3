import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Photo_Holder extends StatelessWidget {
  const Photo_Holder({Key? key, required this.imageLink, required this.fundelphoto}) : super(key: key);
  final String imageLink;
  final Function fundelphoto;

  @override
  Widget build(BuildContext context) {
    return   Container(
      width: MediaQuery.of(context).size.width * 0.7,
      height: 150,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/product_2.jpeg"),
              fit: BoxFit.fitHeight
          )
      ),

      child: Stack(
        children: [
          Positioned(
              bottom:5,
              right: 5,
              child: InkWell(
                onTap: (){
                  fundelphoto();
                },
                child: Card(
                  color: Colors.blue,
                  child: Container(
                    width: 70,
                    height: 30,
                    child: Center(
                      child: Text("Delete",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                        ),),
                    ),
                  ),
                ),
              ))
        ],
      ),

    );
  }
}
