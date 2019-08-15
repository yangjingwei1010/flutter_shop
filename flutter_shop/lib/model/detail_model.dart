

class DetailsModel {
  DetailsGoodsData data;

  DetailsModel({this.data});

  DetailsModel.fromJson(dynamic json) {
    data = json != null ? DetailsGoodsData.fromJson(json) : null;
  }

}

class DetailsGoodsData {
  GoodInfo goodInfo;
  List<GoodComments> goodComments;
  AdvertesPicture advertesPicture;

  DetailsGoodsData({this.goodInfo, this.goodComments, this.advertesPicture});

  DetailsGoodsData.fromJson(dynamic json) {
    goodInfo = json['goodInfo'] != null ? GoodInfo.fromJson(json['goodInfo']) : null;
    if (json['goodComments'] != null) {
      goodComments = List<GoodComments>();
      json['goodComments'].forEach((v) {
        goodComments.add(GoodComments.fromJson(v));
      });
    }
    advertesPicture = json['advertesPicture'] != null ? AdvertesPicture.fromJson(json['advertesPicture']) : null;
  }

}

class GoodInfo {
  String image5;
  int amount;
  String image3;
  String image4;
  String goodsId;
  String isOnline;
  String image1;
  String image2;
  String goodsSerialNumber;
  double oriPrice;
  double presentPrice;
  String comPic;
  int state;
  String shopId;
  String goodsName;
  String goodsDetail;

  GoodInfo({
    this.image5,
    this.amount,
    this.image3,
    this.image4,
    this.goodsId,
    this.isOnline,
    this.image1,
    this.image2,
    this.goodsSerialNumber,
    this.oriPrice,
    this.presentPrice,
    this.comPic,
    this.state,
    this.shopId,
    this.goodsName,
    this.goodsDetail});

  GoodInfo.fromJson(dynamic json) {
    image5 = json['image5'];
    amount = json['amount'];
    image3 = json['image3'];
    image4 = json['image4'];
    goodsId = json['goodsId'];
    isOnline = json['isOnline'];
    image1 = json['image1'];
    image2 = json['image2'];
    goodsSerialNumber = json['goodsSerialNumber'];
    oriPrice = json['oriPrice'];
    presentPrice = json['presentPrice'];
    comPic = json['comPic'];
    state = json['state'];
    shopId = json['shopId'];
    goodsName = json['goodsName'];
    goodsDetail = json['goodsDetail'];
  }

}

class GoodComments {
  String score;
  String comments;
  String userName;
  String discussTime;

  GoodComments({this.score, this.comments, this.userName, this.discussTime});

  GoodComments.fromJson(dynamic json) {
    score = json['SCORE'];
    comments = json['comments'];
    userName = json['userName'];
    discussTime = json['discussTime'];
  }

}

class AdvertesPicture {
  String pICTUREADDRESS;
  String tOPLACE;

  AdvertesPicture({this.pICTUREADDRESS, this.tOPLACE});

  AdvertesPicture.fromJson(Map<String, dynamic> json) {
    pICTUREADDRESS = json['PICTURE_ADDRESS'];
    tOPLACE = json['TO_PLACE'];
  }

}