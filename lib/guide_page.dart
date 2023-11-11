import 'package:flutter/material.dart';

// Each event or information should have a corresponding route in your Flutter application.
// Make sure to define these routes in your MaterialApp widget.

class GuidePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Define the icons and the routes they link to
    final List<IconData> icons = [
      Icons.library_books, // Test Instructions
      Icons.map, // Lane Layout
      Icons.fitness_center, // Prep Drill
      Icons.account_balance_wallet, // MDL
      Icons.directions_run, // SPT
      Icons.touch_app, // HRP
      Icons.timer, // SDC
      Icons.airline_seat_legroom_reduced, // PLK
      Icons.directions_walk, // 2MR
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
          crossAxisCount: 2, // You can adjust the number of icons per row depending on the screen size
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: icons.length,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () {
            // Handle navigation
            Navigator.pushNamed(context, '/${labels[index]}');
          },
          child: Card( // Wrap in a Card for a neater look
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(icons[index], size: 50), //Icon sizes 
                SizedBox(height: 8), // Spaces between icon and text
                Text(labels[index], textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
