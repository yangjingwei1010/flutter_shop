import 'package:dio/dio.dart';
import 'dart:async';
import 'dart:io';
import '../config/service_url.dart';

/// 请求数据统一用下面的这个方法
Future request(url, {formData}) async {
  try {
    print('开始获取数据.........');
    Response response;
    Dio dio = Dio();
    dio.options.contentType = ContentType.parse("application/x-www-form-urlencoded");
    if (formData == null) {
      response = await dio.post(servicePath[url]);
    } else {
      response = await dio.post(servicePath[url], data: formData);
    }
    if (response.statusCode == 200) {
      print('response.data:${response.data}');
      return response.data;
    } else {
      throw Exception('后端接口出现异常，请检测代码和服务器情况.........');
    }
  } catch(e) {
    return print('ERROR:======>${e}');
  }
}

/// get方法获取数据
Future getHomePageBelowContent(url, page, pageSize) async {
  try {
    print('开始获取下拉列表数据.........');
    String urlString = servicePath[url] + '?page=${page}&pageSize=${pageSize}';
    Response response;
    Dio dio = Dio();
    print('urlString:${urlString}');
    dio.options.contentType = ContentType.parse("application/x-www-form-urlencoded");
    response = await dio.get(urlString);
    if (response.statusCode == 200) {
      print('getHomePageBelowContent:${response.data}');
      return response.data;
    } else {
      throw Exception('后端接口出现异常，请检测代码和服务器情况.........');
    }
  } catch(e) {
    return print('ERROR:======>${e}');
  }
}

/// get方法获取数据
Future getMallGoodsList(page, pageSize, categoryId, categorySubId) async {
  try {
    print('开始获取下拉列表数据.........');
    String urlString = servicePath[KGetMallGoods] + '?page=${page}&pageSize=${pageSize}&categoryId=${categoryId}&categorySubId=${categorySubId}';
    Response response;
    Dio dio = Dio();
    print('urlString:${urlString}');
    dio.options.contentType = ContentType.parse("application/x-www-form-urlencoded");
    response = await dio.get(urlString);
    if (response.statusCode == 200) {
      print('getMallGoodsList:${response.data}');
      return response.data;
    } else {
      throw Exception('后端接口出现异常，请检测代码和服务器情况.........');
    }
  } catch(e) {
    return print('ERROR:======>${e}');
  }
}

/// get方法获取数据
Future getGoodsDetail() async {
  try {
    print('开始获取商品详情数据...');
    String urlString = servicePath[KGetGoodDetailById];
    Response response;
    Dio dio = Dio();
    print('urlString:${urlString}');
    dio.options.contentType = ContentType.parse("application/x-www-form-urlencoded");
    response = await dio.get(urlString);
    if (response.statusCode == 200) {
      print('getGoodsDetail:${response.data}');
      return response.data;
    } else {
      throw Exception('后端接口出现异常，请检测代码和服务器情况.........');
    }
  } catch(e) {
    return print('ERROR:======>${e}');
  }
}

/// 首页数据
//Future getHomePageContent() async {
//  try{
//    print('开始获取首页数据...............');
//    Response response;
//    Dio dio = new Dio();
////    dio.options.contentType=ContentType.parse("application/x-www-form-urlencoded");
////    var formData = {'lon':'115.02932','lat':'35.76189'};
//    response = await dio.post(servicePath['homePageContent']);
//    print('response.statusCode:${response.data}');
//    if(response.statusCode==200){
//      return response.data;
//    }else{
//      throw Exception('后端接口出现异常，请检测代码和服务器情况.........');
//    }
//  }catch(e){
//    return print('ERROR:======>${e}');
//  }
//}



