import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class AdminAnnouncementPage {
  static TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  static String msg;

  static QuerySnapshot querySnapshot;
  
  static TextEditingController controller = new TextEditingController();
  
  static Firestore _db = Firestore.instance;

  static var subscription;

  static Widget announcementPage(BuildContext context) {


    final msgField = TextFormField(
      onChanged: (text) {
        msg = text;
      },
      controller: controller,
      obscureText: false,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.all(10),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide(width: 10),
          ),
          fillColor: Colors.deepOrange,
          hintText: "Type Message"),
    );

    return Container(
      child: Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
              reverse: true,
              primary: false,
              itemCount: querySnapshot.documents != null
                  ? querySnapshot.documents.length
                  : 0,
              padding: EdgeInsets.all(2),
              itemBuilder: (context, i) {
                return Column(children: <Widget>[
                  Container(
                      decoration: BoxDecoration(
                          color: Colors.deepPurpleAccent[200],
                          borderRadius: BorderRadius.circular(5)),
                      padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                      child: Center(
                          child: Row(
                        children: <Widget>[
                          RichText(
                              text: TextSpan(
                                  text:
                                      "${querySnapshot.documents[i].data['Message']}",
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25))),
                        ],
                      )))
                ]);
              },
            ),
          ),
          Divider(
            height: 0,
          ),
          Container(
            child: Row(
              children: <Widget>[
                Flexible(
                  child: msgField,
                ),
                Container(
                  child: IconButton(
                    color: Colors.deepOrange,
                    icon: Icon(Icons.send),
                    onPressed: () {
                      if (querySnapshot.documents.isNotEmpty || querySnapshot.documents[0].data["Message"]!=null) {
                        _db.collection("Message").document("Test").updateData({
                          "Message": (AdminAnnouncementPage
                                  .querySnapshot.documents[0].data["Message"] +
                              '\n' +
                              AdminAnnouncementPage.msg)
                        });
                      } else {
                        _db
                            .collection("Message")
                            .document("Test")
                            .setData({"Message": (AdminAnnouncementPage.msg)});
                      }
                    },
                  ),
                  margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                )
              ],
            ),
            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
          )
        ],
      ),
    );
  }

  getMessagesList() async {
    return await Firestore.instance.collection('Message').getDocuments();
  }
}
