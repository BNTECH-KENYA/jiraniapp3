import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiraniapp/pages/services.dart';

import '../widget/shoppingBody.dart';
import 'grouppage.dart';

class TabsPage extends StatefulWidget {
  const TabsPage({Key? key}) : super(key: key);

  @override
  State<TabsPage> createState() => _TabsPageState();
}

class _TabsPageState extends State<TabsPage> with SingleTickerProviderStateMixin{

  late TabController _controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = TabController(length: 3, vsync: this, initialIndex: 0);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar:AppBar(
        backgroundColor: Colors.blue,
        title:Text("Jirani",
        style:TextStyle(
            color:Colors.white
        )),
            actions: [
              IconButton(icon:Icon(Icons.search, color:Colors.white), onPressed: () {  },),
              PopupMenuButton<String>(
                color:Colors.white,
                onSelected: (value)
                  {
                    print(value);
                  },
                  itemBuilder: (BuildContext context){
                    return[
                      PopupMenuItem(
                          child: Text("Settings"),
                        value:"Settings",
                      )
                    ];
                  }
              )


        ],

        bottom:TabBar(
          controller: _controller,
          indicatorColor: Colors.white,
          tabs: [
            Tab(
              text:'Groups'
            ),Tab(
              text:'Services'
            ),
            Tab(
              text:'My Shoppings'
            ),
          ],

        )
      ),

      body: TabBarView(
        controller: _controller,
       children:[

       ],
      )

    );
  }
}
