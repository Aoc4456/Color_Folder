import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sort_note/component/icon/folder_small_icon.dart';

class ListItemFolderEdit extends StatefulWidget {
  ListItemFolderEdit({this.title, this.callback, this.priority, this.tagId});

  final String title;
  final Function() callback;
  final int priority; // TODO デバッグ用
  final String tagId;

  @override
  _ListItemFolderEditState createState() => _ListItemFolderEditState();
}

class _ListItemFolderEditState extends State<ListItemFolderEdit> {
  bool _isCheck = false;

  void _handleCheckbox(bool isCheck) {
    setState(() {
      _isCheck = isCheck;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 74,
      child: ListTile(
        leading: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Checkbox(value: _isCheck, onChanged: _handleCheckbox),
            VerticalDivider(
              color: Colors.grey,
            ),
            Hero(
              tag: 'folderSmallIcon${widget.tagId}',
              child: FolderSmallIcon(
                size: 45,
              ),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '⋮',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
            SizedBox(
              width: 6,
            ),
            VerticalDivider(
              color: Colors.grey,
            ),
            Icon(
              Icons.dehaze,
              size: 35,
            ),
          ],
        ),
        title: Text(
          widget.title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        onTap: widget.callback,
      ),
    );
  }
}
