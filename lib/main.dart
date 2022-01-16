import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mytarget/pages/targets/create.dart';
import 'package:mytarget/tabs/ChartPage.dart';
import 'package:mytarget/tabs/HistoryPage.dart';
import 'package:mytarget/tabs/HomePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MyTarget',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int index = 0;
  List<Widget> tabs = [];
  late Widget page;
  bool pageAssigned = false;

  @override
  Widget build(BuildContext context) {
    tabs.add(HomePage());
    tabs.add(ChartPage());
    tabs.add(HistoryPage());
    return Scaffold(
      appBar: AppBar(
        title: Text("Pay your Bill Easyly"),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          setState(() {
            page = CreateTarget();
            pageAssigned = true;
          });
        },
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Text("Your Name Here"),
              decoration: BoxDecoration(color: Colors.purple),
            ),
            ListTile(
              title: Text("Billing History"),
              onTap: () {},
            ),
            ListTile(
              title: Text("My Profile"),
              onTap: () {},
            ),
            ListTile(
              title: Text("Log Out"),
              onTap: () {},
            )
          ],
        ),
      ),
      body: pageAssigned ? page : tabs[index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (i) {
          setState(() {
            index = i;
            pageAssigned = false;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart),
            label: "Charts",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: "History",
          )
        ],
      ),
    );
  }
}
