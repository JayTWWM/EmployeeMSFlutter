import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'AdminHome.dart';
// import 'User.dart';
// import 'package:google_sign_in/google_sign_in.dart';

class MySignUpPage extends StatefulWidget {
  @override
  _MySignUpPageState createState() => _MySignUpPageState();
}

class _MySignUpPageState extends State<MySignUpPage> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 17.5);

  String name;
  String designation;
  String contact;
  String email;
  String password;
  String picLink =
      "{Default black logo image link}";
  bool isAdmin = false;

  AuthResult result;

  Widget build(BuildContext context) {
    final Firestore _db = Firestore.instance;
    final FirebaseAuth _auth = FirebaseAuth.instance;
    //final GoogleSignIn googleSignIn = GoogleSignIn();

    final nameField = Container(
      margin: EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: TextField(
        onChanged: (text) {
          name = text;
        },
        textCapitalization: TextCapitalization.characters,
        obscureText: false,
        style: style,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(width: 10),
          ),
          fillColor: Colors.deepOrange,
          labelText: 'Name',
          prefixIcon: Icon(Icons.account_circle),
        ),
      ),
    );

    final designationField = Container(
      margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: TextField(
        onChanged: (text) {
          designation = text;
        },
        textCapitalization: TextCapitalization.characters,
        obscureText: false,
        style: style,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(width: 10),
          ),
          fillColor: Colors.deepOrange,
          labelText: 'Designation',
          prefixIcon: Icon(Icons.description),
        ),
      ),
    );

    final contactField = Container(
      margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: TextField(
        onChanged: (text) {
          contact = text;
        },
        obscureText: false,
        style: style,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(width: 10),
          ),
          fillColor: Colors.deepOrange,
          labelText: 'Contact Number',
          prefixIcon: Icon(Icons.phone),
        ),
      ),
    );

    final emailField = Container(
        margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: TextField(
          onChanged: (text) {
            email = text;
          },
          obscureText: false,
          style: style,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(width: 10),
            ),
            fillColor: Colors.deepOrange,
            labelText: 'Email',
            prefixIcon: Icon(Icons.email),
          ),
        ));
    final passwordField = Container(
      margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: TextField(
        onChanged: (text) {
          password = text;
        },
        obscureText: true,
        style: style,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(width: 10),
          ),
          fillColor: Colors.deepOrange,
          labelText: 'Password',
          prefixIcon: Icon(Icons.lock),
        ),
      ),
    );

    final checkIfAdmin = Container(
      margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.deepOrange,
      ),
      alignment: Alignment.center,
        child: CheckboxListTile(
          title: Text("Admin"),
      onChanged: (bool value) {
        setState(() {
          isAdmin = value;
        });
      },
      value: isAdmin,
      activeColor: Colors.deepOrange,
      
    ));

    return Scaffold(
        appBar: AppBar(
          title: Text("Sign Up Page"),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.fromLTRB(5, 50, 5, 0),
            child: Column(children: <Widget>[
              Image.asset(
                  "assets/icon/logo.jpg",
                  width: 360,
                  height: 360),
              nameField,
              designationField,
              contactField,
              emailField,
              passwordField,
              checkIfAdmin,
              new RaisedButton(
                shape: StadiumBorder(),
                color: Colors.deepOrangeAccent,
                child: Text("Sign Up"),
                onPressed: () async {
                  if (isAdmin) {
                    // User user = new User(name, designation, contact, email,
                    //     password, picLink, isAdmin);
                    _db.collection("User").document(email).setData({
                      "Name": name,
                      "Designation": designation,
                      "Contact": contact,
                      "Email": email,
                      "Password": password,
                      "PicLink": picLink,
                      "IsAdmin": isAdmin
                    });
                    result = await _auth.createUserWithEmailAndPassword(
                        email: email, password: password);
                    if (result.user != null) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyAdminHomePage()));
                    }
                  } else {
                    // User user = new User(name, designation, contact, email,
                    //     password, picLink, isAdmin);
                    _db.collection("User").document(email).setData({
                      "Name": name,
                      "Designation": designation,
                      "Contact": contact,
                      "Email": email,
                      "Password": password,
                      "PicLink": picLink,
                      "IsAdmin": isAdmin
                    });
                    result = await _auth.createUserWithEmailAndPassword(
                        email: email, password: password);
                    if (result.user != null) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyAdminHomePage()));
                    }
                  }
                },
              ),
              /*new RaisedButton(
                child: Text("Google"),
                onPressed: () {
                  if (isAdmin) {
                    _db.collection("Admin").document(email).setData({
                      "Name": name,
                      "Designation": designation,
                      "Contact": contact,
                      "Email Identifier": email,
                      "Password": password
                    }).whenComplete(() {
                      googleSignIn.signIn().whenComplete(() {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyAdminHomePage()));
                      });
                    });
                  } else {
                    googleSignIn.signIn().whenComplete(() {
                      _db.collection("Employee").document(email).setData({
                      "Name": name,
                      "Designation": designation,
                      "Contact": contact,
                      "Email Identifier": email,
                      "Password": password
                    }).whenComplete(() {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyEmployeeHomePage()));
                      });
                    });
                  }
                },
              )*/
            ]),
          ),
        ));
  }
}
