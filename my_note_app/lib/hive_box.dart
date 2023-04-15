import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CustomHiveBox {
  final box = Hive.box('notes_box');

  Future<List<Map<String, dynamic>>> createItem(Map<String, dynamic> newItem) async {
    await box.add(newItem);
    return refreshItems(); // update the UI
  }

  Map<String, dynamic> readItem(int key) {
    final item = box.get(key);
    return item;
  }

  Future<List<Map<String, dynamic>>> updateItem(int itemKey, Map<String, dynamic> item) async {
    await box.put(itemKey, item);
    return refreshItems(); // update the UI
  }

  Future<List<Map<String, dynamic>>> deleteItem(BuildContext context, int itemKey) async {
    await delete(context, itemKey);
    return refreshItems(); // update the UI
  }

  Future<void> delete(BuildContext context, int itemKey) async {
    return await showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: const Text('Please Confirm'),
            content: const Text('Are you sure to remove the box?'),
            actions: [
              // The "Yes" button
              TextButton(
                  onPressed: () async {
                    await box.delete(itemKey);

                    // Close the dialog
                    Navigator.of(context).pop();
                  },
                  child: const Text('Yes')),
              TextButton(
                onPressed: () {
                  // Close the dialog
                  Navigator.of(context).pop();
                },
                child: const Text('No'),
              )
            ],
          );
        });
  }

  List<Map<String, dynamic>> refreshItems() {
    final data = box.keys.map((key) {
      final value = box.get(key);
      return {"key": key, "note": value["note"], "date": value['date']};
    }).toList();
    return data.reversed.toList();
  }
}
