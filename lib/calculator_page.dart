import 'package:acft_app/acft_calculator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For input formatters

class CalculatorPage extends StatefulWidget {
  @override
  _CalculatorPageState createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  // Dropdown controllers for age, gender, etc.
  String? _selectedGender;
  String? _selectedAge;
  double _deadliftScore = 80.00;
  double _powerThrowScore = 4.0;
  double _pushUpScore = 4.0;
  double _plankScore = 60.0; // In seconds, e.g., 1:00
  double _sprintDragCarryScore = 87.0; // or another value between 87 and 208
  double _twoMileRunScore = 802.0;
  int? _totalScore;

  // or another value between 802 and 1440
  AcftCalculator acftCalculator = AcftCalculator();

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
                  _selectedGender = value;
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
                  _selectedAge = value;
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
                        'Deadlift', _deadliftScore, 80, 340);
                  case 1:
                    return _buildEventDropdown(
                        'SPT', _powerThrowScore, 4.0, 12.6);
                  case 2:
                    return _buildEventDropdown(
                        'HRP', _pushUpScore, 4, 57);
                  case 3:
                    return _buildEventDropdown(
                        'SDC', _sprintDragCarryScore, 87, 208);
                  case 4:
                    return _buildEventDropdown('Plank', _plankScore, 60,
                        220); // Adjust min/max values as needed
                  case 5:
                    return _buildEventDropdown('2 Mile Run', _twoMileRunScore,
                        802, 1440); // Adjust min/max values as needed
                  default:
                    return Container();
                }
              },
            ),

            SizedBox(height: 20), // Spacing
            // Calculate Button
            ElevatedButton(
              onPressed: () async {
                int totalScore = await acftCalculator.calculateTotalScore(
                  selectedGender: _selectedGender,
                  selectedAge: _selectedAge?.replaceAll(' ', ''),
                  deadliftScore: _deadliftScore,
                  pushUpScore: _pushUpScore,
                  SDCScore: _sprintDragCarryScore,
                  SPTScore: _powerThrowScore,
                );
                setState(() {
                  _totalScore = totalScore;
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

  // Helper method to build event input field
  Widget _buildEventField(
      String label, TextEditingController controller, dynamic icon) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(
        labelText: label,
        hintText: 'Enter result',
        icon: icon is IconData
            ? Icon(icon)
            : Image.asset(icon,
                width: 24, height: 24), // Using custom PNG icons
      ),
    );
  }

  Widget _buildEventSlider(String label, double value, double min, double max,
      ValueChanged<double> onChanged,
      {ValueTransformer<double, String>? formatValue, bool isDecimal = false}) {
    // Added isDecimal parameter
    double sliderValue = isDecimal ? value * 10 : value;
    double sliderMin = isDecimal ? min * 10 : min;
    double sliderMax = isDecimal ? max * 10 : max;

    // Explicitly set the divisions
    int? sliderDivisions = (sliderMax - sliderMin).toInt();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        Slider(
          value: sliderValue,
          min: sliderMin,
          max: sliderMax,
          divisions: sliderDivisions, // set divisions here
          label: isDecimal
              ? ((sliderValue).round() / 10.0).toStringAsFixed(1)
              : sliderValue.round().toString(),
          onChanged: (double newValue) {
            setState(() {
              onChanged(isDecimal ? newValue / 10 : newValue);
            });
          },
          activeColor: Colors.green[800], // Army green color
        ),
        Text(formatValue != null
            ? formatValue(value)
            : 'Score: ${value.round()}'),
        SizedBox(height: 10), // Spacing between sliders
      ],
    );
  }

  Widget _buildEventDropdown(String label, double value, double min, double max,
      {int step = 1}) {
    // Create a list of dropdown menu items
    List<DropdownMenuItem<double>> items = [];
    for (double i = min; i <= max; i += step) {
      items.add(DropdownMenuItem(
        value: i,
        child: Text(i.toString()),
      ));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
        DropdownButtonFormField<double>(
          value: value,
          items: items,
          onChanged: (newValue) {
            setState(() {
              // Update the corresponding state variable
              switch (label) {
                case 'Deadlift':
                  _deadliftScore = newValue ?? min;
                  break;
                case 'Standing Power Throw':
                  _powerThrowScore = newValue ?? min;
                  break;
                case 'Hand Release Push-Up':
                  _pushUpScore = newValue ?? min;
                  break;
                case 'Sprint Drag Carry':
                  _sprintDragCarryScore = newValue ?? min;
                  break;
                case 'Plank':
                  _plankScore = newValue ?? min;
                  break;
                case '2 Mile Run':
                  _twoMileRunScore = newValue ?? min;
                  break;
                default:
                  break;
              }
            });
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 10), // Spacing between dropdowns
      ],
    );
  }
}

typedef ValueTransformer<T, V> = V Function(T value);
