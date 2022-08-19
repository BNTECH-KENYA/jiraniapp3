import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiraniapp/pages/home.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:pinput/pinput.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OTPScreen extends StatefulWidget {
  final String phone;
  final String name;
  OTPScreen(this.phone,  this.name);
  @override
  State<OTPScreen> createState() => _OTPScreenState();

}

class _OTPScreenState extends State<OTPScreen> {

  final OtpFieldController _otpverController = OtpFieldController();
  final GlobalKey<ScaffoldState> _scaffoldkey = GlobalKey<ScaffoldState>();
  late String _verifivationCode;
  bool isLoading = false;
  int timeLeft = 60;
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
                  _saveAuthData(widget.name, value.user?.phoneNumber, value.user?.uid);

                }
              });
            }catch(e)
              {
                _scaffoldkey.currentState
                    ?.showSnackBar(
                  SnackBar(content: Text('invalid OTP + ${e.toString()}'))
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
            onTap: () async {
              setState(
                      (){
                    timeLeft = 60;
                  }
              );
             await _verifyPhone();
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
    _startCountDown();
    print(widget.phone.toString() +"   "+ widget.name.toString());

    await FirebaseAuth.instance.verifyPhoneNumber(

        phoneNumber: '${widget.phone}',
        verificationCompleted: (PhoneAuthCredential credential) async
        {
          await FirebaseAuth.instance
              .signInWithCredential(credential)
              .then((value) async{
                if(value.user != null)
                  {
                    _saveAuthData(widget.name, value.user?.phoneNumber, value.user?.uid);
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
      timeout: Duration(seconds: 1),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   _verifyPhone();
  }

    void _saveAuthData(name, phonenoin, uidin) async
    {

      final data = <String, dynamic>
      {
        "name":name,
        "phone":phonenoin,
        "uid":uidin,
      };

      FirebaseFirestore db = FirebaseFirestore.instance;

      setState(() {
        isLoading = true;
      });
      print(uidin.toString());
      final docref = db.collection("userdd").doc(phonenoin);
     await docref.get().then((DocumentSnapshot snapshot) async {
        if(snapshot.exists)
          {
            setState((){
              isLoading = false;
            });

            Navigator.of(context).pop();

          }
        else{
          await db.collection("userdd").doc(phonenoin).set(data).then((data2)=>{
          setState((){
          isLoading = false;
          }),
          Navigator.of(context).push(
          MaterialPageRoute
          (builder: (context)=>HomePage())
          )
          });

        }

      });



    }
}
