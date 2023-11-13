import 'package:flutter/material.dart';

// Each event or information should have a corresponding route in your Flutter application.
// Make sure to define these routes in your MaterialApp widget.

class GuidePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Define the icons and the routes they link to
    final List<String> imagePaths = [
      'assets/icons/test_instructions.png', // Path for Test Instructions
      'assets/icons/lane_layout.png',       // Path for Lane Layout
      'assets/icons/prep_drill.png',        // Path for Prep Drill
      'assets/icons/deadlift.jpg',          // Path for MDL
      'assets/icons/powerthrow.jpg',        // Path for SPT
      'assets/icons/pushup.jpg',            // Path for HRP
      'assets/icons/dragcarry.jpg',         // Path for SDC
      'assets/icons/plank.jpg',             // Path for PLK
      'assets/icons/run.jpg',               // Path for 2MR
    ];

    final List<String> labels = [
      "Test Instructions",
      "Lane Layout",
      "Prep Drill",
      "MDL",
      "SPT",
      "HRP",
      "SDC",
      "PLK",
      "2MR",
    ];

   return Scaffold(
      body: GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: imagePaths.length,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () {
            // Handle navigation
            Navigator.pushNamed(context, '/${labels[index]}');
          },
          child: Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(imagePaths[index], width: 75, height: 75),
                SizedBox(height: 8),
                Text(labels[index], textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
      ),
    );
  }
}