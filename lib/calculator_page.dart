import 'package:acft_app/GuidePages/ScoreEntry.dart';
import 'package:flutter/material.dart';


class CalculatorPage extends StatefulWidget {
  @override
  _CalculatorPageState createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  String _selectedGender = "Male";
  String _selectedAge = "17 - 21";
  int? _totalScore = 0;
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

    String? deadliftScore =
        deadliftScores.isNotEmpty ? deadliftScores.first : null;
    String? powerThrowScore = sptScores.isNotEmpty ? sptScores.first : null;
    String? pushUpScore = pushUpScores.isNotEmpty ? pushUpScores.first : null;
    String? sdcScore = sdcScores.isNotEmpty ? sdcScores.first : null;
    String? plankScore = plankScores.isNotEmpty ? plankScores.first : null;
    String? runScore = runScores.isNotEmpty ? runScores.first : null;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            // Gender Dropdown
            _buildDropdown(
              label: 'Gender',
              value: _selectedGender,
              items: ['Male', 'Female'],
              icon: Icons.person,
              onChanged: (String? value) {
                setState(() {
                  _selectedGender = value!;
                  updateDropdowns(_selectedAge, _selectedGender);
                });
              },
            ),

            _buildDropdown(
              label: 'Select Age Group',
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
              ],
              icon: Icons.cake, // Change icon to something more relevant
              onChanged: (String? value) {
                setState(() {
                  _selectedAge = value!;
                  updateDropdowns(_selectedAge, _selectedGender);
                });
              },
            ),

            SizedBox(height: 30),


            SizedBox(height: 20),

            _buildEventScoresGrid(),

            SizedBox(height: 30),

            _buildCalculateButton(theme),

            if (_totalScore != null)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    'Total Score: $_totalScore',
                    style: theme.textTheme.titleLarge!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(
      {required String label,
      String? value,
      required List<String> items,
      required IconData icon,
      required ValueChanged<String?> onChanged}) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items.map((item) {
        return DropdownMenuItem(value: item, child: Text(item));
      }).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        icon: Icon(icon),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Center(
      child: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
      ),
    );
  }

  Widget _buildEventScoresGrid() {
    return GridView.builder(
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
    );
  }

  Widget _buildCalculateButton(ThemeData theme) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            calculateTotalScore();
          });
        },
        child: const Text('Calculate'),
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.primaryColor,
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
          textStyle: theme.textTheme.labelLarge,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }

  Widget _buildEventDropdown(
      String label, List<String?> options, String? selectedValue) {
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
              deadliftScore = newValue!;
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
    });
  }

  Future<void> calculateTotalScore() async{
    int baseIndex = scoreEntry.ageGroupToColumnIndex[_selectedAge]!;
    if (_selectedGender == 'Female') {
      baseIndex++; // Increment index for female
    }

    int deadliftScoreValue = scoreEntry.findEventScore(
        scoreEntry.deadliftArr, deadliftScore, baseIndex);
    int plankScoreValue =
        scoreEntry.findEventScore(scoreEntry.plankArr, plankScore, baseIndex);
    int pushUpScoreValue =
        scoreEntry.findEventScore(scoreEntry.pushUpArr, pushUpScore, baseIndex);
    int runScoreValue =
        scoreEntry.findEventScore(scoreEntry.runArr, runScore, baseIndex);
    int sdcScoreValue =
        scoreEntry.findEventScore(scoreEntry.sdcArr, sdcScore, baseIndex);
    int throwScoreValue = scoreEntry.findEventScore(
        scoreEntry.throwArr, powerThrowScore, baseIndex);

    _totalScore = deadliftScoreValue +
        plankScoreValue +
        pushUpScoreValue +
        runScoreValue +
        sdcScoreValue +
        throwScoreValue;
  }
}

typedef ValueTransformer<T, V> = V Function(T value);
