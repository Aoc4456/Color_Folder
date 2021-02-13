import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:sort_note/component/list_item/list_item_folder_edit.dart';
import 'package:sort_note/screen/folder_detail/folder_detail_page.dart';

import 'folder_edit_list_model.dart';

// 3. Providerモデルクラスをグローバル定数に宣言
final folderProvider = ChangeNotifierProvider((ref) => FolderEditModel());

class FolderEditPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    // 4. 観察する変数を useProvider を使って宣言
    final provider = useProvider(folderProvider);

    // build完了直後に呼び出されるらしい
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.getFolders();
    });

    return WillPopScope(
      onWillPop: () {
        provider.clear();
        Navigator.of(context).pop();
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            '編集',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            Visibility(
                visible: provider.checkedFolderIds.length > 0,
                child: IconButton(
                    icon: Icon(
                      Icons.delete_forever,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () async {
                      showDialog(
                          context: context,
                          builder: (_) {
                            return AlertDialog(
                              title: Text(
                                  '${provider.checkedFolderIds.length}件のフォルダーを削除しますか？'),
                              content: Text(
                                  '選択したフォルダーと、フォルダー内のすべてのノートが削除されます。この操作は取り消せません。'),
                              actions: [
                                // ボタン領域
                                FlatButton(
                                  child: Text(
                                    "キャンセル",
                                  ),
                                  onPressed: () => Navigator.pop(context),
                                ),
                                FlatButton(
                                  child: Text(
                                    "削除",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                  onPressed: () async {
                                    await provider.deleteFolders();
                                    await provider.getFoldersNotify();
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            );
                          });
                    }))
          ],
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
          child: ReorderableListView(
            onReorder: (int oldIndex, int newIndex) {
              provider.onReorder(oldIndex, newIndex);
            },
            children: (provider.folders).map((folder) {
              return Container(
                key: Key(folder.id.toString()),
                child: ListItemFolderEdit(
                  folder: folder,
                  onTapCallback: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              FolderDetailPage(folder: folder),
                        )).then((value) {
                      provider.getFoldersNotify();
                    });
                  },
                  checkedCallback: (isCheck) {
                    provider.onItemCheck(folder.id, isCheck);
                  },
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
