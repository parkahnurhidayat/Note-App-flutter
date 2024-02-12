import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class NoteFormWidgets extends StatelessWidget {
  const NoteFormWidgets(
      {Key? key,
      required this.isImportant,
      required this.number,
      required this.title,
      required this.description,
      required this.onChangeIsImportant,
      required this.onChangeNumber,
      required this.onChangeTitle,
      required this.onChangeDescription})
      : super(key: key);

  final bool isImportant;
  final int number;
  final String title;
  final String description;
  final ValueChanged<bool> onChangeIsImportant;
  final ValueChanged<int> onChangeNumber;
  final ValueChanged<String> onChangeTitle;
  final ValueChanged<String> onChangeDescription;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Switch(value: isImportant, onChanged: onChangeIsImportant),
                Expanded(
                    child: Slider(
                        value: number.toDouble(),
                        min: 0,
                        max: 5,
                        divisions: 5,
                        onChanged: (value) => onChangeNumber(value.toInt())))
              ],
            ),
            buildTitleField(),
            const SizedBox(
              height: 8,
            ),
            buildDescriptionField(),
          ],
        ),
      ),
    );
  }

  TextFormField buildTitleField() {
    return TextFormField(
      maxLines: 1,
      initialValue: title,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
      decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: 'Title',
          hintStyle: TextStyle(color: Colors.grey)),
      validator: (value) {
        return value != null && value.isEmpty ? 'Title cannot be empty' : null;
      },
      onChanged: onChangeTitle,
    );
  }

  TextFormField buildDescriptionField() {
    return TextFormField(
      maxLines: null,
      initialValue: description,
      style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 15),
      decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: 'Type something.....',
          hintStyle: TextStyle(color: Colors.grey)),
      validator: (value) {
        return value != null && value.isEmpty
            ? 'Description cannot be empty'
            : null;
      },
      onChanged: onChangeDescription,
    );
  }
}
