// // import 'package:flutter/material.dart';
// // import 'dart:convert';
// // import 'package:http/http.dart' as http;

// // void main() {
// //   runApp(MyApp());
// // }

// // class MyApp extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       title: 'Flutter PostgreSQL Demo',
// //       home: HomeScreen(),
// //     );
// //   }
// // }

// // class HomeScreen extends StatefulWidget {
// //   @override
// //   _HomeScreenState createState() => _HomeScreenState();
// // }

// // class _HomeScreenState extends State<HomeScreen> {
// //   List data = [];

// //   TextEditingController valueController = TextEditingController();

// //   @override
// //   void initState() {
// //     super.initState();
// //     fetchData();
// //   }

// //   Future<void> fetchData() async {
// //     final response = await http.get(Uri.parse('http://localhost:3001/data'));
// //     if (response.statusCode == 200) {
// //       setState(() {
// //         data = json.decode(response.body)['results'];
// //       });
// //     } else {
// //       throw Exception('Failed to load data');
// //     }
// //   }

// //   Future<void> addData() async {
// //     final double inputValue = double.tryParse(valueController.text) ?? 0.0;
// //     final int timestamp =
// //         data.length + 1; // Incremental timestamp starting from 1

// //     if (inputValue != 0.0) {
// //       final response = await http.post(
// //         Uri.parse('http://localhost:3001/addData'),
// //         headers: {'Content-Type': 'application/json'},
// //         body: jsonEncode({'value': inputValue, 'timestamp': timestamp}),
// //       );

// //       if (response.statusCode == 200) {
// //         print('Data added successfully');
// //         await fetchData(); // Wait for fetchData to complete before proceeding
// //         print('Data fetched successfully');
// //       } else {
// //         throw Exception('Failed to add data');
// //       }
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('PostgreSQL Data'),
// //       ),
// //       body: Column(
// //         mainAxisAlignment: MainAxisAlignment.center,
// //         crossAxisAlignment: CrossAxisAlignment.center,
// //         children: [
// //           Padding(
// //             padding: const EdgeInsets.all(8.0),
// //             child: TextField(
// //               controller: valueController,
// //               keyboardType: TextInputType.number,
// //               decoration:
// //                   const InputDecoration(labelText: 'Enter Numeric Value'),
// //             ),
// //           ),
// //           ElevatedButton(
// //             onPressed: addData,
// //             child: const Text('Add Data'),
// //           ),
// //           const SizedBox(height: 20),
// //           Expanded(
// //             child: ListView.builder(
// //               itemCount: data.length,
// //               itemBuilder: (context, index) {
// //                 return ListTile(
// //                   title: Text('Value: ${data[index]['value']}'),
// //                   subtitle: Text(
// //                       'Timestamp: ${data[index]['timestamp']} | MR: ${data[index]['mr']}'),
// //                 );
// //               },
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
// // ///successfully done with fetching also but below code just add the data and dont show on screen

// // // import 'package:flutter/material.dart';
// // // import 'dart:convert';
// // // import 'package:http/http.dart' as http;

// // // void main() {
// // //   runApp(MyApp());
// // // }

