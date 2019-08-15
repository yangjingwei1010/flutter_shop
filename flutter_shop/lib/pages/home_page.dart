import 'package:flutter/material.dart';
import '../service/service_method.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';
import '../config/service_url.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import '../routers/application.dart';

GlobalKey<RefreshFooterState> _footerKey = new GlobalKey<RefreshFooterState>();

class HomePage extends StatefulWidget {
  _HomePageState createState() => _HomePageState();

}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
  int page = 1;
  List<Map> hotGoodsList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('11111111111111');
    _getHotGoods();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    print('设备宽度:${ScreenUtil.screenWidth}');
    print('设备高度:${ScreenUtil.screenHeight}');
    print('设备像素密度:${ScreenUtil.pixelRatio}');
    
    return Scaffold(
        appBar: AppBar(title: Text('百姓生活+'),),
        body:FutureBuilder(
          future:request(KHomePageContent),
          builder: (context,snapshot){
            if(snapshot.hasData){
              var data= snapshot.data;
              List<Map> swiperDataList = (data['data']['slides'] as List).cast(); // 顶部轮播组件数
              List<Map> navigatorList = (data['data']['category'] as List).cast();// 类别列表
              if(navigatorList.length > 10) {
                navigatorList.removeRange(10, navigatorList.length);
              }
              String advertisePicture = data['data']['advertisePicture']['PICTURE_ADDRESS'];// 广告图片
              String leaderImage = data['data']['shopInfo']['leaderImage'];// 店长图片
              String leaderPhone = data['data']['shopInfo']['leaderPhone'];// 店长电话
              List<Map> recomendList = (data['data']['recommend'] as List).cast();// 商品推荐
              String floor1Title = data['data']['floor1Pic']['PICTURE_ADDRESS'];// 楼层1标题图片
              String floor2Title = data['data']['floor2Pic']['PICTURE_ADDRESS'];// 楼层2标题图片
              String floor3Title = data['data']['floor3Pic']['PICTURE_ADDRESS'];// 楼层3标题图片
              List<Map> floor1 = (data['data']['floor1'] as List).cast();// 楼层1商品和图片
              List<Map> floor2 = (data['data']['floor2'] as List).cast();// 楼层2商品和图片
              List<Map> floor3 = (data['data']['floor3'] as List).cast();// 楼层3商品和图片

              return EasyRefresh(
                child: ListView(
                  children: <Widget>[
                    SwiperDiy(swiperDataList:swiperDataList ),   // 页面顶部轮播组件
                    TopNavigator(navigatorList: navigatorList),  // 导航栏
                    ADBanner(advertisPicture: advertisePicture),  // 广告图片
                    LeaderPhone(leaderImage: leaderImage, leaderPhone: leaderPhone,), // 店长电话
                    Recomend(recomendList: recomendList,),
                    FloorTitle(picture_address: floor1Title,),
                    FloorContent(floorGoodsList: floor1,),
                    FloorTitle(picture_address: floor2Title,),
                    FloorContent(floorGoodsList: floor2,),
                    FloorTitle(picture_address: floor3Title,),
                    FloorContent(floorGoodsList: floor3,),
                    HotGoods(hotGoodsList: hotGoodsList,),
                  ],
                ),

                refreshFooter: ClassicsFooter(
                  key: _footerKey,
                  bgColor: Colors.white,
                  textColor: Colors.pink,
                  moreInfoColor: Colors.pink,
                  showMore: true,
                  moreInfo: '加载中..',
                  loadReadyText: '上拉加载...',
                  noMoreText: '加载成功',
                ),

                loadMore: ()async{
                  print('开始加载更多');
                  _getHotGoods();
                },
              );
            }else{
              return Center(
                child: Text('加载中'),
              );
            }
          },
        )
    );

  }

  void _getHotGoods() async {

    await getHomePageBelowContent(KHomePageBelowContent,page, 10).then((data) {
      print('data:${data}');
      List<Map> newGoodsList = (data['data'] as List).cast();
      setState(() {
        hotGoodsList.addAll(newGoodsList);
        page++;
      });
    });
  }
}

