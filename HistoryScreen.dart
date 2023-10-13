import 'package:flutter/material.dart';
import 'package:flutter_application_3/m03/dbhelper.dart';


import 'package:provider/provider.dart';

import 'MyProvider.dart';


class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  final DBhelper _dBhelper = DBhelper();

  @override
  Widget build(BuildContext context) {
    var tmp = Provider.of<ListProductProvider>(context, listen: true);
    _dBhelper.getmyHistoryList().then((value) => tmp.setHistoryList = value);
    return Scaffold(
      appBar: AppBar(
        title: const Text("History List"),
        // actions: [
        //   IconButton(
        //     onPressed: () {
        //       _dBhelper.deleteAllShoppingList();
        //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        //         content: Text('Semua item telah dihapus'),
        //       )); // Panggil metode untuk menghapus semua item
        //     },
        //     icon: const Icon(Icons.delete),
        //     tooltip: 'Delete All',
        //   )
        // ],
      ),
      body: ListView.builder(
          itemCount:
              // ignore: unnecessary_null_comparison
              tmp.getHistoryList != null ? tmp.getHistoryList.length : 0,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(tmp.getHistoryList[index].name),
              leading: CircleAvatar(
                child: Text("${tmp.getHistoryList[index].sum}"),
              ),
              trailing: Text(tmp.getHistoryList[index].tanggal),
            );
          }),
    );
  }

  // @override
  // void dispose() {
  //   _dBhelper.closeDB();
  //   super.dispose();
  // }
}
