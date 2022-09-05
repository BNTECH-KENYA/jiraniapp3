
import 'package:flutter/material.dart';

import '../services/http_helper_ipay.dart';
import 'checkout_page.dart';

class Ipay_Page extends StatefulWidget {
  const Ipay_Page({Key? key, required this.id, required this.amountip, required this.emailip, required this.uidaccessip}) : super(key: key);
  final String id, uidaccessip, amountip,emailip;

  @override
  _Ipay_PageState createState() => _Ipay_PageState();
}

class _Ipay_PageState extends State<Ipay_Page> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  late HttpHelper helper;
  late String _phone, _amount, _email = '';
  late bool _isSubmitted = false;
  late String result = '';

  TextEditingController phone = TextEditingController();
  TextEditingController amount = TextEditingController();
  TextEditingController email = TextEditingController();




  @override
  void initState() {
    helper = HttpHelper();
    super.initState();

    setState(
        (){
          phone.text = "0${widget.uidaccessip.substring(4, widget.uidaccessip.length)}";
          email.text = widget.emailip;
          amount.text = widget.amountip;
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: InkWell(
            onTap: (){

            },
            child: Icon(Icons.arrow_back, color: Colors.white,)),
        title: const Text('Confirmation Page', style:TextStyle(color:Colors.white)),
      ),
      body: Container(
        padding: const EdgeInsets.all(8),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: TextFormField(
                      controller: phone,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Phone number',
                            hintText: 'Enter Phone number'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        onSaved: (value) => _phone = value!),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: TextFormField(
                      controller: email,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Email',
                            hintText: 'Enter email'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter email';
                          }
                          return null;
                        },
                        onSaved: (value) => _email = value!),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: TextFormField(
                      controller: amount,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: false,
                        signed: true,
                      ),
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Amount',
                        hintText: 'Enter amount',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some text';
                        }
                        return null;
                      },
                      onSaved: (value) => _amount = value!,
                    ),
                  ),
                  _isSubmitted
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                    child: const Text('Pay', style: TextStyle(color: Colors.white),),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        elevation: 5.0,
                        minimumSize: const Size(250.0, 40.0),
                        textStyle: const TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                        )),
                    onPressed: _buttonSubmitted,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<String> makepayement(String phone, String email, String amount) async {
    var response = (await helper.generateUrl(phone, email, amount, "${widget.id}","${widget.uidaccessip.substring(1,widget.uidaccessip.length)}"));
    //print(resultData);
    return response;
  }

  Future _buttonSubmitted() async {
    setState(() {
      _isSubmitted = true;
    });
    final form = _formKey.currentState!;
    if (form.validate()) {
      form.save();

      result = (await makepayement(_phone, _email, _amount));

      if (result.isNotEmpty) {
        MaterialPageRoute route = MaterialPageRoute(
            builder: (BuildContext context) => CheckoutPage(result));
        Navigator.of(context).push(route);

        setState(() {
          _isSubmitted = false;
        });
      }
    }
  }
}