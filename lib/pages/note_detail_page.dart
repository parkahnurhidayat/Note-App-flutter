import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note_app/database/note_database.dart';
import 'package:note_app/model/note.dart';
import 'package:note_app/pages/add_edit_note_page.dart';

class NoteDetailPage extends StatefulWidget {
  final int id;
  const NoteDetailPage({super.key, required this.id});

  @override
  State<NoteDetailPage> createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  late Note note;
  var isLoading = false;

  Future refreshNote() async {
    setState(() {
      isLoading = true;
    });
    note = await NoteDatabase.instance.getNoteById(widget.id);

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    refreshNote();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [editButton(), deleteButton()],
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : ListView(
                padding: const EdgeInsets.all(8),
                children: [
                  Text(
                    note.title,
                    style: const TextStyle(
                      // color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    DateFormat.yMMMd().format(note.createdTime),
                    // style: const TextStyle(color: Colors.white38),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    note.description,
                    style: const TextStyle(
                      // color: Colors.white70,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget editButton() {
    return IconButton(
      onPressed: () async {
        await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddEditNotePage(note: note),
            ));
        refreshNote();
      },
      icon: const Icon(Icons.edit_outlined), // Icons.delete
    );
  }

  Widget deleteButton() {
    return IconButton(
      onPressed: () async {
        if (isLoading) return;
        await NoteDatabase.instance.deleteNoteById(note.id!);
        Navigator.pop(context);
      },
      icon: const Icon(Icons.delete), // Icons.delete
    );
  }
}
