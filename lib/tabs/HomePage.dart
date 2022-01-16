import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController txtAmount = TextEditingController();
  TextEditingController txtNote = TextEditingController();
  final Stream<QuerySnapshot> _targetStream =
      FirebaseFirestore.instance.collection('targets').snapshots();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: StreamBuilder<QuerySnapshot>(
        stream: _targetStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
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

          return ExpansionPanelList(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              return ExpansionPanel(
                  headerBuilder: (BuildContext context, bool isExpanded) {
                    return Container(
                      padding: EdgeInsets.all(20.0),
                      child: Text(
                        data['name'],
                        textScaleFactor: 1.5,
                      ),
                    );
                  },
                  body: Container(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Amount : " + data["amount"].toString(),
                                textScaleFactor: 1.1),
                            Text(
                                "Date : " +
                                    data["date"]
                                        .toDate()
                                        .toString()
                                        .split(" ")[0],
                                textScaleFactor: 1.1),
                          ],
                        ),
                        Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(data["contribution_total"].toString() +
                                "/" +
                                data["amount"].toString()),
                            IconButton(
                              icon: Icon(Icons.attach_money),
                              splashColor: Colors.purple,
                              highlightColor: Colors.lightBlueAccent,
                              color: Colors.purple,
                              onPressed: () {
                                String tid = document.id;
                                _showMyDialog(tid);
                              },
                            )
                          ],
                        ),
                        LinearProgressIndicator(
                          valueColor: new AlwaysStoppedAnimation<Color>(
                              Colors.blueAccent),
                          value: data["contribution_total"] / data["amount"],
                        )
                      ],
                    ),
                  ),
                  isExpanded: true);
            }).toList(),
          );
        },
      ),
    );
  }

  Future<void> _showMyDialog(tid) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ADD CONTRIBUTION'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Enter Amount'),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: txtAmount,
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text('Enter Note'),
                TextFormField(
                  controller: txtNote,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('ADD'),
              onPressed: () {
                String amount = txtAmount.text;
                String note = txtNote.text;

                FirebaseFirestore.instance.collection("contributions").add({
                  'amount': int.parse(amount),
                  'note': note,
                  'date': new DateTime.now(),
                  'target_id': tid,
                });

                FirebaseFirestore.instance
                    .collection('targets')
                    .doc(tid)
                    .update({
                  'contribution_total': FieldValue.increment(int.parse(amount))
                });
                txtAmount.clear();
                txtNote.clear();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('CANCEL'),
              onPressed: () {
                txtAmount.clear();
                txtNote.clear();
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }
}
