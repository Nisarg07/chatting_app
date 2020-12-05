import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:chatting_app/model/user.dart';
import 'package:chatting_app/screens/home.dart';
import 'package:chatting_app/service/database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _name = TextEditingController();
  String _warning = "";
  PermissionStatus _status;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Permission.contacts.status.then(_updateStatus);
  }

  var image;
  _validateForm() async {
    if (_name.text.isEmpty) {
      setState(() {
        _warning = "PLease enter the Name";
      });
      return false;
    } else {
      return true;
    }
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
                    GestureDetector(
                      child: CircleAvatar(
                        backgroundImage:
                            image != null ? FileImage(File(image)) : null,
                        radius: 60,
                      ),
                      onTap: () => showModalBottomSheet(
                          context: context,
                          builder: (context) => Container(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ListTile(
                                      leading: Icon(Icons.camera_alt),
                                      title: Text("Capture Image"),
                                      onTap: () async {
                                        var temp = await ImagePicker().getImage(
                                            source: ImageSource.camera);
                                        setState(() {
                                          image = temp.path;
                                        });
                                        Navigator.pop(context);
                                      },
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.filter),
                                      title: Text("Import from Gallery"),
                                      onTap: () async {
                                        var temp = await ImagePicker().getImage(
                                            source: ImageSource.gallery);
                                        setState(() {
                                          image = temp;
                                        });
                                        Navigator.pop(context);
                                      },
                                    )
                                  ],
                                ),
                              )),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: TextFormField(
                        maxLength: 150,
                        controller: _name,
                        autofocus: false,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          labelText: "Name",
                          labelStyle:
                              TextStyle(color: Colors.black, fontSize: 18),
                          helperText: "",
                          border: OutlineInputBorder(),
                          counterText: "",
                        ),
                        validator: (value) {
                          if (value.isEmpty) {
                            return "Please enter Name";
                          }
                          return null;
                        },
                        // onSaved: (value) => email = value,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    RaisedButton(
                      color: Colors.blue,
                      elevation: 8.0,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                            width: 80, child: Center(child: Text("CONTINUE "))),
                      ),
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(30.0))),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          _formKey.currentState.save();
                          if (await _validateForm()) {
                            await _askPermission();
                            var base64 =
                                base64Encode(await File(image).readAsBytes());
                            Users users = Users(
                                full_name: _name.text, profile_pic: base64);
                            await DbProvider.db.newUsers(users);
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (_) => Home()));
                          }
                        }
                      },
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

  void _updateStatus(PermissionStatus status) {
    if (status != _status) {
      setState(() {
        _status = status;
      });
    }
  }

  _askPermission() async {
    var status = await Permission.contacts.request();
  }
}
