import 'package:flutter/material.dart';
import '../model/detail_model.dart';
import '../service/service_method.dart';
import 'dart:convert';

class DetailsInfoProvide with ChangeNotifier {
  DetailsModel goodsInfo = null;

  bool isLeft = true;
  bool isRight = false;


  // 从后台获取数据
  getGoodsInfo(String id) async {
    var formData = {'goodId': id};
    await getGoodsDetail().then((data) {
      if (data != null) {
        goodsInfo = DetailsModel.fromJson(data['data']);

        notifyListeners();
      }

    });
  }

  // 改变tabBar的状态
  changeLeftAndRigth(String changeState) {
    if (changeState == 'left') {
      isLeft = true;
      isRight = false;
    } else {
      isLeft = false;
      isRight = true;
    }

    notifyListeners();
  }

}