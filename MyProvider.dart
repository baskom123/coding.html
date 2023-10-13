import 'package:flutter/material.dart';
import 'package:flutter_application_3/m03/HistoryList.dart';
import 'package:flutter_application_3/m03/ShoppingList.dart';


class ListProductProvider extends ChangeNotifier {
  List<ShoppingList> _shoppingList = [];
  List<ShoppingList> get getShoppingList => _shoppingList;
  set setShoppingList(value) {
    _shoppingList = value;
    notifyListeners();
  }

  void deletedById(shoppingList) {
    _shoppingList.remove(shoppingList);
    notifyListeners();
  }

  List<HistoryList> _historyList = [];
  List<HistoryList> get getHistoryList => _historyList;
  set setHistoryList(value) {
    _historyList = value;
    notifyListeners();
  }
}
