import 'package:chatting_app/Utils/utils.dart';
import 'package:chatting_app/screens/signUp.dart';
import 'package:chatting_app/service/loginService.dart';
import 'package:flutter/material.dart';
import 'package:international_phone_input/international_phone_input.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var formType = FormType.phoneLogin;
  String _warning = "";
  String _phone;
  final _formKey = GlobalKey<FormState>();
  void onPhoneNumberChange(
      String number, String internationalizedPhoneNumber, String isoCode) {
    setState(() {
      _phone = internationalizedPhoneNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey,
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              child: Form(
                key: _formKey,
                autovalidate: false,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _warning.isEmpty
                        ? SizedBox(
                            height: 0,
                          )
                        : Container(
                            color: Colors.amberAccent,
                            child: ListTile(
                              leading: Icon(Icons.error_outline),
                              title: Expanded(child: Text(_warning)),
                              trailing: IconButton(
                                icon: Icon(Icons.cancel),
                                onPressed: () {
                                  setState(() {
                                    _warning = "";
                                  });
                                },
                              ),
                            ),
                          ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      "Phone Login",
                      style: TextStyle(fontSize: 30),
                    ),
                    SizedBox(
                      height: 60,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: InternationalPhoneInput(
                          decoration: InputDecoration(
                            suffixIcon: Icon(Icons.phone),
                            labelText: "Phone",
                            labelStyle: TextStyle(color: Colors.black),
                            helperText: "",
                            border: OutlineInputBorder(),
                            counterText: "",
                          ),
                          onPhoneNumberChange: onPhoneNumberChange,
                          initialPhoneNumber: _phone,
                          initialSelection: 'IN',
                          showCountryCodes: true),
                    ),
                    RaisedButton(
                      color: Colors.blue,
                      elevation: 8.0,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            width: 80, child: Center(child: Text("Continue"))),
                      ),
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(30.0))),
                      onPressed: () async {
                        var result = await AuthService()
                            .signInWithPhone(_phone, context);
                        if (_phone == null || result == "error") {
                          setState(() {
                            _warning = "Phone authentication is invalid";
                          });
                        }
                      },
                    ),
                    SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
