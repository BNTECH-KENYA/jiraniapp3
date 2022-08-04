import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';

import '../widget/service_photo_widget.dart';

class Editing_Service_Photos extends StatefulWidget {
  const Editing_Service_Photos({Key? key, required this.service_photo_links}) : super(key: key);
  final List<String> service_photo_links;

  @override
  State<Editing_Service_Photos> createState() => _Editing_Service_PhotosState();
}

class _Editing_Service_PhotosState extends State<Editing_Service_Photos> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
     backgroundColor: Colors.grey[200],
      appBar: AppBar(
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
            Text("Edit Service Photos",
                style:TextStyle(
                  color: Colors.white,
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                )),

          ],
        ),

        actions: [
          IconButton(
              onPressed: () async {
                if(widget.service_photo_links.length <3)
                 {

                 }
                else
                  {

                  }
              },
              icon: Icon(Icons.add_a_photo, color: Colors.white,))

        ],

      ),
      body: ListView.builder(
          itemCount:widget.service_photo_links.length ,
          itemBuilder: (BuildContext context, int index) {

            return Service_Photo_Widget(
              photo_link: widget.service_photo_links[index],
              remove_function:(){

                setState(
                        ()
                    {
                      _remove_Photo_Link(widget.service_photo_links[index]);
                    }
                );
              },  );

          }),
        bottomNavigationBar:Padding(
          padding: const EdgeInsets.only(bottom:8.0, right:2.0, left:2.0),
          child: GNav(
              rippleColor: Colors.white, // tab button ripple color when pressed
              hoverColor: Colors.blueGrey, // tab button hover color
              haptic: true, // haptic feedback
              tabBorderRadius: 15,
              tabActiveBorder: Border.all(color: Colors.blue, width: 1), // tab button border
              tabBorder: Border.all(color: Colors.grey, width: 1), // tab button border
              tabShadow: [BoxShadow(color: Colors.white.withOpacity(0.5), blurRadius: 8)], // tab button shadow
              curve: Curves.easeOutExpo, // tab animation curves
              duration: Duration(milliseconds: 900), // tab animation duration
              gap: 8, // the tab button gap between icon and text
              color: Colors.grey[800], // unselected icon color
              activeColor: Colors.blue, // selected icon and text color
              iconSize: 24, // tab button icon size
              tabBackgroundColor: Colors.blue.withOpacity(0.1), // selected tab background color
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5), // navigation bar padding
              tabs: [
                GButton(
                  icon: LineIcons.home,
                  text: 'Home',
                ),
                GButton(
                  icon: LineIcons.paypalCreditCard,
                  text: 'Payments',
                ),
                GButton(
                  icon: Icons.rate_review,
                  text: 'Rate',
                ),
                GButton(
                  icon: LineIcons.share,
                  text: 'Share',
                )
              ]
          ),
        )
    );
  }

  // remove photo link method
 void _remove_Photo_Link(value){

    widget.service_photo_links.remove(value);
 }

}
