
import 'package:flutter/material.dart';
import 'package:notes_app/Common%20Widget/common_widget.dart';
import '../App Styles/text_style.dart';
import 'package:http/http.dart' as http;

import '../Home Page/home_page.dart';

class NoteAddScreen extends StatefulWidget {
  const NoteAddScreen({super.key});

  @override
  State<NoteAddScreen> createState() => _NoteAddScreenState();
}

class _NoteAddScreenState extends State<NoteAddScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();

  Future<void> _createNote() async {
    final String title = _titleController.text;
    final String body = _bodyController.text;
    const String apiUrl = 'http://127.0.0.1:8000/notes/create/';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: {'title': title, 'body': body},
      );

      if (response.statusCode == 201) {
        //print('Note created successfully');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
       );
      } else {
       // print('Failed to create note: ${response.body}');
      }
    } catch (e) {
      //print('Error creating note: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getRandomColor(),
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Add Note",
          style: AppTextStyle.appbarTitle,
        ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: const Icon(
            Icons.check,
            color: Colors.black,
            ),
            onPressed: _createNote,
            )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextField(         
                controller: _titleController,       
                decoration: InputDecoration(
                  hintText: "Title", 
                  hintStyle: AppTextStyle.mainTitle,
                  border: InputBorder.none
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: _bodyController,
                decoration: InputDecoration(
                  hintText: "Body", 
                  hintStyle: AppTextStyle.mainContent,
                  border: InputBorder.none
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}