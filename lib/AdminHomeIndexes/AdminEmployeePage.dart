import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminEmployeePage {
  static QuerySnapshot querySnapshot;

  static Widget employeePage(BuildContext context) {
    return _showEmployees();
  }

  static Widget _showEmployees() {
    //check if querysnapshot is null
    if (querySnapshot != null) {
      return ListView.builder(
          primary: false,
          itemCount: querySnapshot.documents.length,
          scrollDirection: Axis.vertical,
          padding: EdgeInsets.all(2),
          itemBuilder: (context, i) {
            return Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                height: 220,
                child: Card(
                    elevation: 2,
                    color: Colors.deepPurpleAccent[200],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Row(
                      children: <Widget>[
                        imager("${querySnapshot.documents[i].data['PicLink']}"),
                        Expanded(
                          child: RichText(
                              overflow: TextOverflow.fade,
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                  text:
                                      "${querySnapshot.documents[i].data['Name']}",
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25))),
                        ),
                      ],
                    )));
          });
    } else {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  static Widget imager(picLink) {
    if (picLink ==
        "{default black logo link}") {
      return Container(
          decoration: BoxDecoration(
              border: Border.all(
            color: Colors.deepOrange[300],
            width: 5,
          )),
          margin: EdgeInsets.fromLTRB(10, 0, 20, 0),
          child: Card(
              color: Colors.deepPurpleAccent[200],
              elevation: 0,
              child: Image.network(
                picLink,
                color: Colors.deepPurpleAccent[200],
                colorBlendMode: BlendMode.darken,
                width: 150,
                height: 150,
              )));
    } else {
      return Container(
          decoration: BoxDecoration(
              border: Border.all(
            color: Colors.deepOrange[300],
            width: 5,
          )),
          // padding: EdgeInsets.all(5),
          margin: EdgeInsets.fromLTRB(10, 0, 20, 0),
          child: Card(
              color: Colors.deepOrange[300],
              elevation: 0,
              child: Image.network(
                picLink,
                fit: BoxFit.fitWidth,
                width: 150,
                height: 150,
              )));
    }
  }

  getDriversList() async {
    return await Firestore.instance
        .collection('User')
        .where("IsAdmin", isEqualTo: false)
        .getDocuments();
  }
}
