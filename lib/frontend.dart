// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('SPC Calculations :'),
        ),
        body: MyForm(),
      ),
    );
  }
}

class MyForm extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  List<String> dropdownItems = ['Option 1', 'Option 2', 'Option 3'];
  List<String> labels = [
    'PART NAME:',
    'INSTRUMENT:',
    'L.COUNT:',
    'PART NO:',
    'SPECIFIC:',
    'MACHINE:',
    'SAMPLE SIZE:',
    'OPERATION:',
    'Quantity:',
    'SUPPLIER:',
    'DC.NO:'
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          for (int i = 0; i < 4; i++)
            Row(
              children: [
                for (int j = 0; j < 3; j++)
                  if (i * 3 + j < labels.length)
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text(labels[i * 3 + j]),
                            SizedBox(width: 8),
                            DropdownButton<String>(
                              value: dropdownItems[0],
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownItems[0] = newValue!;
                                });
                              },
                              items:
                                  dropdownItems.map<DropdownMenuItem<String>>(
                                (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                },
                              ).toList(),
                            ),
                          ],
                        ),
                      ),
                    ),
              ],
            ),
        ],
      ),
    );
  }
}
