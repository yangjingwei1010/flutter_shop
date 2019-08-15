import 'package:flutter/material.dart';
import '../service/service_method.dart';
import 'dart:convert';
import '../model/category.dart';
import '../config/service_url.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provide/provide.dart';
import '../provide/child_category.dart';
import '../config/service_url.dart';
import '../model/goods_list_model.dart';
import '../provide/category_goods_list.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import '../config/message_toast.dart';

GlobalKey<RefreshFooterState> _footerKey = new GlobalKey<RefreshFooterState>();

class CategoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('商品分类'),
      ),
      body: Container(
        child: Row(
          children: <Widget>[
            LeftCategoryNav(),
            Column(
              children: <Widget>[
                RightCategoryNav(),
                CategoryGoodList(),
              ],
            ),
          ],
        ),
      ),
    );
  }

}

/// 左侧大类分类
class LeftCategoryNav extends StatefulWidget {
  @override
  _LeftCategoryNavState createState() => _LeftCategoryNavState();
}

class _LeftCategoryNavState extends State<LeftCategoryNav> {
  var list = List<CategoryBigModel>();
  var listIndex = 0;// 索引

  @override
  void initState() {
    // TODO: implement initState
    // 初始化请求默认值
    _getCategory();
    _getGoodsList(0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      width: ScreenUtil().setWidth(180),
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(width: 1,color: Colors.black12)
        )
      ),
      child: ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, index) {
          return _leftInkWell(index);
        },
      ),
    );
  }

  Widget _leftInkWell(int index) {
    bool isClick = false;
    isClick = (index == listIndex) ? true : false;

    return InkWell(
      onTap: (){
        setState(() {
          listIndex = index;
        });

        var childList = List<BxMallSubDto>();
        childList = list[index].bxMallSubDto;

        var categoryId = list[index].mallCategoryId;
        Provide.value<ChildCategory>(context).getChildCategoryList(childList, categoryId);
        _getGoodsList(categoryId);
      },
      child: Container(
        padding: EdgeInsets.only(left: 10, top: 20.0),
        height: ScreenUtil().setHeight(100),
        decoration: BoxDecoration(
          color: isClick ? Color.fromRGBO(236, 238, 239, 1.0) : Colors.white,
          border: Border(
            bottom: BorderSide(width: 1, color: Colors.black12)
          ),
        ),
        child: Text(
          list[index].mallCategoryName,
          style: TextStyle(fontSize: ScreenUtil().setSp(28)),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  // 得到后台大类数据
  void _getCategory() async {
    await getHomePageBelowContent(KGetCategory, 1, 20).then((data){
      CategoryBigListModel category = CategoryBigListModel.fromJson(data['data']);

      setState(() {
        list = category.data;
      });

      Provide.value<ChildCategory>(context).getChildCategoryList(list[0].bxMallSubDto, list[0].mallCategoryId);
    });
  }

  // 获取商品列表数据
  void _getGoodsList(categoryId) async {

    await getMallGoodsList(1, 20, categoryId, '').then((data) {
      CategoryGoodsListModel goodsList = CategoryGoodsListModel.fromJson(data['data']);
      if (goodsList.data == null) {
        Provide.value<CategoryGoodsListProvide>(context).getGoodsList([]);
      } else {
        Provide.value<CategoryGoodsListProvide>(context).getGoodsList(goodsList.data);
      }
    });
  }

}

/// 顶部小类类别
class RightCategoryNav extends StatefulWidget {
  @override
  _RightCategoryNavState createState() => _RightCategoryNavState();
}

class _RightCategoryNavState extends State<RightCategoryNav> {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Provide<ChildCategory>(
        builder: (context, child, childCategory) {
          return Container(
            height: ScreenUtil().setHeight(80),
            width: ScreenUtil().setWidth(570),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(width: 1, color: Colors.black12),
              )
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: childCategory.childCategoryList.length,
              itemBuilder: (context, index) {
                return _rightInkWell(index, childCategory.childCategoryList[index]);
              },
            ),
          );
        },
      ),
    );
  }

  Widget _rightInkWell(int index, BxMallSubDto item) {
    bool isClick = false;
    isClick = (index == Provide.value<ChildCategory>(context).childIndex ? true : false);

    return InkWell(
      onTap: (){
        Provide.value<ChildCategory>(context).changeChildIndex(index, 0);
        _getGoodsList(item.mallSubId);
      },
      child: Container(
        width: 100,
//        padding: EdgeInsets.fromLTRB(5.0, 15.0, 5.0, 10.0),
        decoration: BoxDecoration(
          color: isClick ? Colors.pink : Colors.white,
          border: Border(
            right: BorderSide(width: 1, color: Colors.black12)
          ),
        ),
        child: Center(
          child: Text(
            item.mallSubName,
            style: TextStyle(fontSize: ScreenUtil().setSp(28),),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  // 获取商品列表数据
  void _getGoodsList(categorySubId) async {
    var categoryId = Provide.value<ChildCategory>(context).categoryId;
    await getMallGoodsList(1, 20, categoryId, categorySubId).then((data) {
      CategoryGoodsListModel goodsList = CategoryGoodsListModel.fromJson(data['data']);
      if (goodsList.data == null) {
        Provide.value<CategoryGoodsListProvide>(context).getGoodsList([]);
      } else {
        Provide.value<CategoryGoodsListProvide>(context).getGoodsList(goodsList.data);
      }
    });
  }

}

/// 商品列表
class CategoryGoodList extends StatefulWidget {
  @override
  _CategoryGoodListState createState() => _CategoryGoodListState();
}

class _CategoryGoodListState extends State<CategoryGoodList> {
  var scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Provide<CategoryGoodsListProvide>(
      builder: (context, child, data) {
        try {
          if(Provide.value<ChildCategory>(context).page == 1) {
            // 切换跳到顶部
            scrollController.jumpTo(0.0);
          }
        } catch(e) {
          print('进行第一次初始化：${e}');
        }

        if (data.goodsList.length > 0) {
          return Expanded(
            child: Container(
              width: ScreenUtil().setWidth(570),
              child: EasyRefresh(
                refreshFooter: ClassicsFooter(
                  key: _footerKey,
                  bgColor: Colors.white,
                  textColor:Colors.pink,
                  moreInfoColor: Colors.pink,
                  showMore: true,
                  noMoreText: Provide.value<ChildCategory>(context).noMoreText,
                  moreInfo: '加载中...',
                  loadReadyText: '上拉加载',
                ),
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: data.goodsList.length,
                  itemBuilder: (context, index) {
                    return _listWidget(data.goodsList, index);
                  },
                ),
                loadMore: ()async{
                  _getMoreList();
                },
              ),
            ),
          );
        } else {
          return Text('暂时没有数据');
        }
      },
    );

  }

  // listView
  Widget _listWidget(List newList, int index) {
    return InkWell(
      onTap: (){
        MessageToast.showToast();
      },
      child: Container(
        padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(width: 1.0, color: Colors.black12),
            )
        ),
        child: Row(
          children: <Widget>[
            _goodsImage(newList, index),
            Column(
              children: <Widget>[
                _goodsName(newList, index),
                _goodsPrice(newList, index),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 图片
  Widget _goodsImage(List newList, int index) {
    return Container(
      width: ScreenUtil().setWidth(200),
      child: Image.network(newList[index].image),
    );
  }

  // 商品名称
  Widget _goodsName(List newList, int index) {
    return Container(
      padding: EdgeInsets.all(5.0),
      width: ScreenUtil().setWidth(370),
      child: Text(
        newList[index].goodsName,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: ScreenUtil().setSp(28)),
      ),
    );
  }

  // 商品价格
  Widget _goodsPrice(List newList, int index) {
    return Container(
      margin: EdgeInsets.only(top: 20.0),
      width: ScreenUtil().setWidth(370),
      child: Row(
        children: <Widget>[
          Text(
            '价格:¥${newList[index].presentPrice}',
            style: TextStyle(color: Colors.pink, fontSize: ScreenUtil().setSp(30)),
          ),
          Text(
            '¥${newList[index].oriPrice}',
            style: TextStyle(
              color: Colors.black26,
              decoration: TextDecoration.lineThrough
            ),
          ),
        ],
      ),
    );
  }

  void _getMoreList() async {
    Provide.value<ChildCategory>(context).addPage();
    int categoryId = Provide.value<ChildCategory>(context).categoryId;
    int categorySubId = Provide.value<ChildCategory>(context).subId;
    int page = Provide.value<ChildCategory>(context).page;

    await getMallGoodsList(page, 20, categoryId, categorySubId).then((data){
      CategoryGoodsListModel goodsList = CategoryGoodsListModel.fromJson(data['data']);
      if (goodsList.data == null) {
        Provide.value<ChildCategory>(context).changeMore('没有更多了');
        MessageToast.showToast();
      } else {
        Provide.value<ChildCategory>(context).changeMore('加载成功');
        Provide.value<CategoryGoodsListProvide>(context).getMoreGoodsList(goodsList.data);
      }
    });

  }

}




