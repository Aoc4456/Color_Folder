import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:sort_note/component/note_item_widget.dart';
import 'package:sort_note/component/text_input_dialog.dart';
import 'package:sort_note/note_list/note_model.dart';
import 'package:sort_note/model/note.dart';
import 'package:sort_note/repository/database.dart';

// 3. Providerモデルクラスをグローバル定数に宣言
final noteProvider = ChangeNotifierProvider((ref) => NoteModel());

class NotePage extends HookWidget {
  NotePage(this.folderId, this.folderName);

  final String folderName;
  final int folderId;

  @override
  Widget build(BuildContext context) {
    // 4. 観察する変数を useProvider を使って宣言
    final provider = useProvider(noteProvider)..getNotes(folderId);
    final notes = provider.notes;

    return Scaffold(
      appBar: AppBar(
        title: Text(folderName),
      ),
      body: GridView.extent(
          maxCrossAxisExtent: 150,
          children: notes
              .map((note) => NoteItemWidget(
                    id: note.id,
                    text: note.text,
                  ))
              .toList()),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          String noteText = await showInputTextDialog(context, "");
          if (noteText != null && noteText.isNotEmpty) {
            provider.addNote(Note(text: noteText, folderId: folderId));
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

Future<String> showInputTextDialog(BuildContext context, String text) {
  final dialog = TextInputDialog(text);
  return showDialog(
      context: context,
      builder: (BuildContext context) {
        return dialog;
      });
}
