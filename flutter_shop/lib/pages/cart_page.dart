import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provide/provide.dart';
import '../provide/cart.dart';
import './cart_page/cart_item.dart';
import './cart_page/cart_bottom.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('购物车'),
      ),
      body: FutureBuilder(
        future: _getCartInfo(context),
        builder: (context, snapshot) {
          List cartList = Provide.value<CartProvider>(context).cartList;
          if(snapshot.hasData && cartList != null) {
            return Stack(
              children: <Widget>[
                Provide<CartProvider>(
                  builder: (context, child, childCategory){
                    cartList = Provide.value<CartProvider>(context).cartList;
                    print('cartList-----${cartList}');
                    return ListView.builder(
                      itemCount: cartList.length,
                      itemBuilder: (context, index) {
                        return CartItem(cartList[index]);
                      },
                    );
                  },
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: CartBottom(),
                )
              ],
            );
          } else {
            return Text('正在加载');
          }
        },
      ),
    );
  }
  
  Future<String> _getCartInfo(context) async {
    await Provide.value<CartProvider>(context).getCartInfo();
    return 'end';
  }
}

