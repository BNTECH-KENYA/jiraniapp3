import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiraniapp/pages/login.dart';
import 'package:jiraniapp/pages/otp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jiraniapp/pages/roomcleaningbody.dart';
import 'package:jiraniapp/pages/services.dart';
import 'package:jiraniapp/pages/shoppingPage.dart';
import 'package:jiraniapp/pages/tabslayout.dart';
import 'package:toast/toast.dart';

import '../widget/card_design.dart';
import '../widget/shoppingBody.dart';
import 'Stores.dart';
import 'addNewItem.dart';
import 'already_have_an_account.dart';
import 'editItem.dart';
import 'home.dart';
import 'newStore.dart';
import 'otpsignin.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);
  @override
  State<SignUpScreen> createState() => _LoginScreenState();
}
class _LoginScreenState extends State<SignUpScreen> {
  TextEditingController _controller = TextEditingController();
  TextEditingController _lname = TextEditingController();
  TextEditingController _fname = TextEditingController();
  String countryname = "";
  String countrycode = "";

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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    ()async{
     await checkAuth();
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
                  SizedBox( height: 50,),
                  CircleAvatar(
                    radius: 30,
                    child: Icon(Icons.login, color:Colors.white),
                    backgroundColor: Colors.blue,
                  ),
                  SizedBox( height: 15,),
                  Container(
                      child:Center(
                        child: Text(
                          'Enter Details To Login',
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
                          'Add a phone number we\'ll send you a verification code',
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
                  SizedBox( height: 20,),

                  Container(
                    margin: EdgeInsets.only(right:10, left:10),
                    child: TextFormField(
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold
                      ),
                      decoration: InputDecoration(
                          hintText: 'phone Numer Format 7xx xxx xxx',
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

                  onPressed: () {
                    if(countrycode != "")
                      {
                        if(_controller.text.toString().trim().isEmpty || _controller.text.toString().trim().length != 9)
                          {
                            Toast.show("Enter phone number in the format 7xx xxx xxx".toString(), context,duration:Toast.LENGTH_SHORT,
                                gravity: Toast.BOTTOM);
                          }
                        else
                          {
                            String phoneno = countrycode+_controller.text.toString();
                            Navigator.of(context).push(
                                MaterialPageRoute
                                  (builder: (context)=>OTPScreenSignIn(phoneno))
                            );
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
                      (builder: (context)=>LoginScreen())
                );
              },

              child: Container(
                width: double.infinity,
                height: 40,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Don't Have an account? SignUp", style: TextStyle(
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
