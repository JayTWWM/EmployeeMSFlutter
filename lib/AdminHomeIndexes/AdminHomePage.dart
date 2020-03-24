import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class AdminHomePage {
  static String lat = "";
  static String long = "";
  static double long_admin = {Office Lattitude};
  static double lat_admin = {Office Longitude};
  
  static IconButton iconButton;

  static QuerySnapshot querySnapshot;
  static QuerySnapshot querySnapshot1;
  static String name = "";
  static String designation = "";
  static String picUrl = "";
  static bool attended = false;
  static CalendarController CalController;
  static TableCalendar tableCalendar;

  static Widget homePage(BuildContext context) {
    return Container(
      color: Colors.deepOrange,
      child: Column(children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: Colors.deepPurpleAccent[200],
            borderRadius: BorderRadius.all(Radius.circular(0)),
          ),
          padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Center(
            child: Row(children: <Widget>[
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      fit: BoxFit.cover, image: NetworkImage("$picUrl")),
                ),
              ),
              Expanded(child: _showDetails())
            ]),
          ),
        ),
        Container(
          child: SingleChildScrollView(
              child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(10),
                width: double.infinity,
                decoration: BoxDecoration(
                    border: Border.all(
                  color: Colors.deepPurple,
                  width: 5,
                )),
                child: Center(
                    child: RichText(
                        text: TextSpan(
                            text: "Attendance",
                            style: TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.bold,
                                fontSize: 40)))),
              ),
              Container(
                  padding: EdgeInsets.all(5),
                  color: Colors.deepPurpleAccent[100],
                  child: Column(
                    children: <Widget>[
                      tableCalendar,
                      Row(
                        children: <Widget>[
                          displayAttendance(),
                          Container(
                            margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
                            padding: EdgeInsets.all(3),
                            child: CircleAvatar(
                                backgroundColor: Colors.deepOrange,
                                child: iconButton),
                          )
                        ],
                      )
                    ],
                  )),
            ],
          )),
        )
      ]),
    );
  }

  

  static Widget displayAttendance() {
    try {
      if (attended) {
        return Container(
          color: Colors.green,
          margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
          padding: EdgeInsets.all(5),
          child: Text(
            'Attended',
            style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 25),
          ),
        );
      } else {
        return Container(
          color: Colors.red,
          margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
          padding: EdgeInsets.all(5),
          child: Text(
            'Not Attended',
            style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 25),
          ),
        );
      }
    } catch (E) {
      print(E);
      return Container(
        color: Colors.red,
        margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
        padding: EdgeInsets.all(5),
        child: Text(
          'Not Attended',
          style: TextStyle(
              color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 25),
        ),
      );
    }
  }

  static Widget _showDetails() {
    if (querySnapshot != null) {
      return Center(
          child: Container(
              padding: EdgeInsets.fromLTRB(20, 25, 10, 10),
              child: Column(children: <Widget>[
                RichText(
                    overflow: TextOverflow.fade,
                    maxLines: 3,
                    text: TextSpan(
                        text: "$name",
                        style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontSize: 45))),
                RichText(
                    overflow: TextOverflow.fade,
                    maxLines: 2,
                    text: TextSpan(
                        text: "$designation",
                        style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontSize: 20))),
              ])));
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  getAttendsList(DateTime curr) async {
    return await Firestore.instance
        .collection(curr.year.toString())
        .document(curr.month.toString())
        .collection(curr.day.toString())
        .getDocuments();
  }

  getDriversList() async {
    return await Firestore.instance.collection('User').getDocuments();
  }
}
