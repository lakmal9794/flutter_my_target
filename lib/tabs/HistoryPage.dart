import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final Stream<QuerySnapshot> _contributionStream =
      FirebaseFirestore.instance.collection("contributions").snapshots();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: StreamBuilder<QuerySnapshot>(
        stream: _contributionStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return new Text("Somthing went Wrong!");
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              return Dismissible(
                background: Container(
                  color: Colors.purple,
                  child: Row(
                    children: [
                      Text(
                        "  Delete ?",
                        style: TextStyle(color: Colors.white),
                        textScaleFactor: 1.3,
                      )
                    ],
                  ),
                ),
                onDismissed: (direction) {
                  FirebaseFirestore.instance
                      .collection("targets")
                      .doc(document["target_id"])
                      .update({
                    "contribution_total":
                        FieldValue.increment(-1 * document["amount"])
                  });
                  FirebaseFirestore.instance
                      .collection("contributions")
                      .doc(document.id)
                      .delete();
                },
                key: Key(document.id),
                child: ListTile(
                  title: Text(
                    document['note'],
                    textScaleFactor: 1.4,
                  ),
                  subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(document["amount"].toString()),
                      Text(document["date"].toDate().toString())
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
