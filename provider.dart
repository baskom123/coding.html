import 'package:flutter/material.dart';

class BioData extends ChangeNotifier {
  String? image;
  double score = 0;
  String? date;

  void setImage(String? imagePath) {
    image = imagePath;
    notifyListeners();
  }

  void setScore(double newScore) {
    score = newScore;
    notifyListeners();
  }

  void setDate(String newDate) {
    date = newDate;
    notifyListeners();
  }
}