/// 首页轮播组件编写
class SwiperDiy extends StatelessWidget {
  final List swiperDataList;
  SwiperDiy({Key key,this.swiperDataList}):super(key:key);

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    return Container(
      height: ScreenUtil().setHeight(400.0),
      width: ScreenUtil.screenWidth,
      child: Swiper(
        itemBuilder: (BuildContext context,int index){
          return InkWell(
            onTap: () {
              Application.router.navigateTo(context, '/detail?id=${swiperDataList[index]['goodsId']}');
            },
            child: Image.network("${swiperDataList[index]['image']}",fit:BoxFit.fill),
          );
        },
        itemCount: swiperDataList.length,
        pagination: new SwiperPagination(),
        autoplay: true,
      ),
    );
  }
}

/// 导航栏
class TopNavigator extends StatelessWidget {
  final List navigatorList;
  TopNavigator({Key key, this.navigatorList}): super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 180,
      padding: EdgeInsets.all(3.0),
      child: GridView.count(
        crossAxisCount: 5,
        padding: EdgeInsets.all(4.0),
        physics: NeverScrollableScrollPhysics(),
        children: navigatorList.map((item){
          return _gridViewItemUI(context, item);
        }).toList(),
      ),
    );
  }
  
  Widget _gridViewItemUI(BuildContext contenxt, item) {
    return InkWell(
      onTap: (){print('点击了导航');},
      child: Column(
        children: <Widget>[
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              image: DecorationImage(
                image: NetworkImage(item['image']),
                fit: BoxFit.cover
              )
            ),
          ),
//          Image.network(item['image'], width: ScreenUtil().setWidth(90),),
          Text(item['mallCategoryName'])
        ],
      ),
    );
  }
}

/// 广告图片
class ADBanner extends StatelessWidget {
  final String advertisPicture;
  ADBanner({Key key, this.advertisPicture}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
//      margin: EdgeInsets.only(top: 0.0),
      child: Image.network(advertisPicture),
    );
  }
}

/// 拨打电话
class LeaderPhone extends StatelessWidget {
  final String leaderImage; // 店长图片
  final String leaderPhone; // 店长电话
  LeaderPhone({Key key, this.leaderImage, this.leaderPhone}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      height: ScreenUtil().setHeight(200),
      width: ScreenUtil.screenWidth,
      margin: EdgeInsets.only(top: 20),
      child: InkWell(
        onTap: _launchURL,
        child: Image.network(leaderImage),
      ),
    );
  }

  void _launchURL() async {
    String url = 'tel:' + leaderPhone;
    if(await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch ${url}';
    }
  }
}

/// 推荐商品
class Recomend extends StatelessWidget {
  final List recomendList;
  Recomend({Key key, this.recomendList}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil().setHeight(420),
      margin: EdgeInsets.only(top: 10.0),
      child: Column(
        children: <Widget>[
          EveryTitle(title: '推荐商品',),
          _recomendList(context)
        ],
      ),
    );
  }

  // 横向列表组件
  Widget _recomendList(context) {
    return Container(
      height: ScreenUtil().setHeight(350),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: recomendList.length,
        itemBuilder: (context, index) {
          return _item(context, index);
        },
      ),
    );
  }

  // 推荐商品单独项编写
  Widget _item(context, index) {
    return InkWell(
      onTap: (){
        print('点击了推荐商品');
        Application.router.navigateTo(context, 'detail?id=${recomendList[index]['goodsId']}');
      },
      child: Container(
        width: ScreenUtil().setWidth(250),
        padding: EdgeInsets.only(right: 6.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            left: BorderSide(width: 0.5, color: Colors.black12)
          )
        ),
        child: Column(
          children: <Widget>[
            Container(
              height: ScreenUtil().setHeight(250),
              width: ScreenUtil().setWidth(250),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(recomendList[index]['image']),
                    fit: BoxFit.fill
                )
              ),
            ),

            Text('¥${recomendList[index]['mallPrice']}'),
            Text(
              '¥${recomendList[index]['price']}',
              style: TextStyle(
                decoration: TextDecoration.lineThrough,
                color: Colors.grey
              ),
            ),
          ],
        ),
      ),
    );
  }

}

