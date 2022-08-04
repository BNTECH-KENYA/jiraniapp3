import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiraniapp/pages/my_products.dart';

import 'login.dart';
import 'my_services.dart';

class My_Profile extends StatefulWidget {
  const My_Profile({Key? key}) : super(key: key);

  @override
  State<My_Profile> createState() => _My_ProfileState();
}

class _My_ProfileState extends State<My_Profile> {

  String uidAccess = "0";
  String username = "0";
  bool isLoading = true;

  Future<void> checkAuth()async {
    await FirebaseAuth.instance
        .authStateChanges()
        .listen((user)
    {
      if(user != null)
      {

        print("!!!!!!!!!!+++++++++++++++++++++++++++++${user.phoneNumber!}");
        setState(
                (){
              uidAccess =  user.phoneNumber!;
            }
        );
        print("!!!!!!!!!!+++++++++++++++++++++${user.phoneNumber!}");
      }
      else{
        Navigator.of(context).push(
            MaterialPageRoute
              (builder: (context)=>LoginScreen()));
        setState(
                (){
              isLoading = false;
            }
        );
      }
    });
    print("!!!!!!!!!!*********************************************${uidAccess}");

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

        () async {
      await checkAuth();
    }();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.blue,
        iconTheme: IconThemeData(
          color:Colors.white,
        ),
        title: Text("My Profile", style:TextStyle(
          color:Colors.white,
        )),
      ),

      body:ListView(
        children: [
          SizedBox(height: 10,),
          InkWell(
            onTap: (){
              Navigator.of(context).push(
                  MaterialPageRoute
                    (builder: (context)=>My_Services()));
            },
            child: Card(
              color: Colors.white,
              child: ListTile(
                leading:Text("1", style:TextStyle(
                  color:Colors.black
                ),

                ),
                title: Text("My Services", style:TextStyle(
                    color:Colors.black
                ),
              ),
      trailing: Icon(Icons.arrow_forward, color: Colors.blue,)),
            ),
          ),
          SizedBox(height: 10,),
          InkWell(
            onTap: (){
              Navigator.of(context).push(
                  MaterialPageRoute
                    (builder: (context)=>My_Products()));
            },
            child: Card(
              color: Colors.white,
              child: ListTile(
                leading:Text("2", style:TextStyle(
                  color:Colors.black
                ),

                ),
                title: Text("My Products", style:TextStyle(
                    color:Colors.black
                ),
              ),
      trailing: Icon(Icons.arrow_forward, color: Colors.blue,)),
            ),
          ),
          SizedBox(height: 10,),
          InkWell(
            onTap: () async {

              await FirebaseAuth.instance.signOut();
              Navigator.of(context).push(
                  MaterialPageRoute
                    (builder: (context)=>LoginScreen()));

            },
            child: Card(
              color: Colors.white,
              child: ListTile(
                leading:Text("2", style:TextStyle(
                  color:Colors.black
                ),

                ),
                title: Text("Logout", style:TextStyle(
                    color:Colors.black
                ),
              ),
      trailing: Icon(Icons.logout, color: Colors.blue,)),
            ),
          ),
        ],
      )

    );
  }
}
