import 'package:acft_app/calculator_page.dart';
import 'package:acft_app/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';



Future<void> main() async {
  runApp(const AcftApp());
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
); 

}

class AcftApp extends StatelessWidget {
  const AcftApp({super.key});
  

  @override
  Widget build(BuildContext context) {


    return MaterialApp(
      title: "ACFT APP",
      home: const HomePage(title: "ACFT HomePage!"),
    );


  } 
  


}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPage = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amber,
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: currentPage,
          onDestinationSelected: (int index) {
            setState(() {
              currentPage = index;
            });
          },
          height: 60,
          animationDuration: const Duration(milliseconds: 1000),
          backgroundColor: Colors.amber,
          destinations: const <Widget>[
            NavigationDestination(
              icon: Icon(Icons.home_rounded),
              label: "Home",
            ),
            NavigationDestination(
              icon: Icon(Icons.calculate_rounded),
              label: 'Calculator',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_rounded),
              label: "Settings",
            ),
          ],
        ),
        body: <Widget>[
          Container(
            color: Colors.blue,
            alignment: Alignment.center,
            child: const Text("Page 1")
          ),
          CalculatorPage(),
          SettingsPage(),
        ][currentPage]);
  }
}
