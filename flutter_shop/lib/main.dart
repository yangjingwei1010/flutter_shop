import 'package:flutter/material.dart';
import 'pages/index_page.dart';
import 'provide/child_category.dart';
import 'package:provide/provide.dart';
import 'provide/category_goods_list.dart';
import 'provide/details_info.dart';
import 'package:fluro/fluro.dart';
import 'routers/routes.dart';
import 'routers/application.dart';
import 'provide/cart.dart';

void main() {
  var childCategory = ChildCategory();
  var categoryGoodsListProvide = CategoryGoodsListProvide();
  var goodsDetail = DetailsInfoProvide();
  var cartProvide = CartProvider();

  var providers = Providers();

  providers
    ..provide(Provider<ChildCategory>.value(childCategory))
    ..provide(Provider<DetailsInfoProvide>.value(goodsDetail))
    ..provide(Provider<CategoryGoodsListProvide>.value(categoryGoodsListProvide))
    ..provide(Provider<CartProvider>.value(cartProvide));
  runApp(ProviderNode(child: MyApp(), providers: providers));

}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final router = Router();
    Routes.configFoundHandler(router);
    Application.router = router;

    return Container(
      child: MaterialApp(
        title: '百姓生活',
        debugShowCheckedModeBanner: false,
        onGenerateRoute: Application.router.generator,
        theme: ThemeData(
          primaryColor: Colors.pink
        ),
        home: IndexPage(),
      ),
    );
  }
}

