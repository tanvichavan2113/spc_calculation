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

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('PostgreSQL Data'),
// //       ),
// //       body: ListView.builder(
// //         itemCount: data.length,
// //         itemBuilder: (context, index) {
// //           return ListTile(
// //             title: Text('Name: ${data[index]['name']}'),
// //             subtitle: Text('Age: ${data[index]['age']}'),
// //           );
// //         },
// //       ),
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter PostgreSQL Demo',
//       home: HomeScreen(),
//     );
//   }
// }

// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   List data = [];

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

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('PostgreSQL Data'),
//       ),
//       body: ListView.builder(
//         itemCount: data.length,
//         itemBuilder: (context, index) {
//           return ListTile(
//             title: Text('Value: ${data[index]['value']}'),
//             subtitle: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text('Timestamp: ${data[index]['timestamp']}'),
//                 Text('MR: ${data[index]['mr']}'),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }    succesfully fetched the  data

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse('http://localhost:3001/data'));
    if (response.statusCode == 200) {
      setState(() {
        // Assuming the server returns data in ascending order based on the update timestamp
        // If not, you may need to sort the data accordingly.
        List<dynamic> results = json.decode(response.body)['results'];
        data = [results.isNotEmpty ? results.last : null];
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PostgreSQL Data'),
      ),
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('X bar: ${data[index]['xbar']}'),
                Text('Stdev Overall ${data[index]['sd']}'),
                Text('Pp: ${data[index]['pp']}'),
                Text('Ppu: ${data[index]['ppu']}'),
                Text('Ppl: ${data[index]['ppl']}'),
                Text('Ppk: ${data[index]['ppk']}'),
                Text('Rbar: ${data[index]['rbar']}'),
                Text('Stdev Within: ${data[index]['sdw']}'),
                Text('Cp: ${data[index]['cp']}'),
                Text('Cpu: ${data[index]['cpu']}'),
                Text('Cpl: ${data[index]['cpl']}'),
                Text('Cpk: ${data[index]['cpk']}'),
              ],
            ),
          );
        },
      ),
    );
  }
}
