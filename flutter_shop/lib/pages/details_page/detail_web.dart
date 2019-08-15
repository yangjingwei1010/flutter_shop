import 'package:flutter/material.dart';
import 'package:provide/provide.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../provide/details_info.dart';
import 'package:flutter_html/flutter_html.dart';

class DetailsWeb extends StatelessWidget {
//  var scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    var goodsDetail = Provide.value<DetailsInfoProvide>(context).goodsInfo.data.goodInfo.goodsDetail;
    var goodsComments = Provide.value<DetailsInfoProvide>(context).goodsInfo.data.goodComments;

    return Provide<DetailsInfoProvide>(
      builder: (context, child, val) {
        var isLeft = Provide.value<DetailsInfoProvide>(context).isLeft;
        if (isLeft) {
          return Container(
            child: Html(data: goodsDetail),
          );
        } else {
          return Container(
              width: ScreenUtil().setWidth(750),
              padding: EdgeInsets.all(10.0),
              alignment: Alignment.center,
              child: ListView.builder(
//                controller: scrollController,
                itemCount: goodsComments.length,
                itemBuilder: (context, index) {
                  return Text('ceshi');
                },
              ),
//            child: Column(
//              children: <Widget>[
//                Text(goodsComments[0].userName),
//                Text(goodsComments[0].comments),
//                Text(goodsComments[0].discussTime),
//                Text(goodsComments[0].score),
//              ],
//            ),
            );


        }
      },
    );
  }

  Widget _listWiget(comments, index) {
    return Container(

//      child: Column(
//        children: <Widget>[
////          int sCORE;
////          String comments;
////          String userName;
////          String discussTime;
//          Text(comments[index].userName),
//          Text(comments[index].comments),
//          Text(comments[index].discussTime),
//          Text(comments[index].sCORE),
//        ],
//      ),
    );
  }
}
