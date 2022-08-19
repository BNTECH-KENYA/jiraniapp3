import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiraniapp/pages/home.dart';
import 'package:jiraniapp/pages/login.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:pinput/pinput.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'SignUp.dart';

class OTPScreenSignIn extends StatefulWidget {
  final String phone;
  OTPScreenSignIn(this.phone);
  @override
  State<OTPScreenSignIn> createState() => _OTPScreenSignInState();

}
class _OTPScreenSignInState extends State<OTPScreenSignIn> {

  final OtpFieldController _otpverController = OtpFieldController();
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  late String _verifivationCode;
  bool isLoading = true;

  int timeLeft = 60;



  String username = "";

  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> getUser_data() async{
    print("!!!!!!!!!!*********************************************${widget.phone}");
    final docref = db.collection("userdd").doc(widget.phone);
    await docref.get().then((res) =>{
      print("matching ${res.data()}"),
      if(res.data() != null)
        {
          print("matching"),
          setState(
                  ()
              {

                username = res.data()!['name'];
                isLoading= false;

              }
          ),

          _verifyPhone(),

        }

      else{
        Navigator.of(context).push(
        MaterialPageRoute
          (builder: (context)=>LoginScreen())
    ),
      }

    }, onError: (e) {

    });
  }

  void _startCountDown(){
    Timer.periodic(Duration(seconds: 1), (timer){
      if(timeLeft >0)
      {
        setState(
                (){
              timeLeft--;
            }
        );
      }
      else
      {
        timer.cancel();
      }


    });
  }

  @override
  void initState() {
    // TODO: implement initState
    () async{
     await getUser_data();
    }();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key:_scaffoldkey,
      appBar: AppBar(
        actionsIconTheme: IconThemeData(
          color:Colors.white,
        ),
        title:Text('OTP Verification',
          style: TextStyle(
            color:Colors.white,
          ),
        ),
        backgroundColor:Colors.blue,
      ),
      body: isLoading? Center(child: CircularProgressIndicator(), ):Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 60),
            child: Center(

              child: Column(
                children: [
                  Text(
                      "welcome ${username}",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 26
                    ),
                  ),
                  SizedBox(height: 15),    Text(
                      "Verification",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 26
                    ),
                  ),
                  SizedBox(height: 30),
                  Text(
                    'Enter the code sent to the number',
                    style: TextStyle(
                        color:Colors.grey,
                        fontSize: 16),

                  ),
                  SizedBox(height: 20),
                  Text(
                    '${widget.phone}',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ],

              ),
            ),
          ),
          SizedBox(height: 40),
          OTPTextField(
            length: 6,
            width: MediaQuery.of(context).size.width,
            fieldWidth: 30,
            style: TextStyle(
                fontSize: 12
            ),
            textFieldAlignment: MainAxisAlignment.spaceAround,
            fieldStyle: FieldStyle.underline,
            controller: _otpverController,

            onCompleted: (pin) async{
              print("Completed: " + pin);
            try{
              await FirebaseAuth.instance.signInWithCredential(
                  PhoneAuthProvider.credential(
                      verificationId:_verifivationCode, smsCode:pin
                  )
              ).then((value) async{
                if(value.user != null)
                {
                  //this we need to store in firestore
                  _saveAuthData(username, value.user?.phoneNumber, value.user?.uid);

                }
              });
            }catch(e)
              {
                _scaffoldkey.currentState
                    ?.showSnackBar(
                  SnackBar(content: Text('invalid OTP'))
                );
              }
            },
          ),
          SizedBox(height:30),

          (timeLeft>0) ?
          Container(
            width: double.infinity,
            child: Center(
              child: Text(
                "Resend OTP in ${timeLeft.toString()}",
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 16,
                ),
              ),
            ),
          )
              :
          InkWell(
            onTap: (){
              setState(
                  (){
                    timeLeft = 60;
                  }
              );
              _verifyPhone();

            },

            child: Container(
              width: double.infinity,
              child: Center(
                child: Text(
                  "Didn't recieve code? \n"
                      "Resend",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),

        ],
      )
    );
  }

  _verifyPhone() async {

    print(widget.phone.toString() +"   "+ username.toString());
    _startCountDown();
    await FirebaseAuth.instance.verifyPhoneNumber(

        phoneNumber: '${widget.phone}',
        verificationCompleted: (PhoneAuthCredential credential) async
        {
          await FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((value) async{
                if(value.user != null)
                  {
                    _saveAuthData(username, value.user?.phoneNumber, value.user?.uid);
                  }
          });

        },
        verificationFailed: (FirebaseException e)
        {
          print(e.message);

        },

        codeSent:(String verificationID, int? resendToken)
        {
          setState(
              ()
                  {
                    _verifivationCode = verificationID;

                  }
          );
        },
        codeAutoRetrievalTimeout: (String verificationId)
        {

          setState(
                  ()
              {
                _verifivationCode = verificationId;
              }
          );
        },
      timeout: Duration(seconds: 60),
    );
  }

    void _saveAuthData(name, phonenoin, uidin) async
    {
      Navigator.of(context).push(
          MaterialPageRoute
            (builder: (context)=>HomePage())
      );
    }
}