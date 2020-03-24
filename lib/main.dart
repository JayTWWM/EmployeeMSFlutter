import 'Login.dart';
import 'SignUp.dart';
import 'AdminHome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Employee Management System',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        accentColor: Colors.deepPurpleAccent,
      ),
      home: MyIntroPage(),
    );
  }
}

class MyIntroPage extends StatefulWidget {
  @override
  _MyIntroPageState createState() => _MyIntroPageState();
}

class _MyIntroPageState extends State<MyIntroPage>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    getDriversList().then((results) {
      setState(() {
        querySnapshot = results;
        getCurrentUser();
      });
    });
  }

  static String email;
  static bool isAdmin;

  QuerySnapshot querySnapshot;

  double _height = 80.0;
  double _width = 80.0;
  var adder = Center(child: Text(""));

  Future<void> getCurrentUser() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    setState(() {
      _height = 360.0;
      _width = 360.0;
      if (user == null) {
        adder = Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                child: new RaisedButton(
                    shape: StadiumBorder(),
                    color: Colors.deepOrangeAccent,
                    child: Text("Login"),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyLoginPage()));
                    }),
                padding: EdgeInsets.all(10),
              ),
              Container(
                child: new RaisedButton(
                  shape: StadiumBorder(),
                  color: Colors.deepOrangeAccent,
                  child: Text("Sign Up"),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MySignUpPage()));
                  },
                ),
                padding: EdgeInsets.all(10),
              )
            ],
          ),
        );
      } else {
        email = user.email;
        for (final element in querySnapshot.documents) {
          if (element.data["Email"] == email) {
            isAdmin = element.data["IsAdmin"];
          }
        }
      }
    });
  }

  void done() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => MyAdminHomePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Check In Page"),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new AnimatedSize(
              curve: Curves.easeInOutCubic,
              child: new GestureDetector(
                onTap: () {
                  done();
                },
                child: Image.asset(
                  "assets/icon/logo.jpg",
                  width: _width,
                  height: _height,
                ),
              ),
              vsync: this,
              duration: new Duration(seconds: 4),
            ),
            adder
          ],
        ),
      ),
    );
  }

  getDriversList() async {
    return await Firestore.instance.collection('User').getDocuments();
  }
}