// // // class MyApp extends StatelessWidget {
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return MaterialApp(
// // //       title: 'Flutter PostgreSQL Demo',
// // //       home: HomeScreen(),
// // //     );
// // //   }
// // // }

// // // class HomeScreen extends StatefulWidget {
// // //   @override
// // //   _HomeScreenState createState() => _HomeScreenState();
// // // }

// // // class _HomeScreenState extends State<HomeScreen> {
// // //   List data = [];

// // //   TextEditingController valueController = TextEditingController();

// // //   @override
// // //   void initState() {
// // //     super.initState();
// // //     addData();
// // //   }

// // //   Future<void> addData() async {
// // //     final double inputValue = double.tryParse(valueController.text) ?? 0.0;
// // //     final int timestamp =
// // //         data.length + 1; // Incremental timestamp starting from 1

// // //     if (inputValue != 0.0) {
// // //       final response = await http.post(
// // //         Uri.parse('http://localhost:3001/addData'),
// // //         headers: {'Content-Type': 'application/json'},
// // //         body: jsonEncode({'value': inputValue, 'timestamp': timestamp}),
// // //       );

// // //       if (response.statusCode == 200) {
// // //         print('Data added successfully');
// // //         // Clear the text field
// // //         valueController.clear();
// // //       } else {
// // //         throw Exception('Failed to add data');
// // //       }
// // //     }
// // //   }

// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(
// // //         title: const Text('PostgreSQL Data'),
// // //       ),
// // //       body: Column(
// // //         mainAxisAlignment: MainAxisAlignment.center,
// // //         crossAxisAlignment: CrossAxisAlignment.center,
// // //         children: [
// // //           Padding(
// // //             padding: const EdgeInsets.all(8.0),
// // //             child: TextField(
// // //               controller: valueController,
// // //               keyboardType: TextInputType.number,
// // //               decoration:
// // //                   const InputDecoration(labelText: 'Enter Numeric Value'),
// // //             ),
// // //           ),
// // //           ElevatedButton(
// // //             onPressed: addData,
// // //             child: const Text('Add Data'),
// // //           ),
// // //           const SizedBox(height: 20),
// // //           Expanded(
// // //             child: ListView.builder(
// // //               itemCount: data.length,
// // //               itemBuilder: (context, index) {
// // //                 return ListTile(
// // //                   title: Text('Value: ${data[index]['value']}'),
// // //                   subtitle: Text(
// // //                       'Timestamp: ${data[index]['timestamp']} | MR: ${data[index]['mr']}'),
// // //                 );
// // //               },
// // //             ),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // // }

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart'; // Import Fluttertoast

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter PostgreSQL Demo',
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
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
    final int timestamp =
        data.length + 1; // Incremental timestamp starting from 1

    if (inputValue != 0.0) {
      final response = await http.post(
        Uri.parse('http://localhost:3001/addData'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'value': inputValue, 'timestamp': timestamp}),
      );

      if (response.statusCode == 200) {
        // Show a popup message
        Fluttertoast.showToast(
          msg: 'Data added successfully',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );

        // Clear the text field
        valueController.clear();

        // Fetch data (if needed)
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



// import 'package:example/spcresultpage.dart';
// import 'package:flutter/material.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:fluttertoast/fluttertoast.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter PostgreSQL Demo',
//       home: const HomeScreen(),
//     );
//   }
// }

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   List data = [];
//   TextEditingController valueController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     fetchData();
//   }

//   Future<void> fetchData() async {
//     final response = await http.get(Uri.parse('http://localhost:3001/data'));

//     if (response.statusCode == 200) {
//       setState(() {
//         data = json.decode(response.body)['results'];
//       });
//     } else {
//       throw Exception('Failed to load data');
//     }
//   }

//   Future<void> addData() async {
//     final double inputValue = double.tryParse(valueController.text) ?? 0.0;
//     final int timestamp = data.length + 1;

//     if (inputValue != 0.0) {
//       final response = await http.get(
//         Uri.parse(
//             'http://localhost:3001/addData?value=$inputValue&timestamp=$timestamp'), // Use GET request with query parameters
//       );

//       if (response.statusCode == 200) {
//         Fluttertoast.showToast(
//           msg: 'Data added successfully',
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.BOTTOM,
//         );

//         valueController.clear();
//         fetchData();
//       } else {
//         throw Exception('Failed to add data');
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('PostgreSQL Data'),
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextField(
//               controller: valueController,
//               keyboardType: TextInputType.number,
//               decoration:
//                   const InputDecoration(labelText: 'Enter Numeric Value'),
//             ),
//           ),
//           ElevatedButton(
//             onPressed: addData,
//             child: const Text('Add Data'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.of(context).push(MaterialPageRoute(
//                 builder: (context) => SPCResultPage(),
//               ));
//             },
//             child: const Text('SPC Result'),
//           ),
//         ],
//       ),
//     );
//   }
// }
//////////////spc result is fetching but not add data 