import 'package:acft_app/GuidePages/ScoreEntry.dart';
import 'package:acft_app/acft_calculator.dart';
import 'package:flutter/material.dart';

class CalculatorPage extends StatefulWidget {
  @override
  _CalculatorPageState createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  AcftCalculator acftCalculator = AcftCalculator();
  String _selectedGender = "Male";
  String _selectedAge = "17 - 21";
  double? _totalScore = 0;
  List<String?> deadliftScores = [];
  List<String?> sptScores = [];
  List<String?> pushUpScores = [];
  List<String?> sdcScores = [];
  List<String?> plankScores = [];
  List<String?> runScores = [];
  String? deadliftScore;
  String? powerThrowScore;
  String? pushUpScore;
  String? sdcScore;
  String? plankScore;
  String? runScore;

  ScoreEntry scoreEntry = ScoreEntry();

  @override
  void initState() {
    super.initState();
    scoreEntry.convertAllData();
    updateDropdowns(_selectedAge, _selectedGender);
  
    
    
    String? deadliftScore = deadliftScores.isNotEmpty ? deadliftScores.first : null;
    String? powerThrowScore = sptScores.isNotEmpty ? sptScores.first : null;
    String? pushUpScore = pushUpScores.isNotEmpty ? pushUpScores.first : null;
    String? sdcScore = sdcScores.isNotEmpty ? sdcScores.first : null;
    String? plankScore = plankScores.isNotEmpty ? plankScores.first : null;
    String? runScore = runScores.isNotEmpty ? runScores.first : null;
    

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            // Gender Dropdown
            DropdownButtonFormField<String>(
              value: _selectedGender,
              items: ['Male', 'Female'].map((gender) {
                return DropdownMenuItem(value: gender, child: Text(gender));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedGender = value!;
                  updateDropdowns(_selectedAge, _selectedGender);
                });
              },
              decoration: InputDecoration(
                labelText: 'Gender',
                icon: Icon(Icons.person),
              ),
            ),

            DropdownButtonFormField<String>(
              value: _selectedAge,
              items: [
                '17 - 21',
                '22 - 26',
                '27 - 31',
                '32 - 36',
                '37 - 41',
                '42 - 46',
                '47 - 51',
                '52 - 56',
                '57 - 61',
                'Over 62'
              ].map((ageGroup) {
                return DropdownMenuItem(value: ageGroup, child: Text(ageGroup));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedAge = value!;
                  updateDropdowns(_selectedAge, _selectedGender);
                });
              },

              decoration: InputDecoration(
                labelText: 'Select Age Group',
                labelStyle: TextStyle(fontWeight: FontWeight.bold),
                hintText: 'Choose your age group',
                icon: Image.asset('assets/icons/age.png',
                    width: 24,
                    height: 24,
                    color: Colors.green[800]), // Army green color for the icon
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              ),
              dropdownColor: Colors.white,
              iconEnabledColor:
                  Colors.green[800], // Army green color for the dropdown icon
            ),

            SizedBox(height: 20), // Spacing

            // Add this new section header for Event Scores
            Center(
              child: const Text(
                'Enter Scores',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),

            SizedBox(height: 20), // Add some spacing

            GridView.builder(
              shrinkWrap: true, // Prevents infinite height issue
              physics:
                  const NeverScrollableScrollPhysics(), // Disables scrolling within the GridView
              itemCount: 6, // Total number of dropdowns
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // Two columns
                crossAxisSpacing: 5, // Horizontal spacing
                mainAxisSpacing: 5, // Vertical spacing
              ),
              itemBuilder: (context, index) {
                switch (index) {
                  case 0:
                    return _buildEventDropdown(
                      'deadlift', deadliftScores, deadliftScore);
                  case 1:
                    return _buildEventDropdown('spt', sptScores, powerThrowScore);
                  case 2: // Push-up
                    return _buildEventDropdown('pushup', pushUpScores, pushUpScore);
                  case 3: // Sprint-Drag-Carry
                    return _buildEventDropdown('sdc', sdcScores, sdcScore);
                  case 4: // Plank
                    return _buildEventDropdown('plank', plankScores, plankScore);
                  case 5: // 2-mile run
                    return _buildEventDropdown('run', runScores, runScore);
                  default:
                    return Container();
                }
              },
            ),

            SizedBox(height: 20), // Spacing
            // Calculate Button
            ElevatedButton(
              onPressed: () {
                setState(() {
                  // Assuming each score variable holds the score for the respective event
                  _totalScore = 0;
                });
              },
              child: Text('Calculate'),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[800]), // Army green color
            ),
            if (_totalScore != null)
              Text(
                'Total Score: $_totalScore',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventDropdown(String label, List<String?> options, String? selectedValue) {
        // Filter out null values or convert them to a default string (e.g., '')
    List<String> nonNullOptions = options
        .where((option) => option != null)
        .map((option) => option ?? '')
        .toList();

     return DropdownButton<String>(
    value: selectedValue, // Use the state variable here
    onChanged: (newValue) {
      setState(() {
        switch (label) {
          case 'deadlift':
            deadliftScore = newValue! ;
            break;
          case 'spt':
            powerThrowScore = newValue!;
            break;
          case 'pushup':
            pushUpScore = newValue!;
            break;
          case 'sdc':
            sdcScore = newValue!;
            break;
          case 'plank':
            plankScore = newValue!;
            break;
          case 'run':
            runScore = newValue!;
            break;
          
        }
      });
      },
      items: nonNullOptions.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  void updateDropdowns(String age, String gender) {
    int baseIndex = scoreEntry.ageGroupToColumnIndex[age]!;
    if (gender == 'Female') {
      baseIndex++; // Increment index for female
    }
    //print(
    // "Sample Deadlift Data: ${scoreEntry.deadliftArr.map((row) => row[baseIndex]).toList()}");
    setState(() {
      deadliftScores = scoreEntry.deadliftArr
          .map((row) => row[baseIndex])
          .where((value) => value != null)
          .toList();
      sptScores = scoreEntry.throwArr
          .map((row) => row[baseIndex])
          .where((value) => value != null)
          .toList();
      pushUpScores = scoreEntry.pushUpArr
          .map((row) => row[baseIndex])
          .where((value) => value != null)
          .toList();
      sdcScores = scoreEntry.sdcArr
          .map((row) => row[baseIndex])
          .where((value) => value != null)
          .toList();
      plankScores = scoreEntry.plankArr
          .map((row) => row[baseIndex])
          .where((value) => value != null)
          .toList();
      runScores = scoreEntry.runArr
          .map((row) => row[baseIndex])
          .where((value) => value != null)
          .toList();

     deadliftScore = deadliftScores.isNotEmpty ? deadliftScores.first : null;
     powerThrowScore = sptScores.isNotEmpty ? sptScores.first : null;
     pushUpScore = pushUpScores.isNotEmpty ? pushUpScores.first : null;
     sdcScore = sdcScores.isNotEmpty ? sdcScores.first : null;
     plankScore = plankScores.isNotEmpty ? plankScores.first : null;
     runScore = runScores.isNotEmpty ? runScores.first : null;
    }
    
    
    );

    
  }
  
}

typedef ValueTransformer<T, V> = V Function(T value);
