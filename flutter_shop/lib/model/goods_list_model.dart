

class CategoryGoodsListModel {
  List<CategoryListData> data;

  CategoryGoodsListModel({this.data});

  CategoryGoodsListModel.fromJson(dynamic json) {
    if (json != null) {
      data = List<CategoryListData>();
      json.forEach((v){
        data.add(CategoryListData.fromJson(v));
      });
    }
  }
}

class CategoryListData {
  String image;
  double oriPrice;
  double presentPrice;
  String goodsName;
  String goodsId;

  CategoryListData({
    this.image,
    this.oriPrice,
    this.presentPrice,
    this.goodsId,
    this.goodsName,
  });

  CategoryListData.fromJson(dynamic json) {
    image = json['image'];
    oriPrice = json['oriPrice'];
    presentPrice = json['presentPrice'];
    goodsName = json['goodsName'];
    goodsId = json['goodsId'];
  }
}