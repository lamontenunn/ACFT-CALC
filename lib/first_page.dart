import 'package:acft_app/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For input formatters
import 'package:acft_app/login.dart';
import 'package:acft_app/signup.dart';


class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255,255,255,255),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                    "Welcome to EMU ROTC",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Login or Create an account",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              Container(
                height: MediaQuery.of(context).size.height / 3,
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage("images/wings.png"),
                )),
              ),


              Column(
                children: <Widget>[
                  MaterialButton(
                    minWidth: double.infinity,
                    height: 60,
                    onPressed: () {
                      Navigator.push(
                        context,
                       MaterialPageRoute(builder: (context) => SettingsPage()),
                      );
                    },
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Text("Login",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        )),
                  ),




                      SizedBox(height:20),
                      MaterialButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SettingsPage()),
                          );
                        
                        },
                        color: Color.fromARGB(255, 33, 94, 35),
                        minWidth: double.infinity,
                        height: 60,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50),
                        side: BorderSide(color: Colors.black),
                        ),
                        child: Text(
                        "Create an Account",
                        style: TextStyle(
                          color: Color.fromARGB(255, 255, 255, 255),
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        )
                      ),
                      ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
