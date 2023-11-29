import 'package:acft_app/acft_calculator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For input formatters
import 'package:http/http.dart' as http;

class CalculatorPage extends StatefulWidget {
  @override
  _CalculatorPageState createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  AcftCalculator acftCalculator = AcftCalculator();
  String _selectedGender = "Male";
  String _selectedAge = "17 - 21"; 
  double? _totalScore = 0;
  List<double> _deadliftOptions = [];
  List<double> _sptOptions = [];
  List<double> _pushUpOptions = [];
  List<double> _sprintDragCarryOptions = [];
  List<double> _plankOptions = [];
  List<double> _twoMileRunOptions = [];
  double _deadliftScore = 0;
  double _powerThrowScore = 0;
  double _pushUpScore = 0;
  double _sdcScore = 0;
  double _plankScore = 0;
  double _twoMileRunScore = 0;

  void initState() {
  super.initState();
  updateDropdowns(_selectedAge, _selectedGender);
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
            const Text(
              'Event Scores',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),

            SizedBox(height: 10), // Add some spacing

            GridView.builder(
              shrinkWrap: true, // Prevents infinite height issue
              physics:
                  const NeverScrollableScrollPhysics(), // Disables scrolling within the GridView
              itemCount: 6, // Total number of dropdowns
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // Two columns
                crossAxisSpacing: 5, // Horizontal spacing
                mainAxisSpacing: 1, // Vertical spacing
              ),
              itemBuilder: (context, index) {
                switch (index) {
                  case 0:
                    return _buildEventDropdown(
                        'Deadlift', _deadliftScore, _deadliftOptions);
                  case 1:
                    return _buildEventDropdown(
                        'spt', _powerThrowScore, _sptOptions);
                  case 2: // Push-up
                    return _buildEventDropdown(
                        'pushup', _pushUpScore, _pushUpOptions);
                  case 3: // Sprint-Drag-Carry
                    return _buildEventDropdown(
                        'sdc', _sdcScore, _sprintDragCarryOptions);
                  case 4: // Plank
                    return _buildEventDropdown(
                        'plank', _plankScore, _plankOptions);
                  case 5: // 2-mile run
                    return _buildEventDropdown(
                        'run', _twoMileRunScore, _twoMileRunOptions);

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
                  _totalScore = _deadliftScore +
                      _powerThrowScore +
                      _pushUpScore +
                      _sdcScore +
                      _plankScore +
                      _twoMileRunScore;
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

  Widget _buildEventDropdown(
      String label, double currentValue, List<double> options) {
    // Create a list of dropdown menu items using the provided options
    return DropdownButton<double>(
      value: currentValue,
      onChanged: (double? newValue) {
        setState(() {
          // Update the corresponding event score state based on the label
          switch (label) {
            case 'deadlift':
              _deadliftScore = newValue ?? 0.0;
              break;
            case 'spt':
              _powerThrowScore = newValue ?? 0.0;
              break;
            case 'Push-up':
              _pushUpScore = newValue ?? 0.0;
              break;
            case 'sdc':
              _sdcScore = newValue ?? 0.0;
              break;
            case 'plank':
              _plankScore = newValue ?? 0.0;
              break;
            case 'run':
              _twoMileRunScore = newValue ?? 0.0;
              break;
          }
        });
      },
      items: options.map<DropdownMenuItem<double>>((double value) {
        return DropdownMenuItem<double>(
          value: value,
          child: Text(
              value.toStringAsFixed(2)), // You can format the string as needed
        );
      }).toList(),
    );
  }


Future<String> fetchData(String fileName) async {
  try {
    final data = await rootBundle.loadString('assets/textfiles/$fileName');
    return data;
  } catch (e) {
    throw Exception('Error loading file: $e');
  }
}


List<double> parseData(String rawData, String age, String gender) {
  final lines = rawData.split('\n');
  final ageColumns = getAgeColumns(age, lines[0]);
  final genderColumn = getGenderColumn(gender, lines[1], ageColumns);

  if (genderColumn == -1 || genderColumn >= lines[1].split(' ').length) {
    // Handle invalid gender column (e.g., return an empty list or show an error)
    return [];
  }

  return lines
      .sublist(2) // Skip the first two lines
      .map((line) {
        var splitLine = line.split(' ');
        if (splitLine.length > genderColumn) {
          var value = splitLine[genderColumn];
          return value != '---' ? double.tryParse(value) ?? 0.0 : 0.0;
        }
        return 0.0;
      })
      .toList();
}



List<int> getAgeColumns(String age, String firstLine) {
  final ages = firstLine.split(' ');
  final ageRange = age.split('-').map((a) => int.tryParse(a.trim()) ?? 0).toList();
  List<int> columns = [];

  for (int i = 0; i < ages.length; i++) {
    var agePart = ages[i].split('-').map((a) => int.tryParse(a.trim()) ?? 0).toList();
    
    if (agePart.length == 2 && agePart[0] <= ageRange[1] && agePart[1] >= ageRange[0]) {
      columns.add(i);
    }
  }

  return columns;
}


int getGenderColumn(String gender, String secondLine, List<int> ageColumns) {
  final genders = secondLine.split(' ');
  
  // Debugging: Print the genders list and the gender being searched
  print("Genders list: $genders");
  print("Searching for gender: $gender");

  return ageColumns.firstWhere(
    (column) => genders[column] == gender,
    orElse: () => -1, // Provide a default value or handle this situation accordingly
  );
}
String mapUserInputToGender(String userInput) {
  return userInput == "Male" ? 'M' : 'F';
}

  void updateDropdowns(String age, String gender) async {
    String fileGender = mapUserInputToGender(gender);
    var deadliftData =
        await fetchAndUpdateEventOptions(age, fileGender, 'deadlift.txt');
    var sptData = await fetchAndUpdateEventOptions(age, fileGender, 'throw.txt');
    var pushUpData =
        await fetchAndUpdateEventOptions(age, fileGender, 'pushup.txt');
    var sdcData = await fetchAndUpdateEventOptions(age, fileGender, 'sdc.txt');
    var plankData = await fetchAndUpdateEventOptions(age, fileGender, 'plank.txt');
    var runData = await fetchAndUpdateEventOptions(age, fileGender, 'run.txt');

    setState(() {
      _deadliftOptions = deadliftData;
      _sptOptions = sptData;
      _pushUpOptions = pushUpData;
      _sprintDragCarryOptions = sdcData;
      _plankOptions = plankData;
      _twoMileRunOptions = runData;

      // Optionally set the default scores to the minimum value from each event
      _deadliftScore =
          _deadliftOptions.isNotEmpty ? _deadliftOptions.first : 0.0;
      _powerThrowScore = _sptOptions.isNotEmpty ? _sptOptions.first : 0.0;
      _pushUpScore = _pushUpOptions.isNotEmpty ? _pushUpOptions.first : 0.0;
      _sdcScore = _sprintDragCarryOptions.isNotEmpty
          ? _sprintDragCarryOptions.first
          : 0.0;
      _plankScore = _plankOptions.isNotEmpty ? _plankOptions.first : 0.0;
      _twoMileRunScore =
          _twoMileRunOptions.isNotEmpty ? _twoMileRunOptions.first : 0.0;
    });
  }

  Future<List<double>> fetchAndUpdateEventOptions(
      String age, String gender, String fileName) async {
    final rawData = await fetchData(fileName);
    return parseData(rawData, age, gender);
  }
}

typedef ValueTransformer<T, V> = V Function(T value);
