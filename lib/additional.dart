import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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

    if (inputValue != 0.0) {
      final response = await http.post(
        Uri.parse('http://localhost:3001/addData'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'value': inputValue}),
      );

      if (response.statusCode == 200) {
        print('Data added successfully');
        fetchData();
      } else {
        throw Exception('Failed to add data');
      }
    }
  }

  Future<void> calculateMetrics() async {
    final response =
        await http.get(Uri.parse('http://localhost:3001/calculateMetrics'));
    if (response.statusCode == 200) {
      print('Metrics calculated successfully');
      fetchData();
    } else {
      throw Exception('Failed to calculate metrics');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PostgreSQL Data'),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: addData,
                child: const Text('Add Data'),
              ),
              ElevatedButton(
                onPressed: calculateMetrics,
                child: const Text('Calculate Metrics'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Metric: ${data[index]['metric']}'),
                  subtitle: Text('Value: ${data[index]['value']}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
