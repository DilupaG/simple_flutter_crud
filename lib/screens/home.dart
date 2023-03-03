import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<List<String>> _data;

  Future<List<String>> fetchData() async {
    final response =
        await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users'));
    if (response.statusCode == 200) {
      final jsonList = json.decode(response.body) as List<dynamic>;
      return jsonList.map((e) => e['name'] as String).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  void initState() {
    super.initState();
    _data = fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My future"),
      ),
      body: Center(
        child: FutureBuilder<List<String>>(
            future: _data,
            builder: ((context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemBuilder: ((context, index) {
                    return ListTile(
                      title: Text(snapshot.data![index]),
                    );
                  }),
                  itemCount: snapshot.data?.length,
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return const CircularProgressIndicator();
            })),
      ),
    );
  }
}
