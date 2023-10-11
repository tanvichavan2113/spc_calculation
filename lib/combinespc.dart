import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'SPC Result App',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<dynamic>> fetchData() async {
    final response = await http.post(
      Uri.parse('http://localhost:3001/calculate-spc'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SPC Result App'),
      ),
      body: FutureBuilder(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            // Display your data using snapshot.data
            List<dynamic> data = snapshot.data as List<dynamic>;

            return ListView.builder(
              itemCount: 1,
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
            );
          }
        },
      ),
    );
  }
}
////////////////successfullly runned above code

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       title: 'SPC Result App',
//       home: MyHomePage(),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key});

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   Future<Map<String, dynamic>> fetchData() async {
//     final response = await http.post(
//       Uri.parse('http://localhost:3001/calculate-spc'),
//       headers: {'Content-Type': 'application/json'},
//     );

//     if (response.statusCode == 200) {
//       return jsonDecode(response.body);
//     } else {
//       throw Exception('Failed to load data');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('SPC Result App'),
//       ),
//       body: FutureBuilder(
//         future: fetchData(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else {
//             // Display your data using snapshot.data
//             Map<String, dynamic> data = snapshot.data as Map<String, dynamic>;

//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text('X bar: ${data['xbar']}'),
//                 Text('Stdev Overall ${data['sd']}'),
//                 Text('Pp: ${data['pp']}'),
//                 Text('Ppu: ${data['ppu']}'),
//                 Text('Ppl: ${data['ppl']}'),
//                 Text('Ppk: ${data['ppk']}'),
//                 Text('Rbar: ${data['rbar']}'),
//                 Text('Stdev Within: ${data['sdw']}'),
//                 Text('Cp: ${data['cp']}'),
//                 Text('Cpu: ${data['cpu']}'),
//                 Text('Cpl: ${data['cpl']}'),
//                 Text('Cpk: ${data['cpk']}'),
//               ],
//             );
//           }
//         },
//       ),
//     );
//   }
// }
