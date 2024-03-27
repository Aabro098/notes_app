import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:notes_app/Access/django_fetch.dart'; 
import 'package:notes_app/Common%20Widget/common_widget.dart';
import '../Add Note/add_note.dart';
import '../App Styles/color_style.dart';
import '../App Styles/text_style.dart';
import '../Edit Screen/note_edit.dart';
import '../Notes View/note_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}


class _HomePageState extends State<HomePage> {
  late http.Client client;
  final String retrieveUrl = 'http://127.0.0.1:8000/notes/';
  late List<Note> notes;

  @override
  void initState() {
    super.initState();
    client = http.Client();
    notes = [];
    _retrieveNotes();
  }

  @override
  void dispose() {
    client.close();
    super.dispose();
  }

  Future<void> _retrieveNotes() async {
    try {
      final response = await client.get(Uri.parse(retrieveUrl));
      if (response.statusCode == 200) {
        final List<dynamic> decodedResponse = jsonDecode(response.body);
        setState(() {
          notes = decodedResponse.map((e) => Note.fromMap(e)).toList();
        });
      } else {
       // print('Failed to retrieve notes: ${response.statusCode}');
      }
    } catch (e) {
      //print('Exception while retrieving notes: $e');
    }
  }

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
        backgroundColor: ColorStyle.mainColor,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const NoteAddScreen()));
        },
        label: const Text(
          "Add Note",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
        icon: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody() {
    if (notes.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(), 
      );
    } else {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Recent Notes",
              style: GoogleFonts.roboto(
                fontWeight: FontWeight.w600,
                color: Colors.white,
                fontSize: 16.0,
              ),
            ),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: notes.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: GestureDetector(
                    onTap: (){
                       Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NoteViewScreen(
                            title: notes[index].title,
                            body: notes[index].body,
                            createDate: notes[index].createDate,
                            id : notes[index].id
                          ),
                        ),
                      );
                    },
                    onDoubleTap: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NoteEditScreen(
                            note: notes[index],
                            id: notes[index].id,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      color: getRandomColor(),
                      child: ListTile(
                        title: Text(notes[index].title , style: AppTextStyle.mainTitle),
                        subtitle: Text(
                          notes[index].body.length > 50 ? '${notes[index].body.substring(0, 50)}...' : notes[index].body,
                            style: AppTextStyle.mainContent ,
                        ),
                        trailing: Container(
                          width: 40, 
                          height: 40, 
                          decoration: BoxDecoration(
                            color: Colors.blue.shade400, 
                            borderRadius: BorderRadius.circular(8.0), 
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.delete), 
                            color: Colors.white,
                            onPressed: () {
                              deleteNoteFromApi(notes[index].id); 
                            }, 
                            alignment: Alignment.center,
                          ),
                        )
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      );
    }
  }
  void deleteNoteFromApi(int pk) async {
    final String deleteUrl = 'http://127.0.0.1:8000/notes/$pk/delete/';
    await http.delete(Uri.parse(deleteUrl));
    _retrieveNotes();
  }
}