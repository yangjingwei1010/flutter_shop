import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../model/cart_info_model.dart';

class CartProvider with ChangeNotifier {
  String cartString = '[]';
  List<CartInfoMode> cartList = [];//商品列表对象
  double allPrice = 0;//总价格
  int allGoodsCount = 0;//商品总数量
  bool isAllCheck = true;//是否全选

  save(goodsId, goodsName, count, price, images) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString('cartInfo');//获取持久化存储的值
    //判断cartString是否为空，为空说明是第一次添加，或者被key被清除了。
    //如果有值进行decode操作
    var temp = cartString == null ? [] : json.decode(cartString.toString());
    //把获得值转变成List
    List<Map> tempList = (temp as List).cast();
    //声明变量，用于判断购物车中是否已经存在此商品ID
    var isHave = false;//默认为没有
    int ival = 0;
    tempList.forEach((item) {//进行循环，找出是否已经存在该商品
      if (item['goodsName'] == goodsName) {
        tempList[ival]['count'] = item['count'] + 1;
        cartList[ival].count++;
        isHave = true;
      }
      ival++;
    });

    //  如果没有，进行增加
    if (!isHave) {
      Map<String, dynamic> newGoods = {
        'goodsId':goodsId,
        'goodsName':goodsName,
        'count':count,
        'price':price,
        'images':images,
        'isCheck': true
      };

      tempList.add(newGoods);
      cartList.add(CartInfoMode.fromJson(newGoods));
    }
    //把字符串进行encode操作，
    cartString = json.encode(tempList).toString();
    print('cartString---${cartString}');
    print('cartList.toString()----${cartList.toString()}');
    prefs.setString('cartInfo', cartString);
    notifyListeners();

  }
  
  remove() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('cartInfo');
    print('清空完成-----------------');
    notifyListeners();
  }
  
  getCartInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //获得购物车中的商品,这时候是一个字符串
    cartString = prefs.getString('cartInfo');
    //把cartList进行初始化，防止数据混乱
    cartList = [];
    //判断得到的字符串是否有值，如果不判断会报错
    if (cartString == null) {
      cartList = [];
    } else {
      List<Map> tempList = (json.decode(cartString.toString()) as List).cast();
      allPrice = 0;
      allGoodsCount = 0;
      isAllCheck = true;
      tempList.forEach((item) {
        if (item['isCheck']) {
          allPrice += (item['count'] * item['price']);
          allGoodsCount += item['count'];
        } else {
          isAllCheck = false;
        }
        cartList.add(CartInfoMode.fromJson(item));
      });
    }
    notifyListeners();

  }

  /// 删除单个购物车商品
  deleteOndGoods(goodsName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString('cartInfo');
    List<Map> tempList = (json.decode(cartString.toString()) as List).cast();

    int tempIndex = 0;
    int delIndex = 0;
    tempList.forEach((item) {
      if (item['goodsName'] == goodsName) {
        delIndex = tempIndex;
      }
      tempIndex++;
    });
    tempList.removeAt(delIndex);
    cartString = json.encode(tempList).toString();
    prefs.setString('cartInfo', cartString);
    await getCartInfo();
  }

  /// 商品单选按钮的交效果
  changeCheckState(CartInfoMode cartItem) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString('cartInfo');
    List<Map> tempList = (json.decode(cartString.toString()) as List).cast();//声明临时List，用于循环，找到修改项的索引
    int tempIndex = 0;//循环使用索引
    int changeIndex = 0;//需要修改的索引
    tempList.forEach((item) {
      if (item['goodsName'] == cartItem.goodsName) {
        changeIndex = tempIndex;
      }
      tempIndex++;
    });
    tempList[changeIndex] = cartItem.toJson();//把对象变成Map值
    cartString = json.encode(tempList).toString();//变成字符串
    prefs.setString('cartInfo', cartString);//进行持久化
    await getCartInfo();//重新读取列表
  }

  /// 点击全选按钮操作
  changeAllCheckBtnState(bool isCheck) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString('cartInfo');
    List<Map> tempList = (json.decode(cartString.toString()) as List).cast();
    List<Map> newList = [];//新建一个List，用于组成新的持久化数据。
    for(var item in tempList){
      var newItem = item;
      newItem['isCheck'] = isCheck;
      newList.add(newItem);
    }
    cartString = json.encode(newList).toString();
    prefs.setString('cartInfo', cartString);
    await getCartInfo();
  }

  /// 商品数量的加减操作
  addOrReduceAction(var cartItem, String todo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    cartString = prefs.getString('cartInfo');
    List<Map> tempList = (json.decode(cartString.toString()) as List).cast();
    int tempIndex = 0;
    int changeIndex = 0;
    tempList.forEach((item) {
      if (item['goodsName'] == cartItem.goodsName) {
        changeIndex = tempIndex;
      }
      tempIndex++;
    });
    if (todo == 'add') {
      cartItem.count++;
    } else if (cartItem.count > 1) {
      cartItem.count--;
    }
    tempList[changeIndex] = cartItem.toJson();
    cartString = json.encode(tempList).toString();
    prefs.setString('cartInfo', cartString);
    await getCartInfo();
  }



}