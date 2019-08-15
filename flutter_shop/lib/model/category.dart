
/// 最外层list列表
class CategoryBigListModel {
  List<CategoryBigModel> data;

  CategoryBigListModel({
    this.data
  });

  CategoryBigListModel.fromJson(dynamic json) {
    if (json != null) {
      data = List<CategoryBigModel>();
      json.forEach((v) {
        data.add(CategoryBigModel.fromJson(v));
      });
    }
  }
}

/// 左侧一级分类
class CategoryBigModel {
  int mallCategoryId; // 分类编号
  String mallCategoryName; // 类别名称
  List<BxMallSubDto> bxMallSubDto; // 小类列表
  String image; // 类别图片
  String comments; // 列表描述

  CategoryBigModel({
    this.mallCategoryId,
    this.mallCategoryName,
    this.bxMallSubDto,
    this.comments,
    this.image});

  CategoryBigModel.fromJson(dynamic json) {
    mallCategoryId = json['mallCategoryId'];
    mallCategoryName = json['mallCategoryName'];
    if (json['bxMallSubDto'] != null) {
      bxMallSubDto = List<BxMallSubDto>();
      json['bxMallSubDto'].forEach((v) {
        bxMallSubDto.add(BxMallSubDto.fromJson(v));
      });
    }
    comments = json['comments'];
    image = json['image'];
  }

}

/// 顶部二级分类
class BxMallSubDto {
  String mallSubId;
  int mallCategoryId;
  String mallSubName;
  String comments;

  BxMallSubDto({
    this.mallSubId,
    this.mallCategoryId,
    this.mallSubName,
    this.comments
  });

  BxMallSubDto.fromJson(dynamic json) {

    mallSubId = json['mallSubId'];
    mallCategoryId = json['mallCategoryId'];
    mallSubName = json['mallSubName'];
    comments = json['comments'];
  }

}

