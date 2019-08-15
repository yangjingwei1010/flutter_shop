import 'package:flutter/material.dart';

class CurrentIndexProvide with ChangeNotifier{
  int currentIndex;

  changeIndex(int newIndex){
    currentIndex=newIndex;
    notifyListeners();
  }

}
