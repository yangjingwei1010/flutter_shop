import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import '../provide/details_info.dart';
import 'details_page/details_top_area.dart';
import 'details_page/detail_explain.dart';
import 'details_page/details_tabbar.dart';
import 'details_page/detail_web.dart';
import 'details_page/details_bottom.dart';

class DetailsPage extends StatelessWidget {
  final String goodsId;
  DetailsPage({this.goodsId});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            print("返回上一页");
            Navigator.pop(context);
          }
        ),
        title: Text('商品详情'),
      ),
      body: FutureBuilder(
        future: _getBackInfo(context),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Stack(
              children: <Widget>[
                ListView(
                  children: <Widget>[
                    // 顶部
                    DetailsTopArea(),
                    // 说明
                    DetailsExplain(),
                    // tabbar详细和评论
                    DetailsTabBar(),
                    // 详情
                    DetailsWeb(),
                  ],
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: DetailsBottom(),
                ),
              ],
              // 如果出现溢出问题，那直接把Column换成ListView就可以了。
            );
          } else {
            return Center(
              child: Text('加载中...'),
            );
          }
        },

      ),
    );
  }

  Future _getBackInfo(BuildContext context) async {
    await Provide.value<DetailsInfoProvide>(context).getGoodsInfo(goodsId);
    return '加载完成';
  }
}
