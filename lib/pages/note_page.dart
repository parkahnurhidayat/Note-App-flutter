import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:note_app/database/note_database.dart';
import 'package:note_app/model/note.dart';
import 'package:note_app/pages/add_edit_note_page.dart';
import 'package:note_app/pages/note_detail_page.dart';
import 'package:note_app/widgets/note_card_widgets.dart';

class NotePage extends StatefulWidget {
  final Note? note;
  const NotePage({super.key, this.note});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  late List<Note> notes;
  var isLoading = false;

  Future refreshNote() async {
    setState(() {
      isLoading = true;
    });
    notes = await NoteDatabase.instance.getAllNotes();

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
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : notes.isEmpty
                ? const Text('Empty notes')
                : MasonryGridView.count(
                    crossAxisCount: 2,
                    itemCount: notes.length,
                    itemBuilder: (context, index) {
                      final note = notes[index];
                      return GestureDetector(
                          onTap: () async {
                            await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      NoteDetailPage(id: note.id!),
                                ));
                            refreshNote();
                          },
                          child: NoteCardWidget(note: note, index: index));
                    },
                  ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () async {
            // final note = Note(
            //     isImportant: false,
            //     number: 1,
            //     title: "Testing",
            //     description: "Desc testing",
            //     createdTime: DateTime.now());
            // await NoteDatabase.instance.create(note);
            // refreshNote();

            await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddEditNotePage(),
                ));
            refreshNote();
          },
          child: const Icon(Icons.add)),
    );
  }
}
