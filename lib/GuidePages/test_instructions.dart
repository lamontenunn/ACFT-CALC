import 'package:acft_app/GuidePages/mdl_instructions.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class TestInstructionsPage extends StatefulWidget {
  @override
  _TestInstructionsPageState createState() => _TestInstructionsPageState();
}

class _TestInstructionsPageState extends State<TestInstructionsPage> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: 'X9RlS8LZgVc',
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Instructions'),
        backgroundColor: Colors.amber,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        onReady: () {
            _controller.addListener(() {});
        },
    ),
            const Text(
              "YOU ARE ABOUT TO TAKE THE ARMY COMBAT FITNESS TEST OR ACFT, A TEST THAT MEASURES YOUR TOTAL BODY FITNESS. THE TEST RESULTS WILL GIVE YOU AND YOUR COMMANDERS AN INDICATION OF YOUR LEVEL OF PHYSICAL FITNESS AND WILL SERVE AS A GUIDE IN DETERMINING YOUR PHYSICAL TRAINING NEEDS.\n\nYOU WILL REST AND RECOVER AT EACH STATION WHILE OTHER SOLDIERS IN YOUR GROUP COMPLETE THEIR TURNS. DO THE BEST YOU CAN ON EACH TEST EVENTS.\n\nYOU ARE REQUIRED TO READ AND UNDERSTAND THE FOLLOWING INSTRUCTIONS. THESE INSTRUCTIONS WILL BE AVAILABLE FOR ANY SOLDIER TO READ AT THE TEST SITE. YOU ARE ENCOURAGED TO ASK QUESTIONS OF YOUR CHAIN OF COMMAND. THESE INSTRUCTIONS WILL NOT BE READ AT THE TEST SITE.\n\nPRIOR TO THE START OF THE TEST, YOU WILL PARTICIPATE IN A 10-MINUTE PREPARATION DRILL LEAD BY THE NCOIC. FOLLOWING THE PREPARATION DRILL, YOU WILL BE ALLOWED 10 MINUTES TO WARM-UP FOR THE 3 REPETITION MAXIMUM DEADLIFT. YOU ARE ENCOURAGED TO START AT A LOW WEIGHT AND ‘LADDER UP’ TO A WEIGHT THAT IS ABOUT HALF OF YOUR MAXIMUM DEADLIFT WEIGHT.",
              style: TextStyle(
                fontSize: 15,
                letterSpacing: 0.5,
                height: 1.5,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 16.0), // Add some spacing below the text
            ElevatedButton(
              onPressed: () {
                // Navigate to the MDL page
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        MDLInstructions(), // Replace MdlPage with your actual MDL page
                  ),
                );
              },
              child: Text('Go to MDL Page'),
            ),
          ],
        ),
      ),
    );
  }
}
