import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';
import 'package:table_calendar/table_calendar.dart';
import 'AdminHomeIndexes/AdminHomePage.dart';
import 'AdminHomeIndexes/AdminAboutUsPage.dart';
import 'AdminHomeIndexes/AdminAnnouncementPage.dart';
import 'AdminHomeIndexes/AdminEmployeePage.dart';
import 'AdminHomeIndexes/AdminUpcomingEventsPage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class MyAdminHomePage extends StatefulWidget {
  MyAdminHomePage();

  @override
  _MyAdminHomePageState createState() => _MyAdminHomePageState();
}

class _MyAdminHomePageState extends State<MyAdminHomePage> {
  @override
  void initState() {
    super.initState();
    AdminUpcomingEventsPage.CalController = CalendarController();
    AdminUpcomingEventsPage.tableCalendar = new TableCalendar(
      initialCalendarFormat: CalendarFormat.week,
      calendarStyle: CalendarStyle(
          todayColor: Colors.deepOrange,
          selectedColor: Colors.deepPurpleAccent,
          todayStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
              color: Colors.black)),
      startingDayOfWeek: StartingDayOfWeek.monday,
      onDaySelected: (date, events) {
        setState(() {
          AdminUpcomingEventsPage().getEventsList(date).then((results) {
            setState(() {
              AdminUpcomingEventsPage.querySnapshot = results;
              try {
                AdminUpcomingEventsPage.subscription = _db
                    .collection(date.year.toString())
                    .document(date.month.toString())
                    .collection(date.day.toString())
                    .document("Events")
                    .snapshots()
                    .listen((DocumentSnapshot snapshot) =>
                        onDatabaseUpdate1(snapshot));
              } catch (E) {}
            });
          });
        });
      },
      calendarController: AdminUpcomingEventsPage.CalController,
    );
    AdminUpcomingEventsPage.iconButton = IconButton(
        icon: Icon(Icons.add),
        onPressed: () {
          _showAddDialog();
        });
    currentPage = homepage;
    currentButton = floatButton;
    setState(() {
      getCurrentUser();
    });
    AdminHomePage().getDriversList().then((results) {
      setState(() {
        AdminHomePage.querySnapshot = results;
        getUser();
      });
    });
    AdminHomePage.CalController = CalendarController();
    AdminHomePage.tableCalendar = new TableCalendar(
      initialCalendarFormat: CalendarFormat.week,
      calendarStyle: CalendarStyle(
          todayColor: Colors.deepOrangeAccent,
          selectedColor: Colors.deepPurpleAccent,
          todayStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
              color: Colors.black)),
      startingDayOfWeek: StartingDayOfWeek.monday,
      onDaySelected: (date, events) {
        try {
          AdminHomePage().getAttendsList(date).then((results) {
            setState(() {
              AdminHomePage.querySnapshot1 = results;
              if (AdminHomePage.querySnapshot1.documents.isNotEmpty) {
                AdminHomePage.attended =
                    (AdminHomePage.querySnapshot1.documents[0].data[email.replaceAll('.', ' ')] ==
                            null)
                        ? false
                        : AdminHomePage.querySnapshot1.documents[0].data[email.replaceAll('.', ' ')];
              } else {
                AdminHomePage.attended = false;
              }
            });
          });
        } catch (E) {}
      },
      calendarController: AdminHomePage.CalController,
    );
    AdminHomePage().getAttendsList(DateTime.now()).then((results) {
      setState(() {
        AdminHomePage.querySnapshot1 = results;
        if (AdminHomePage.querySnapshot1.documents.isNotEmpty) {
          AdminHomePage.attended =
              (AdminHomePage.querySnapshot1.documents[0].data[email.replaceAll('.', ' ')] == null)
                  ? false
                  : AdminHomePage.querySnapshot1.documents[0].data[email.replaceAll('.', ' ')];
        } else {
          AdminHomePage.attended = false;
        }
      });
    });
    AdminHomePage.iconButton = IconButton(
        icon: Icon(Icons.check_circle),
        color: Colors.black,
        onPressed: () async {
          final Distance distance = new Distance();
          Position position = await Geolocator()
              .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
          double _distance = distance.as(
              LengthUnit.Meter,
              new LatLng(position.latitude, position.longitude),
              new LatLng(AdminHomePage.lat_admin, AdminHomePage.long_admin));
          setState(() {
            AdminHomePage.lat = position.latitude.toString();
            AdminHomePage.long = position.longitude.toString();
            print(AdminHomePage.lat + ' ' + AdminHomePage.long);
            if (_distance < 25) {
              _db
                  .collection(DateTime.now().year.toString())
                  .document(DateTime.now().month.toString())
                  .collection(DateTime.now().day.toString())
                  .document("Events")
                  .updateData({email.replaceAll('.', ' ') : true});
              AdminHomePage().getAttendsList(DateTime.now()).then((results) {
                setState(() {
                  AdminHomePage.querySnapshot1 = results;
                  if (AdminHomePage.querySnapshot1.documents.isNotEmpty) {
                    AdminHomePage.attended = (AdminHomePage
                                .querySnapshot1.documents[0].data[email.replaceAll('.', ' ')] ==
                            null)
                        ? false
                        : AdminHomePage.querySnapshot1.documents[0].data[email.replaceAll('.', ' ')];
                  } else {
                    AdminHomePage.attended = false;
                  }
                });
              });
            } else {
              Fluttertoast.showToast(
                            msg: 'You are not in the office!',
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIos: 3,
                            backgroundColor: Colors.red[100],
                            textColor: Colors.white,
                            fontSize: 16.0);
            }
          });
        });
    //Attendance Content
    AdminEmployeePage().getDriversList().then((results) {
      setState(() {
        AdminEmployeePage.querySnapshot = results;
      });
    });
    AdminAnnouncementPage().getMessagesList().then((results) {
      setState(() {
        AdminAnnouncementPage.querySnapshot = results;
        AdminAnnouncementPage.subscription = _db
            .collection("Message")
            .document("Test")
            .snapshots()
            .listen((DocumentSnapshot snapshot) => onDatabaseUpdate(snapshot));
      });
    });
    AdminUpcomingEventsPage().getEventsList(DateTime.now()).then((results) {
      setState(() {
        AdminUpcomingEventsPage.querySnapshot = results;
        try {
          AdminUpcomingEventsPage.subscription = _db
              .collection(AdminUpcomingEventsPage.CalController.selectedDay.year
                  .toString())
              .document(AdminUpcomingEventsPage.CalController.selectedDay.month
                  .toString())
              .collection(AdminUpcomingEventsPage.CalController.selectedDay.day
                  .toString())
              .document("Events")
              .snapshots()
              .listen(
                  (DocumentSnapshot snapshot) => onDatabaseUpdate1(snapshot));
        } catch (E) {}
      });
    });
  }

  void onDatabaseUpdate(DocumentSnapshot snapshot) {
    setState(() {
      AdminAnnouncementPage().getMessagesList().then((results) {
        setState(() {
          AdminAnnouncementPage.querySnapshot = results;
          AdminAnnouncementPage.controller.clear();
        });
      });
    });
  }

  void onDatabaseUpdate1(DocumentSnapshot snapshot) {
    setState(() {
      AdminUpcomingEventsPage()
          .getEventsList(AdminUpcomingEventsPage.CalController.selectedDay)
          .then((results) {
        setState(() {
          AdminUpcomingEventsPage.querySnapshot = results;
          AdminUpcomingEventsPage.controller.clear();
        });
      });
    });
  }

  static var homepage = AdminHomePage.homePage;

  static var employeepage = AdminEmployeePage.employeePage;

  static var announcementpage = AdminAnnouncementPage.announcementPage;

  static var upcomingEventspage = AdminUpcomingEventsPage.upcomingEventsPage;

  static var aboutUspage = AdminAboutUsPage.aboutUsPage;

  var currentPage;

  static String email;

  static var dowurl;

  FloatingActionButton floatButton = FloatingActionButton(
    backgroundColor: Colors.deepPurpleAccent[200],
    child: Icon(Icons.edit),
    onPressed: () async {
      await uploadPic();
      AdminHomePage.picUrl = dowurl;
    },
  );

  FloatingActionButton currentButton;

  String pageId = "Home Page";

  static FirebaseStorage _storage = FirebaseStorage.instance;
  static Firestore _db = Firestore.instance;
  static FirebaseAuth _auth = FirebaseAuth.instance;

  _showAddDialog() {
    DateTime curr = AdminUpcomingEventsPage.CalController.selectedDay;

    try {
      _db
          .collection(curr.year.toString())
          .document(curr.month.toString())
          .collection(curr.day.toString())
          .document("Events")
          .updateData({
        "Event":
            (AdminUpcomingEventsPage.querySnapshot.documents[0].data["Event"] +
                '\n' +
                AdminUpcomingEventsPage.event)
      });
    } catch (E) {
      _db
          .collection(curr.year.toString())
          .document(curr.month.toString())
          .collection(curr.day.toString())
          .document("Events")
          .setData({"Event": AdminUpcomingEventsPage.event});
    }
    setState(() {
      AdminUpcomingEventsPage().getEventsList(curr).then((results) {
        setState(() {
          AdminUpcomingEventsPage.querySnapshot = results;
          AdminUpcomingEventsPage.subscription = _db
              .collection(AdminUpcomingEventsPage.CalController.selectedDay.year
                  .toString())
              .document(AdminUpcomingEventsPage.CalController.selectedDay.month
                  .toString())
              .collection(AdminUpcomingEventsPage.CalController.selectedDay.day
                  .toString())
              .document("Events")
              .snapshots()
              .listen(
                  (DocumentSnapshot snapshot) => onDatabaseUpdate1(snapshot));
        });
      });
    });
  }

  Future<void> getCurrentUser() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    setState(() {
      email = user.email;
    });
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('You want to exit an App'),
            actions: <Widget>[
              new FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              new FlatButton(
                onPressed: () => exit(0),
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }

  static uploadPic() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    StorageReference reference = _storage.ref().child("images/$email");
    StorageUploadTask uploadTask = reference.putFile(image);
    dowurl = await (await uploadTask.onComplete).ref.getDownloadURL();
    _db
        .collection("User")
        .document(email)
        .updateData({"PicLink": dowurl.toString()});
  }

  Widget build(BuildContext context) {
    return new WillPopScope(
        child: Scaffold(
            drawer: Drawer(
              child: ListView(padding: EdgeInsets.zero, children: <Widget>[
                DrawerHeader(
                  child: Center(
                      child: Column(children: <Widget>[
                    Image.asset(
                      "assets/icon/logo.jpg",
                      color: Colors.deepPurpleAccent[200],
                      colorBlendMode: BlendMode.darken,
                      width: 100,
                      height: 100,
                    ),
                    Container(
                      color: Colors.deepOrangeAccent,
                      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      padding: EdgeInsets.all(5),
                      child: Text('Employee Management System'),
                    )
                  ])),
                  decoration: BoxDecoration(
                    color: Colors.deepPurpleAccent[200],
                  ),
                ),
                ListTile(
                  title: Container(
                      decoration: BoxDecoration(
                          border:
                              Border(bottom: BorderSide(color: Colors.grey))),
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: <Widget>[Icon(Icons.home), Text('Home')],
                      )),
                  onTap: () {
                    setState(() {
                      currentPage = homepage;
                      pageId = "Home Page";
                      currentButton = floatButton;
                      AdminHomePage().getDriversList().then((results) {
                        setState(() {
                          AdminHomePage.querySnapshot = results;
                          getUser();
                        });
                      });
                      Navigator.pop(context);
                    });
                  },
                ),
                ListTile(
                  title: Container(
                      decoration: BoxDecoration(
                          border:
                              Border(bottom: BorderSide(color: Colors.grey))),
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: <Widget>[
                          Icon(Icons.people),
                          Text('Employees')
                        ],
                      )),
                  onTap: () {
                    setState(() {
                      currentPage = employeepage;
                      pageId = "Employees List Page";
                      currentButton = null;
                      AdminEmployeePage().getDriversList().then((results) {
                        setState(() {
                          AdminEmployeePage.querySnapshot = results;
                        });
                      });
                      Navigator.pop(context);
                    });
                  },
                ),
                ListTile(
                  title: Container(
                      decoration: BoxDecoration(
                          border:
                              Border(bottom: BorderSide(color: Colors.grey))),
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: <Widget>[
                          Icon(Icons.announcement),
                          Text('Announcements')
                        ],
                      )),
                  onTap: () {
                    setState(() {
                      currentPage = announcementpage;
                      pageId = "Announcements Page";
                      currentButton = null;
                      AdminAnnouncementPage().getMessagesList().then((results) {
                        setState(() {
                          AdminAnnouncementPage.querySnapshot = results;
                        });
                      });
                      Navigator.pop(context);
                    });
                  },
                ),
                ListTile(
                  title: Container(
                      decoration: BoxDecoration(
                          border:
                              Border(bottom: BorderSide(color: Colors.grey))),
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: <Widget>[
                          Icon(Icons.calendar_today),
                          Text('Upcoming Events')
                        ],
                      )),
                  onTap: () {
                    setState(() {
                      currentPage = upcomingEventspage;
                      pageId = "Upcoming Events Page";
                      currentButton = null;
                      Navigator.pop(context);
                    });
                  },
                ),
                ListTile(
                  title: Container(
                      decoration: BoxDecoration(
                          border:
                              Border(bottom: BorderSide(color: Colors.grey))),
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: <Widget>[Icon(Icons.info), Text('About Us')],
                      )),
                  onTap: () {
                    setState(() {
                      currentPage = aboutUspage;
                      pageId = "About Us Page";
                      currentButton = null;
                      Navigator.pop(context);
                    });
                  },
                )
              ]),
            ),
            appBar: AppBar(title: Text("$pageId"), actions: <Widget>[
              IconButton(
                  alignment: Alignment.centerRight,
                  icon: Icon(Icons.exit_to_app),
                  onPressed: () {
                    _auth.signOut();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MyIntroPage()));
                  })
            ]),
            body: currentPage(context),
            floatingActionButton: currentButton),
        onWillPop: _onWillPop);
  }

  getUser() {
    for (final element in AdminHomePage.querySnapshot.documents) {
      if (element.data["Email"] == email) {
        AdminHomePage.name = element.data["Name"];
        AdminHomePage.designation = element.data["Designation"];
        AdminHomePage.picUrl = element.data["PicLink"];
      }
    }
  }

  updateMsg() {
    setState(() {
      _db.collection("Message").document("Test").updateData({
        "Message":
            (AdminAnnouncementPage.querySnapshot.documents[0].data["Message"] +
                '\n' +
                AdminAnnouncementPage.msg)
      });
    });
  }
}
