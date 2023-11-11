import 'package:cloud_firestore/cloud_firestore.dart';

class AcftCalculator {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<int> calculateTotalScore({
    required String? selectedGender,
    required String? selectedAge,
    required double deadliftScore,
    required double pushUpScore,
    required double SDCScore,
    required double SPTScore,
  }) async {
    // Ensure the document IDs are correctly formatted based on the selected gender and age group
    String docIdMDL = '$selectedGender\_$selectedAge\_MDL';
    String docIdHRP = '$selectedGender\_$selectedAge\_HRP';
    String docIdSDC = '$selectedGender\_$selectedAge\_SDC';
    String docIdSPT = '$selectedGender\_$selectedAge\_SPT';
    //grabs etch the documents from Firestore
    DocumentSnapshot docMDL =
        await _firestore.collection('ACFT_Scores').doc(docIdMDL).get();
    DocumentSnapshot docHRP =
        await _firestore.collection('ACFT_Scores').doc(docIdHRP).get();
    DocumentSnapshot docSDC =
        await _firestore.collection('ACFT_Scores').doc(docIdSDC).get();
    DocumentSnapshot docSPT =
        await _firestore.collection('ACFT_Scores').doc(docIdSPT).get();

    // convert the points  map ----> a Map<String, int>
    Map<String, int> pointsMDL = Map<String, int>.from(docMDL['Points']);
    Map<String, int> pointsHRP = Map<String, int>.from(docHRP['Points']);
    Map<String, int> pointsSDC = Map<String, int>.from(docSDC['Points']);
    Map<String, int> pointsSPT = Map<String, int>.from(docSPT['Points']);

    String secondsToFormattedTime(double seconds) {
      Duration duration = Duration(seconds: seconds.toInt());
      String twoDigits(int n) => n.toString().padLeft(2, "0");
      String twoDigitMinutes = twoDigits(duration.inMinutes);
      String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
      return "$twoDigitMinutes:$twoDigitSeconds:00";
    }
    // Function to find the nearest lower or equal score in the points map
int findNearestLowerScore(Map<String, int> pointsMap, String score) {
  print("Received score: $score");
  print("Available pointsMap: $pointsMap");

  // Check for an exact match first
  if (pointsMap.containsKey(score)) {
    print("Exact score found: $score  : $pointsMap[score]");
    return pointsMap[score]!;
  }

  // Find the nearest lower score if no exact match exists
  var sortedKeys = pointsMap.keys.toList()
    ..sort((a, b) => a.compareTo(b)); // Sort the keys in ascending order
  var filteredKeys = sortedKeys.where((e) => e.compareTo(score) <= 0);

  if (filteredKeys.isEmpty) {
    print("No matching score found");
    return 0; // Or handle this case differently
  }
  
  var maxAvailableScore = filteredKeys.reduce((a, b) => a.compareTo(b) > 0 ? a : b);
  print("Nearest lower score: $maxAvailableScore");
  return pointsMap[maxAvailableScore] ?? 0;
}


   // Convert SDC score to the 'minutes:seconds:00' format
  String formattedSDCScore = secondsToFormattedTime(SDCScore);
  print("The converted SDC score is: $formattedSDCScore");

String formatSPTScore(double score) {
  if (score == score.toInt().toDouble()) {
    return score.toInt().toString();
  }
  return score.toStringAsFixed(1);
}

  // Convert all double scores to String for querying the database
  String strDeadliftScore = deadliftScore.toString();
  String strPushUpScore = pushUpScore.toString();
  String strSPTScore = formatSPTScore(SPTScore);


  // Find the points for each event using the utility function
  int sdcPoints = findNearestLowerScore(pointsSDC, formattedSDCScore);
  int mdlPoints = findNearestLowerScore(pointsMDL, strDeadliftScore);
  int hrpPoints = findNearestLowerScore(pointsHRP, strPushUpScore);
  int sptPoints = findNearestLowerScore(pointsSPT, strSPTScore);
    // Calculate the total score
    int totalScore = mdlPoints + hrpPoints + sdcPoints + sptPoints;

    return totalScore;
  }
}