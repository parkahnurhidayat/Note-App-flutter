import 'package:flutter/material.dart';
import 'package:note_app/database/note_database.dart';
import 'package:note_app/model/note.dart';
import 'package:note_app/widgets/note_from_widgets.dart';

class AddEditNotePage extends StatefulWidget {
  final Note? note;
  const AddEditNotePage({super.key, this.note});

  @override
  State<AddEditNotePage> createState() => _AddEditNotePageState();
}

class _AddEditNotePageState extends State<AddEditNotePage> {
  late bool isImportant;
  late int number;
  late String title;
  late String description;
  final _fromKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    isImportant = widget.note?.isImportant ?? false;
    number = widget.note?.number ?? 0;
    title = widget.note?.title ?? "";
    description = widget.note?.description ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [_buildButtonSave()],
      ),
      body: Form(
          key: _fromKey,
          child: NoteFormWidgets(
              isImportant: isImportant,
              number: number,
              title: title,
              description: description,
              onChangeIsImportant: (value) {
                setState(() {
                  isImportant = value;
                });
              },
              onChangeNumber: (value) {
                setState(() {
                  number = value;
                });
              },
              onChangeTitle: (value) {
                title = value;
              },
              onChangeDescription: (value) {
                description = value;
              })),
    );
  }

  _buildButtonSave() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ElevatedButton(
        onPressed: () async {
          final isValid = _fromKey.currentState!.validate();
          if (isValid) {
            if (widget.note != null) {
              //UPDATE DATA
              await updateNote();
            } else {
              await addNote();
            }
            Navigator.pop(context);
          }
        },
        child: const Text("Save"),
      ),
    );
  }

  Future addNote() async {
    final note = Note(
        isImportant: isImportant,
        number: number,
        title: title,
        description: description,
        createdTime: DateTime.now());
    await NoteDatabase.instance.create(note);
  }

  Future updateNote() async {
    final updateNote = widget.note!.copy(
        isImportant: isImportant,
        number: number,
        title: title,
        description: description,
        createdTime: DateTime.now());
    await NoteDatabase.instance.updateNote(updateNote);
  }
}
