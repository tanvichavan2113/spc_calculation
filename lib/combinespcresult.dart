// ignore_for_file: use_key_in_widget_constructors, library_private_types_in_public_api

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter PostgreSQL Demo',
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List data = [];
  TextEditingController valueController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse('http://localhost:3001/data'));
    if (response.statusCode == 200) {
      setState(() {
        data = json.decode(response.body)['results'];
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> addData() async {
    final double inputValue = double.tryParse(valueController.text) ?? 0.0;
    final int timestamp = data.length + 1;

    if (inputValue != 0.0) {
      final response = await http.post(
        Uri.parse('http://localhost:3001/addData'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'value': inputValue, 'timestamp': timestamp}),
      );

      if (response.statusCode == 200) {
        Fluttertoast.showToast(
          msg: 'Data added successfully',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );

        valueController.clear();
        fetchData();
      } else {
        throw Exception('Failed to add data');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PostgreSQL Data'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: valueController,
              keyboardType: TextInputType.number,
              decoration:
                  const InputDecoration(labelText: 'Enter Numeric Value'),
            ),
          ),
          ElevatedButton(
            onPressed: addData,
            child: const Text('Add Data'),
          ),
        ],
      ),
    );
  }
}
