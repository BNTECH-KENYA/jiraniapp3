import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jiraniapp/pages/loading_screen.dart';
import '../models/contributions.dart';
import 'login.dart';

class My_Contributions extends StatefulWidget {
  const My_Contributions({Key? key}) : super(key: key);

  @override
  State<My_Contributions> createState() => _My_ContributionsState();
}

class _My_ContributionsState extends State<My_Contributions> {
  final db = FirebaseFirestore.instance;
  String uidAccess = "0";
  bool isLoading = true;
  List<Contrubtions_Model> contributions = [];

  Future<void> get_My_Contributions() async {

    final my_contributions = db.collection("contributionsupdate").where("senderphoneno", isEqualTo: uidAccess);

    await my_contributions.get().then((ref) {
      print("redata 1${ref.docs}");
      setState(
              () {
            ref.docs.forEach((element) {
              print("${element.data()['senderphoneno']} ${uidAccess} " );
              if(element.data()['senderphoneno'] == uidAccess)
              {
                print('4*************************************');
                print(element.data()['location']);

                print('4*************************************');

                contributions.add(
                    Contrubtions_Model(

                      groupname: element.data()['groupname'],
                      groupid: element.data()['groupuid'],
                      amount: element.data()['message'],
                      chatid: element.id.toString(),
                      date:"20 July 2020",
                    ));
              }

            });
            isLoading = false;
          }
      );
    });

  }

  /*
  "timestamp":DateTime.now().microsecondsSinceEpoch,
      "groupuid":widget.groupid,
      "sendername": name,
      "message": message,
      "senderphoneno":uidAccess,
      "groupname":groupname,
   */

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
        get_My_Contributions();
        print("!!!!!!!!!!+++++++++++++++++++++${user.phoneNumber!}");
      }
      else{
        setState(
                (){
              isLoading = false;
            }
        );
        Navigator.of(context).push(
            MaterialPageRoute
              (builder: (context)=>LoginScreen()));
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
    return isLoading? Loading_Screen() :Scaffold(
          appBar: AppBar(
            backgroundColor:  Colors.blue,
            iconTheme: IconThemeData(
              color: Colors.white,
            ),
            title: Text("Contributions", style: TextStyle(
              color: Colors.white
            )),

          ),

      body:  ListView.builder(
    itemCount: contributions.length,
    physics: BouncingScrollPhysics(),
    padding: EdgeInsets.symmetric(horizontal: 3),
    itemBuilder: (context, index) {

     return Card(
       color:Colors.grey[100],
       child: ListTile(
          leading: Text(contributions[index].date, style: TextStyle(
            color: Colors.black,
          )
            ,),
          title:Text(contributions[index].groupname, style: TextStyle(
            color: Colors.black,
          )
            ,),
          trailing:Text(contributions[index].amount + " KSH", style: TextStyle(
            color: Colors.black,
          )
            ,),
        ),
     );
    },

      ),

    );
  }
}
