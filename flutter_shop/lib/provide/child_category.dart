import 'package:flutter/material.dart';
import '../model/category.dart';


// ChangeNotifier的混入是不用管理听众
class ChildCategory with ChangeNotifier {
  List<BxMallSubDto> childCategoryList = []; //商品列表
  int childIndex = 0; // 子类索引值
  int categoryId = 4; // 大类ID
  int subId = 0; // 子类ID
  int page = 1; // 列表页数，改变大类或者小类时进行改变
  String noMoreText = ''; // 显示更多标示
  bool isNewCategory = false;


  // 点击大类时更换
  getChildCategoryList(List<BxMallSubDto> list, int id) {
    isNewCategory = true;
    childIndex = 0;
    categoryId = id;
    subId = 0;
    page = 1;
    noMoreText = '';

    BxMallSubDto all = BxMallSubDto();
    all.mallSubId = '';
    all.mallCategoryId = 0;
    all.mallSubName = '全部';
    all.comments = '全部';
    childCategoryList = [all];
    childCategoryList.addAll(list);

    notifyListeners();
  }

  // 改变子类索引
  changeChildIndex(index, id) {
    isNewCategory = true;
    // 传递两个参数，使用新传递的参数给状态赋值
    childIndex = index;
    subId = id;
    page = 1;
    noMoreText = '';
    notifyListeners();
  }

  // 增加page的方法
  addPage() {
    page++;
  }

  // 改变noMoreText数据
  changeMore(String text) {
    noMoreText = text;
    notifyListeners();
  }

}
