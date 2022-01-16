import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CreateTarget extends StatefulWidget {
  const CreateTarget({Key? key}) : super(key: key);

  @override
  _CreateTargetState createState() => _CreateTargetState();
}

class _CreateTargetState extends State<CreateTarget> {
  TextEditingController txtName = new TextEditingController();
  TextEditingController txtAmount = new TextEditingController();

  DateTime? date;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Card(
          child: Container(
            padding: EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Add New Target",
                  textScaleFactor: 1.5,
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text("Target Name"),
                TextFormField(
                  controller: txtName,
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text("Target Amount"),
                TextFormField(
                  controller: txtAmount,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text("Target Date"),
                ElevatedButton(
                    onPressed: () async {
                      date = await showDatePicker(
                          context: context,
                          initialDate: date ?? DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2500));
                    },
                    child: Text("Select date")),
                ButtonBar(
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          txtName.clear();
                          txtAmount.clear();
                          date = null;
                        },
                        child: Text("Clear")),
                    ElevatedButton(
                        onPressed: () {
                          String name = txtName.text;
                          String amount = txtAmount.text;

                          FirebaseFirestore.instance.collection("targets").add({
                            "name": name,
                            "amount": int.parse(amount),
                            "date": date,
                            "complete": 0,
                            "contribution_total": 0,
                          });
                          txtName.clear();
                          txtAmount.clear();
                          date = null;
                        },
                        child: Text("Save"))
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