///楼层布局
class FloorTitle extends StatelessWidget {
  final String picture_address;// 图片地址
  FloorTitle({Key key, this.picture_address}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
//      child: Image.network(picture_address),
      height: ScreenUtil().setHeight(600),
      margin: EdgeInsets.only(top: 10.0),
      child: Column(
        children: <Widget>[
          EveryTitle(title: '楼层数据',),
          Image.network(picture_address),
        ],
      ),
    );
  }

}
class FloorContent extends StatelessWidget {
  final List floorGoodsList;
  FloorContent({Key key, this.floorGoodsList}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          _firstRow(context),
          _otherGoods(context),
        ],
      ),
    );
  }

  Widget _firstRow(context){
    return Row(
      children: <Widget>[
        _goodsItem(context, floorGoodsList[0]),// 左边的一个图片
        Column(
          children: <Widget>[// 右边的一列图片（2张）
            _goodsItem(context, floorGoodsList[1]),
            _goodsItem(context, floorGoodsList[2]),
          ],
        ),
      ],
    );
  }

  Widget _otherGoods(context){
    return Row(
      children: <Widget>[// 一行图片（2张）
        _goodsItem(context, floorGoodsList[3]),
        _goodsItem(context, floorGoodsList[4]),
      ],
    );
  }

  Widget _goodsItem(context, Map goods){
    return Container(
      width: ScreenUtil().setWidth(375),
      padding: EdgeInsets.all(5.0),
      child: InkWell(
        onTap: (){
          print('点击了楼层');
          Application.router.navigateTo(context, 'detail?id=${goods['goodsId']}');
        },
        child: Image.network(goods['image']),
      ),
    );
  }
}

/// 火爆专区
class HotGoods extends StatefulWidget {
  final hotGoodsList;
  HotGoods({this.hotGoodsList});

  @override
  _HotGoodsState createState() => _HotGoodsState();
}
class _HotGoodsState extends State<HotGoods> {
  // 因为首页我们采用StatefulWidget的方法，所以把标题写在内部。这次我们不采用方法返回Widget的方法了，而是采用变量的方法。
  // 火爆专区标题
  Widget hotTitle = Container(
    margin: EdgeInsets.only(top: 10.0),
    padding: EdgeInsets.all(5.0),
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border(
        bottom: BorderSide(width: 0.5, color: Colors.black12),
      )
    ),
    child: Text('火爆专区'),
  );

  @override
  Widget build(BuildContext context) {
    print('widget.hotGoodsList:${widget.hotGoodsList}');
    return Container(
        child:Column(
          children: <Widget>[
            hotTitle,
            _wrapList(),
          ],
        )
    );
  }

  Widget _wrapList() {

    if (widget.hotGoodsList.length != 0) {
      List<Widget> listWidget = widget.hotGoodsList.map<Widget>((val) {
        return InkWell(
          onTap: (){
            print('点击了火爆商品');
            Application.router.navigateTo(context, '/detail?id=${val['goodsId']}');
          },
          child: Container(
            width: ScreenUtil().setWidth(372),
            color: Colors.white,
            padding: EdgeInsets.all(5.0),
            margin: EdgeInsets.only(bottom: 3.0),
            child: Column(
              children: <Widget>[
                Image.network(val['image'], width: ScreenUtil().setWidth(375),),
                Text(
                  val['name'],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: Colors.pink,fontSize: ScreenUtil().setSp(26)),
                ),
                Row(
                  children: <Widget>[
                    Text('¥${val['mallPrice']}'),
                    Text(
                      '¥${val['price']}',
                      style: TextStyle(color: Colors.black26, decoration: TextDecoration.lineThrough),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }).toList();

      return Wrap(
        spacing: 2,
        children: listWidget,
      );
    } else {
      return Text(' ');
    }
  }
}


/// 抽取组件
class EveryTitle extends StatelessWidget {
  String title;
  EveryTitle({Key key, this.title}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.fromLTRB(10.0, 2.0, 0, 5.0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
            bottom: BorderSide(width: 0.5, color: Colors.black12)
        ),
      ),
      child: Text(
        title,
        style: TextStyle(color: Colors.pink),
      ),
    );
  }
}


