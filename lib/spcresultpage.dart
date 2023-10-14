// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;

// class SPCResultPage extends StatelessWidget {
//   const SPCResultPage({super.key});

//   Future<List<dynamic>> fetchData() async {
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
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else {
//             // Display your data using snapshot.data
//             List<dynamic> data = snapshot.data as List<dynamic>;

//             return ListView.builder(
//               itemCount: 1,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   title: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text('X bar: ${data[index]['xbar']}'),
//                       Text('Stdev Overall ${data[index]['sd']}'),
//                       Text('Pp: ${data[index]['pp']}'),
//                       Text('Ppu: ${data[index]['ppu']}'),
//                       Text('Ppl: ${data[index]['ppl']}'),
//                       Text('Ppk: ${data[index]['ppk']}'),
//                       Text('Rbar: ${data[index]['rbar']}'),
//                       Text('Stdev Within: ${data[index]['sdw']}'),
//                       Text('Cp: ${data[index]['cp']}'),
//                       Text('Cpu: ${data[index]['cpu']}'),
//                       Text('Cpl: ${data[index]['cpl']}'),
//                       Text('Cpk: ${data[index]['cpk']}'),
//                     ],
//                   ),
//                 );
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SPCResultPage extends StatefulWidget {
  const SPCResultPage({super.key});

  @override
  _SPCResultPageState createState() => _SPCResultPageState();
}

class _SPCResultPageState extends State<SPCResultPage> {
  List<dynamic> data = [];

  Future<void> retriveData() async {
    final response = await http.post(
      Uri.parse('http://localhost:3001/calculate-spc'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      setState(() {
        data = jsonDecode(response.body);
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  void initState() {
    super.initState();
    retriveData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SPC Result App'),
      ),
      body: data.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: 1,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('X bar: ${data[0]['xbar']}'),
                      Text('Stdev Overall: ${data[0]['sd']}'),
                      Text('Pp: ${data[0]['pp']}'),
                      Text('Ppu: ${data[0]['ppu']}'),
                      Text('Ppl: ${data[0]['ppl']}'),
                      Text('Ppk: ${data[0]['ppk']}'),
                      Text('Rbar: ${data[0]['rbar']}'),
                      Text('Stdev Within: ${data[0]['sdw']}'),
                      Text('Cp: ${data[0]['cp']}'),
                      Text('Cpu: ${data[0]['cpu']}'),
                      Text('Cpl: ${data[0]['cpl']}'),
                      Text('Cpk: ${data[0]['cpk']}'),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
