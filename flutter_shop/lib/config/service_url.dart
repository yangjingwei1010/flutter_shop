
const KHomePageContent = 'homePageContent';
const KHomePageBelowContent = 'homePageBelowContent';
const KGetCategory = 'getCategory';
const KGetMallGoods = 'getMallGoods';
const KGetGoodDetailById = 'getGoodDetailById';

/// 首页地址
//const serviceURL = 'http://test.baixingliangfan.cn/baixing/';
const serviceURL = 'https://easy-mock.com/mock/5cd7f2932be2486a36af3e90';
const servicePath = {
  /// 商家首页信息
  'homePageContent': serviceURL + '/wxmini/homePageContent',// 首页数据
  /// 火爆专区list数据
  'homePageBelowContent': serviceURL+'/wxmini/homePageBelowContent', //商城首页热卖商品拉取
  /// 分类列表
  'getCategory': serviceURL+'/wxmini/getCategory', //商品类别信息
  /// 商品分类的商品列表
  'getMallGoods': serviceURL+'/wxmini/getMallGoods', //商品分类的商品列表
  /// 商品详情
  'getGoodDetailById': serviceURL+'/wxmini/getGoodDetail', //商品详情

};