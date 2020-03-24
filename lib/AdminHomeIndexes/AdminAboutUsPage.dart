import 'package:flutter/material.dart';
import 'package:call_number/call_number.dart';

class AdminAboutUsPage {
  static Widget aboutUsPage(BuildContext context) {
    return Center(
        child: Container(
            padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.deepPurpleAccent[200],
            ),
            child: SingleChildScrollView(
                child: Column(children: <Widget>[
              Image.asset(
                "assets/icon/logo.jpg",
                width: 280,
                height: 280,
                color: Colors.deepPurpleAccent[200],
                colorBlendMode: BlendMode.darken,
              ),
              Container(
                color: Colors.deepOrange,
                padding: EdgeInsets.all(5),
                margin: EdgeInsets.all(10),
                child: RichText(
                  overflow: TextOverflow.fade,
                  text: TextSpan(
                      text: "Employee Management System",
                      style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 20)))
              ),
              RichText(
                textAlign: TextAlign.justify,
                  overflow: TextOverflow.fade,
                  text: TextSpan(
                      text:
                          "An employee management system consists of crucial work-related and important personal information about an employee. In a nutshell, it is an online inventory of all employees of an organization. Employees are the strength of any organization, and it is more so in case of a growing business. It is crucial to handle this aspect of your business well. A good employee management system can actually make a world of difference to an organization, especially true in case of startups and small businesses, where the focus should be on growing the business more than anything else.",
                      style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 17.5))),
              new FlatButton(
                  color: Colors.deepOrange,
                  onPressed: () => CallNumber().callNumber('+917506604268'),
                  child: new Text("Contact Developers")),
            ]))));
  }
}
