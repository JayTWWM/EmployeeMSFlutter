import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class AdminUpcomingEventsPage {
  static TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 17.5);

  static String event;

  static QuerySnapshot querySnapshot;

  static var subscription;
  static TextEditingController controller = new TextEditingController();

  static CalendarController CalController;
  static TableCalendar tableCalendar;
  static IconButton iconButton;
  static var eventField = TextField(
    onChanged: (text) {
      event = text;
    },
    controller: controller,
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
      labelText: 'Events',
      prefixIcon: Icon(Icons.calendar_today),
    ),
  );

  Map<String, dynamic> encodeMap(Map<String, dynamic> map) {
    Map<String, dynamic> newMap = {};
    map.forEach((key, value) {
      newMap[key.toString()] = map[key];
    });
    return newMap;
  }

  Map<DateTime, dynamic> decodeMap(Map<DateTime, dynamic> map) {
    Map<DateTime, dynamic> newMap = {};
    map.forEach((key, value) {
      newMap[DateTime.parse(key.toIso8601String())] = map[key];
    });
    return newMap;
  }

  static Widget upcomingEventsPage(BuildContext context) {
    return Center(
        child: Container(
            padding: EdgeInsets.fromLTRB(5, 20, 5, 0),
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.deepPurpleAccent[100],
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  tableCalendar,
                  Divider(
                    height: 0,
                  ),
                  Container(
                    width: double.infinity,
                    child: Row(
                      children: <Widget>[
                        Flexible(
                          child: eventField,
                        ),
                        Container(
                          padding: EdgeInsets.all(3),
                          child: CircleAvatar(
                              backgroundColor: Colors.deepOrange,
                              child: iconButton),
                        ),
                      ],
                    ),
                    padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                  ),
                  Container(
                      decoration: BoxDecoration(
                          color: Colors.deepOrange,
                          borderRadius: BorderRadius.circular(5)),
                      padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                      child: Center(
                          child: Column(
                        children: <Widget>[
                          Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                color: Colors.deepPurple,
                                width: 5,
                              )),
                              child: Center(
                                  child: RichText(
                                      text: TextSpan(
                                          text: "Events",
                                          style: TextStyle(
                                              color: Colors.black87,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 40))))),
                          getEvent()
                        ],
                      )))
                ],
              ),
            )));
  }

  static Widget getEvent() {
    try {
      if (querySnapshot.documents[0].data['Event'] != null) {
        return Container(
            width: double.infinity,
            padding: EdgeInsets.all(5),
            child: RichText(
                text: TextSpan(
                    text: "${querySnapshot.documents[0].data['Event']}",
                    style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 25))));
      } else {
        return Container(
            width: double.infinity,
            padding: EdgeInsets.all(5),
            child: Center(
                child: RichText(
                    text: TextSpan(
                        text: "No Event",
                        style: TextStyle(
                            color: Colors.black87,
                            fontWeight: FontWeight.bold,
                            fontSize: 25)))));
      }
    } catch (E) {
      return Container(
          width: double.infinity,
          padding: EdgeInsets.all(5),
          child: Center(
              child: RichText(
                  text: TextSpan(
                      text: "No Event",
                      style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 25)))));
    }
  }

  getEventsList(DateTime curr) async {
    return await Firestore.instance
        .collection(curr.year.toString())
        .document(curr.month.toString())
        .collection(curr.day.toString())
        .getDocuments();
  }
}
