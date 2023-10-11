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
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<dynamic>> fetchData() async {
    final response = await http.post(
      Uri.parse('http://localhost:3000/calculate-spc'),
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
            // ignore: prefer_const_constructors
            return Center(child: const CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            // Display your data using snapshot.data
            return const Center(
              // ignore: prefer_const_constructors
              child: Text('Data Loaded Successfully'),
            );
          }
        },
      ),
    );
  }
}









// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key});

//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       title: 'SPC Result App',
//       home: MyHomePage(),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({Key? key});

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   List data = [];

//   @override
//   void initState() {
//     super.initState();
//     fetchData();
//   }

//   Future<void> fetchData() async {
//     try {
//       final response = await http.post(
//         Uri.parse('http://localhost:3000/calculate-spc'),
//         headers: {'Content-Type': 'application/json'},
//       );

//       if (response.statusCode == 200) {
//         setState(() {
//           data = json.decode(response.body);
//         });
//       } else {
//         throw Exception('Failed to load data - ${response.statusCode}');
//       }
//     } catch (error) {
//       print('Error fetching data: $error');
//       throw Exception('Failed to load data - $error');
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
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else {
//             // Display your data using snapshot.data
//             return Scaffold(
//               appBar: AppBar(
//                 title: const Text('PostgreSQL Data'),
//               ),
//               body: ListView.builder(
//                 itemCount: data.length,
//                 itemBuilder: (context, index) {
//                   return ListTile(
//                     title: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text('X bar: ${data[index]['xbar']}'),
//                         Text('Stdev Overall: ${data[index]['sd']}'),
//                         Text('Pp: ${data[index]['pp']}'),
//                         Text('Ppu: ${data[index]['ppu']}'),
//                         Text('Ppl: ${data[index]['ppl']}'),
//                         Text('Ppk: ${data[index]['ppk']}'),
//                         Text('Rbar: ${data[index]['rbar']}'),
//                         Text('Stdev Within: ${data[index]['sdw']}'),
//                         Text('Cp: ${data[index]['cp']}'),
//                         Text('Cpu: ${data[index]['cpu']}'),
//                         Text('Cpl: ${data[index]['cpl']}'),
//                         Text('Cpk: ${data[index]['cpk']}'),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//             );
//           }
//         },
//       ),
//     );
//   }
// }
