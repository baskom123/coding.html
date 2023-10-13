import 'package:flutter/material.dart';
import 'package:flutter_application_3/m03/dbhelper.dart';

import 'ShoppingList.dart';

class ShoppingListDialog {
  final DBhelper _dBhelper;
  ShoppingListDialog(this._dBhelper);

  final txtName = TextEditingController();
  final txtSum = TextEditingController();

  Widget buildDialog(
      BuildContext context, ShoppingList list, bool isNew, int id) {
    if (!isNew) {
      txtName.text = list.name;
      txtSum.text = list.sum.toString();
    } else {
      txtName.text = "";
      txtSum.text = "";
    }
    return AlertDialog(
      title: Text((isNew) ? 'New shopping list $id' : 'edit shopping list $id'),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: txtName,
              decoration: const InputDecoration(hintText: 'Shopping List Name'),
            ),
            TextField(
              controller: txtSum,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: 'sum'),
            ),
            Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  child: const Text('Save Shopping List'),
                  onPressed: () {
                    list.name = txtName.text != "" ? txtName.text : "empty";
                    list.sum = txtSum.text != "" ? int.parse(txtSum.text) : 0;
                    _dBhelper.insertShoppingList(list);
                    Navigator.pop(context);
                  },
                ))
          ],
        ),
      ),
    );
  }
}
