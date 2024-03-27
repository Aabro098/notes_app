import 'package:flutter/material.dart';
import 'package:notes_app/Common%20Widget/common_widget.dart';
import '../App Styles/color_style.dart';
import '../App Styles/text_style.dart';
import 'package:http/http.dart' as http;

import '../Home Page/home_page.dart';

class NoteViewScreen extends StatefulWidget {
  final String title;
  final String body;
  final String createDate;
  final int id;
  const NoteViewScreen({
    required this.title,
    required this.body,
    required this.createDate,
    required this.id,
    super.key, 
  });
  @override
  // ignore: library_private_types_in_public_api
  _NoteViewScreenState createState() => _NoteViewScreenState();
}

class _NoteViewScreenState extends State<NoteViewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorStyle.mainColor,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Keep Notes",
          style: AppTextStyle.appbarTitle,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
              onPressed: () {
                deleteNoteFromApi(widget.id);
              },
          ),
        ],
        backgroundColor: ColorStyle.mainColor,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: _buildNoteBody(),
    );
  }

  Widget _buildNoteBody() {
    return Scaffold(
      backgroundColor: getRandomColor(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.title , style: AppTextStyle.mainTitle),
            const SizedBox(height: 5),
            Text(widget.createDate, style: AppTextStyle.dateTitle,),
            const SizedBox(height: 5),
            Text(widget.body , style: AppTextStyle.mainContent,),
          ],
        ),
      ),
    );
  }
  void deleteNoteFromApi(int pk) async {
    final String deleteUrl = 'http://127.0.0.1:8000/notes/$pk/delete/';
    await http.delete(Uri.parse(deleteUrl));
    Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => const HomePage()),
  );
  }   
}

