import 'package:acft_app/GuidePages/spt_instructions.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PrepDrillInstructions extends StatefulWidget {
  @override
  State<PrepDrillInstructions> createState() => _PrepDrillInstructionsState();
  
}

class _PrepDrillInstructionsState extends State<PrepDrillInstructions> {
  late YoutubePlayerController _controller;
  
  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: 's6HlWmhyHy4',
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
        title: Text('Prep Drill Instructions'),
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
        """               """,


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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        SPTInstructions(), // Replace MdlPage with your actual MDL page
                  ),
                );
              },
              child: Text('Go to SPT Page'),
            ),
          ],
        ),
      ),
    );
  }
}