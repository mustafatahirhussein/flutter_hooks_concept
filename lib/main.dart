import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_hooks_tutorial/todo_model.dart';

import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends HookWidget {
  const MyApp({Key? key}) : super(key: key);

  // @override
  // State<MyApp> createState() => _MyAppState();

  @override
  Widget build(BuildContext context) {

    ValueNotifier<List<TodoModel>> modelList = useState([]);

    Future<List<TodoModel>> allTodos() async {
      var response = await http.get(Uri.parse("https://jsonplaceholder.typicode.com/todos/"));

      if(response.statusCode == 200) {
        List<TodoModel> data = todoModelFromJson(response.body);

        modelList.value = data;

        print("data $modelList");
        return modelList.value;
      }
      else {
        return [];
      }
    }

    useEffect( () {

      var result = allTodos();
      return () {
        result;
      };
    }, []);

   // useEffect(() => allTodos);

    return MaterialApp(
      home: Scaffold(
        body: ListView(
          shrinkWrap: true,
          children: modelList.value.map((e) {
            return ListTile(
              title: Text(e.title!),
              subtitle: Text(e.completed.toString()),
            );
          }).toList(),
        ),
      ),
    );
  }
}

// class _MyAppState extends State<MyApp> {
//
//   List<TodoModel> modelList = [];
//
//   Future<List<TodoModel>> allTodos() async {
//     var response = await http.get(Uri.parse("https://jsonplaceholder.typicode.com/todos/"));
//
//     if(response.statusCode == 200) {
//       List<TodoModel> data = todoModelFromJson(response.body);
//
//       modelList = data;
//       return modelList;
//     }
//     else {
//       return [];
//     }
//   }
//
//   @override
//   initState() {
//     super.initState();
//     allTodos();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         body: ListView(
//           shrinkWrap: true,
//           children: modelList.map((e) {
//             return ListTile(
//               title: Text(e.title!),
//               subtitle: Text(e.completed.toString()),
//             );
//           }).toList(),
//         ),
//       ),
//     );
//   }
// }
