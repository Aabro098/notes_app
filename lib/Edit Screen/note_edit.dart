
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:notes_app/Common%20Widget/common_widget.dart';
import '../Access/django_fetch.dart';
import 'package:http/http.dart' as http;
import '../App Styles/text_style.dart';
import '../Home Page/home_page.dart';

class NoteEditScreen extends StatefulWidget {
  final Note note;

  const NoteEditScreen({super.key, required this.note, required int id});

  @override
  // ignore: library_private_types_in_public_api
  _NoteEditScreenState createState() => _NoteEditScreenState();
}

class _NoteEditScreenState extends State<NoteEditScreen> {
  late TextEditingController _titleController;
  late TextEditingController _bodyController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note.title);
    _bodyController = TextEditingController(text: widget.note.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: getRandomColor(),
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Update Note",
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
            onPressed: (){updateNote(
              widget.note.id, 
              _titleController.text, 
              _bodyController.text);
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: 'Title',
                  hintStyle: AppTextStyle.mainTitle,
                  border: InputBorder.none
                ),
              ),
              TextField(
                controller: _bodyController,
                decoration: InputDecoration(
                    hintText: 'Body',
                    hintStyle: AppTextStyle.mainContent,
                    border: InputBorder.none
                  ),
                  maxLines: null, 
              ),
            ],
          ),
        ),
      ),
    );
  }

   Future<void> updateNote(int pk, String title, String body) async {
    final String updateUrl = 'http://127.0.0.1:8000/notes/$pk/update/';
    await http.put(
      Uri.parse(updateUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'title': title,
        'body': body,
      }),
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }
  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }
}
