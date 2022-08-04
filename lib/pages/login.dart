import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiraniapp/pages/otp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jiraniapp/pages/roomcleaningbody.dart';
import 'package:jiraniapp/pages/services.dart';
import 'package:jiraniapp/pages/shoppingPage.dart';
import 'package:jiraniapp/pages/tabslayout.dart';
import 'package:toast/toast.dart';

import '../widget/card_design.dart';
import '../widget/shoppingBody.dart';
import 'SignUp.dart';
import 'Stores.dart';
import 'addNewItem.dart';
import 'already_have_an_account.dart';
import 'editItem.dart';
import 'home.dart';
import 'newStore.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _controller = TextEditingController();
  TextEditingController _lname = TextEditingController();
  TextEditingController _fname = TextEditingController();
  String countryname = "";
  String countrycode = "";
  bool isLoading = false;

  Future<void> checkAuth()async {
   await FirebaseAuth.instance
        .authStateChanges()
        .listen((user)
    {
      if(user != null)
      {
        Navigator.of(context).push(
            MaterialPageRoute
                (builder: (context)=>HomePage())
        );
      }

      else{
        print("no user");
      }
    });
  }

  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> getUser_data(phonenumber) async{
    final docref = db.collection("userdd").doc(phonenumber);
    await docref.get().then((res) =>{
      print("matching ${res.data()}"),
      if(res.data() != null)
        {
          setState(
              (){
                isLoading = true;
              }
          ),
        Toast.show("That number Has An Account already".toString(), context,duration:Toast.LENGTH_SHORT,
    gravity: Toast.BOTTOM),
          Navigator.of(context).push(
              MaterialPageRoute
                (builder: (context)=>SignUpScreen())
          ),
        }

      else{
        setState(
                (){
              isLoading = true;
            }
        ),
        Navigator.of(context).push(
        MaterialPageRoute
          (builder: (context)=>OTPScreen(phonenumber, "${_fname.text}-${_lname.text}"))
    ),
      }
    }, onError: (e) {

    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    ()async{
      checkAuth();
    }();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Colors.white,
      body:SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
              child: Column(
                children: [
                  SizedBox( height: 35,),
                  CircleAvatar(
                    radius: 30,
                    child: Icon(Icons.login, color:Colors.white),
                    backgroundColor: Colors.blue,
                  ),
                  SizedBox( height: 10,),
                  Container(
                      child:Center(
                        child: Text(
                          'Register',
                          style:TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize:22
                          ),
                        ),

                      )
                  ),
                  SizedBox( height: 10,),
                  Container(
                      child:Center(
                        child: Text(
                          'Add a name and phone number we\'ll send you a verification code',
                          style:TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize:14,
                            color:Colors.black38,
                          ),
                          textAlign:TextAlign.center,
                        ),

                      )
                  ),
                  SizedBox( height: 10,),
                  Container(
                    margin: EdgeInsets.only(top:40,right:10, left:10),
                    child: TextFormField(
                      style: TextStyle(
                        fontSize: 14,
                      ),
                      decoration: InputDecoration(
                          hintText: 'First name...',
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black12),
                            borderRadius: BorderRadius.circular(5)
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black12),
                            borderRadius: BorderRadius.circular(10)
                          ),

                      ),
                      maxLength: 20,
                      keyboardType: TextInputType.text,
                      controller: _fname,
                    ),
                  ), Container(
                    margin: EdgeInsets.only(top:40,right:10, left:10),
                    child: TextFormField(
                      style: TextStyle(
                        fontSize: 14,
                      ),
                      decoration: InputDecoration(
                          hintText: 'last name...',
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black12),
                            borderRadius: BorderRadius.circular(5)
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black12),
                            borderRadius: BorderRadius.circular(10)
                          ),

                      ),
                      maxLength: 20,
                      keyboardType: TextInputType.text,
                      controller: _lname,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      color: Colors.white,
                      child:Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text("Select Country",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),),
                          ),
                          SizedBox( height: 10,),
                          SizedBox(
                            width: 150,
                            height: 50,
                            child: CountryCodePicker(
                              initialSelection:'IN',
                              showCountryOnly:false,
                              showOnlyCountryWhenClosed:false,
                              favorite:['+254','KE'],
                              enabled:true,
                              alignLeft:true,
                              onChanged:(code) =>{

                                countrycode = code.dialCode!,
                                countryname = code.name!
                              },
                              onInit:(code) async => {

                                countrycode = (await code?.dialCode)!,
                                countryname = (await code?.name)!
                              } ,
                              padding:EdgeInsets.all(4.0),
                            ),

                          ),
                        ],

                      ),

                    ),
                  ),
                  SizedBox( height: 10,),
                  Container(
                    margin: EdgeInsets.only(right:10, left:10),
                    child: TextFormField(
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold
                      ),
                      decoration: InputDecoration(
                          hintText: 'phone number format 7xx xxx xxx',
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black12),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black12),
                              borderRadius: BorderRadius.circular(10)
                          ),
                          suffixIcon: Icon(
                              Icons.check_circle,
                              color:Colors.green,
                              size:32
                          )
                      ),
                      maxLength: 10,
                      keyboardType: TextInputType.number,
                      controller: _controller,
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left:8.0,right: 8.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ButtonStyle(
                     foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.blue),
                    shape:MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)
                      )
                    )
                  ),
                  onPressed: () async {
                    if(countrycode != "")
                      {
                        if(_lname.text.toString().trim().isEmpty)
                          {
                            Toast.show("Enter Last Name".toString(), context,duration:Toast.LENGTH_SHORT,
                                gravity: Toast.CENTER);

                          }
                        else if(_fname.text.toString().trim().isEmpty)
                          {

                            Toast.show("Enter First Name".toString(), context,duration:Toast.LENGTH_SHORT,
                                gravity: Toast.CENTER);
                          }
                        else if(_controller.text.toString().trim().isEmpty || _controller.text.toString().trim().length != 9)
                          {
                            Toast.show("Enter phone number in the format 744 444 444".toString(), context,duration:Toast.LENGTH_SHORT,
                                gravity: Toast.CENTER);
                          }
                        else
                          {
                            String phoneno = countrycode+_controller.text.toString();
                            setState(
                                (){
                                  isLoading = true;
                                }
                            );
                           await getUser_data(phoneno);
                          }
                      }
                  },

                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Text(
                      'Next',
                      style:TextStyle(fontSize: 16)
                    ),
                  ),

                ),
              ),
            ),

            InkWell(
              onTap: (){
                Navigator.of(context).push(
                    MaterialPageRoute
                      (builder: (context)=>SignUpScreen())
                );
              },
              child:Container(
                width: double.infinity,
                height: 40,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Already Have an account? Login", style: TextStyle(
                        color: Colors.black
                    )),
                  ),
                ),
              ),
            )
          ],
        ),
      )

    );
  }
}
