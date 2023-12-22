import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;

class AcftCalculator {
  Future<int> calculateTotalScore({
    required String selectedGender,
    required String selectedAge,
    required double deadliftScore,
    required double SPTScore,
    required double pushUpScore,
    required double plankScore,
    required double SDCScore,
    required double twoMileScore,
  }) async {
    int total = 0;

    total += await getScoreFromTextFile('deadlift.txt', selectedAge, selectedGender, deadliftScore);
    total += await getScoreFromTextFile('throw.txt', selectedAge, selectedGender, SPTScore);
    total += await getScoreFromTextFile('pushup.txt', selectedAge, selectedGender, pushUpScore);
    total += await getScoreFromTextFile('plank.txt', selectedAge, selectedGender, plankScore);
    total += await getScoreFromTextFile('sdc.txt', selectedAge, selectedGender, SDCScore);
    total += await getScoreFromTextFile('run.txt', selectedAge, selectedGender, twoMileScore);
    
    // Repeat for other events
    // ...

    return total;
  }

  Future<int> getScoreFromTextFile(String fileName, String age, String gender, double eventScore) async {
    String data = await rootBundle.loadString('assets/textfiles/$fileName');
    List<String> lines = data.split('\n');

    // Parse the file similar to your JavaScript logic
    List<int> ageColumns = getAgeColumns(age, lines[0]);
    int genderColumn = getGenderColumn(gender, lines[1], ageColumns);
    int score = parseScore(lines, genderColumn, eventScore);

    return score;
  }

List<int> getAgeColumns(String age, String firstLine) {
  List<String> ages = firstLine.split(' ');
  List<int> ageRange = age.split('-').map(int.parse).toList();
  List<int> columns = [];

  for (int i = 0; i < ages.length; i++) {
    if (ages[i].toLowerCase() != 'points') {
      List<int> itemRange = ages[i].split('-').map(int.parse).toList();
      if (itemRange[0] <= ageRange[1] && itemRange[1] >= ageRange[0]) {
        columns.add(i);
      }
    }
  }

  return columns;
}


int getGenderColumn(String gender, String secondLine, List<int> ageColumns) {
  List<String> genders = secondLine.split(' ');

  try {
    return ageColumns.firstWhere((column) => genders[column] == gender, orElse: () => -1);
  } catch (e) {
    // Handle the exception or return a default value
    return -1; // -1 indicates that no matching column was found
  }
}


int parseScore(List<String> lines, int genderColumn, double eventScore) {
  int lastKnownScore = 0; // Initialize to the lowest score or a sensible default

  for (int i = 1; i < lines.length; i++) {
    List<String> row = lines[i].split(' ');

    String scoreStr = row[0];
    String performanceStr = row[genderColumn];

    if (performanceStr != '---') {
      double performance = double.tryParse(performanceStr) ?? 0;

      if (eventScore >= performance) {
        // If the score for this row is not empty, use it
        int currentScore = int.tryParse(scoreStr) ?? lastKnownScore;
        return currentScore;
      }
    } else {
      // Update the last known score even if the current row's score is empty
      lastKnownScore = int.tryParse(scoreStr) ?? lastKnownScore;
    }
  }

  // If no matching performance is found, return the last known score or a default value
  return lastKnownScore;
}

}
