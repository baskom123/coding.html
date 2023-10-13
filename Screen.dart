import 'package:flutter/material.dart';
import 'package:flutter_application_3/m03/HistoryScreen.dart';
import 'package:flutter_application_3/m03/ShoppingList.dart';
import 'package:flutter_application_3/m03/dbhelper.dart';
import 'package:flutter_application_3/m03/shopping_list_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:provider/provider.dart';

import 'MyProvider.dart';

import 'ItemScreen.dart';

class Screen extends StatefulWidget {
  const Screen({super.key});

  @override
  State<Screen> createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  final DBhelper _dBhelper = DBhelper();
  int id = 0;

  @override
  void initState() {
    super.initState();
    loadLastId();
  }

  Future<void> loadLastId() async {
    final prefs = await SharedPreferences.getInstance();
    final lastId = prefs.getInt('lastId') ?? 0;
    setState(() {
      id = lastId;
    });
  }

  Future<void> saveLastId(int lastId) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('lastId', lastId);
  }

  Future<void> _deleteAllItems() async {
    await _dBhelper.deleteAllShoppingList();
    var tmp = Provider.of<ListProductProvider>(context, listen: false);
    tmp.setShoppingList = [];

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Semua item telah dihapus'),
    ));
  }

  @override
  Widget build(BuildContext context) {
    var tmp = Provider.of<ListProductProvider>(context, listen: true);
    _dBhelper.getmyShopingList().then((value) => tmp.setShoppingList = value);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shopping List"),
        actions: [
          IconButton(
            onPressed: () {
              for (var i = 0; i < tmp.getShoppingList.length; i++) {
                _dBhelper.insertHistoryList(
                    tmp.getShoppingList[i], DateTime.now().toString());
              }
              _dBhelper.deleteAllShoppingList();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Semua item telah dihapus'),
              )); // Panggil metode untuk menghapus semua item
            },
            icon: const Icon(Icons.delete),
            tooltip: 'Delete All',
          ),
          IconButton(
              onPressed: () => Navigator.push(
                  context, MaterialPageRoute(builder: (context) => History())),
              icon: const Icon(Icons.menu))
        ],
      ),
      body: ListView.builder(
          itemCount:
              // ignore: unnecessary_null_comparison
              tmp.getShoppingList != null ? tmp.getShoppingList.length : 0,
          itemBuilder: (BuildContext context, int index) {
            return Dismissible(
              key: Key(tmp.getShoppingList[index].id.toString()),
              onDismissed: (direction) {
                String tmpName = tmp.getShoppingList[index].name;
                int tmpId = tmp.getShoppingList[index].id;
                _dBhelper.insertHistoryList(
                    tmp.getShoppingList[index], DateTime.now().toString());
                setState(() {
                  tmp.deletedById(tmp.getShoppingList[index]);
                });

                _dBhelper.deleteShoppingList(tmpId);

                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text('$tmpName deleted'),
                ));
              },
              child: ListTile(
                title: Text(tmp.getShoppingList[index].name),
                leading: CircleAvatar(
                  child: Text("${tmp.getShoppingList[index].sum}"),
                ),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ItemsScreen(tmp.getShoppingList[index]);
                  }));
                },
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return ShoppingListDialog(_dBhelper).buildDialog(
                            context,
                            tmp.getShoppingList[index],
                            false,
                            tmp.getShoppingList[index].id);
                      },
                    );
                    _dBhelper
                        .getmyShopingList()
                        .then((value) => tmp.setShoppingList = value);
                  },
                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showDialog(
              context: context,
              builder: (context) {
                return ShoppingListDialog(_dBhelper)
                    .buildDialog(context, ShoppingList(++id, "", 0), true, id);
              });
          await saveLastId(id); // Simpan ID terakhir
          _dBhelper
              .getmyShopingList()
              .then((value) => tmp.setShoppingList = value);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    _dBhelper.closeDB();
    super.dispose();
  }
}
