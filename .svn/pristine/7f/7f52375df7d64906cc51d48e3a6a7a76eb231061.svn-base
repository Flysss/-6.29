//
//  RequestInterface.h
//  SalesHelper_C
//
//  Created by summer on 14/11/3.
//  Copyright (c) 2014年 X. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSString *FreePhoneId = @"4506";

typedef void(^GetRequestBlock)(id data);
typedef void(^FailRequstBlock)(NSError *error);

#define FreePhoneRequestHost @"o1.cc/cellphoneservice/"


@interface RequestInterface : NSObject
{
    GetRequestBlock _getRequestBlock;
    FailRequstBlock _failRequestBlock;
    NSString *boundary;
}
@property (nonatomic,assign)BOOL cachDisk;


-(void)getInterfaceRequestObject:(GetRequestBlock)getRequestBlock Fail:(FailRequstBlock)failRequestBlock;
/**
 *  首页轮播图
 *
 */
- (void)requestGetqueryHeads:(NSDictionary *)param;

/**
 *  获取推荐记录明细
 *
 */
- (void)requestGetqueryRecStageInfos:(NSDictionary *)param;

#pragma mark - request detail    每个请求的实现方法
//所有请求的接口
/**
 *版本检测
 */
-(void)requestUpGrateAppInterface;

/**
 *活动图片接口
 */
-(void)requestMGetAdsNWithParam:(NSDictionary *)dic;

/**
 *1.注册发送验证码接口
 */
-(void)requestRegisterSendSMSWithParam:(NSDictionary *)dic;

/**
 *2.注册接口
 */
-(void)requestRegisterWithParam:(NSDictionary *)dic;

/**
 *从服务端获取，是否显示邀请赚钱、分享赚钱
 */
-(void)ShowZhuanQian;
/**
 *3.登录接口
 */
-(void)requestLoginWithParam:(NSDictionary *)dic;

/**
 *4.忘记密码发送验证码接口
 */
-(void)requestForgetpwdSendSMSWithParam:(NSDictionary *)dic;

/**
 *5.设置新密码接口
 */
-(void)requestSetpwdWithParam:(NSDictionary *)dic;

/**
 *6.楼盘信息接口
 */
-(void)requestGetPropertyInfosWithParam:(NSDictionary *)dic;
/**
 *  楼盘详情接口
 *
 *  @param infoID 楼盘ID
 */
-(void)requestGetPropertyInfosWithPropertyInfoID:(NSString *)infoID;

/**
 *7.面积、价格标题接口
 */
-(void)requestGetHouseAttributeWithParam:(NSDictionary *)dic;

/**
 *8.区域查询接口
 */
-(void)requestGetDistrictWithParam:(NSDictionary *)dic;

/**
 *9.推荐接口
 */
-(void)requestAddRecWithParam:(NSDictionary *)dic;

/**
 *10.查询客户推荐进度接口
 */
-(void)requestGetRecRecordPWithParam:(NSDictionary *)dic;

/**
 *11.投诉建议接口
 */
-(void)requestAddVadvWithParam:(NSDictionary *)dic;

/**
 *12.查询推荐记录接口
 */
-(void)requestGetRecRecordByCWithParam:(NSDictionary *)dic;

/**
 *13.修改登录密码接口
 */
-(void)requestUpdatePwdWithParam:(NSDictionary *)dic;

/**
 *14.查询佣金明细接口
 */
-(void)requestGetRewardDByRWithParam:(NSDictionary *)dic;

/**
 *15.查询佣金信息接口
 */
-(void)requestGetRewardByRWithParam:(NSDictionary *)dic;
-(void)requestRewardTypeWithparam:(NSDictionary* )dic;

/**
 *16.添加提现账户接口
 */
-(void)requestAddWithdWithParam:(NSDictionary *)dic;

//#pragma mark 获取全部 银行卡
-(void)requestGetAllbankWithParam:(NSDictionary* )dic;

/**
 *17.查询提现账户接口
 */
-(void)requestGetWithdWithParam:(NSDictionary *)dic;

/**
 *18.提现接口
 */
-(void)requestSubWithdWithParam:(NSDictionary *)dic;

/**
 *19.设置提现密码接口
 */
-(void)requestSetWithdPwdWithParam:(NSDictionary *)dic;

/**
 *20.修改提现密码接口
 */
-(void)requestModWithdPwdWithParam:(NSDictionary *)dic;

/**
 *21.忘记提现密码接口
 */
-(void)requestforgetWithpwdWithParam:(NSDictionary *)dic;

/**
 *22.删除提现账户接口
 */
-(void)requestDeleteWithdWithParam:(NSDictionary *)dic;

/**
 *23.修改提现账户接口
 */
-(void)requestModWithdWithParam:(NSDictionary *)dic;

/**
 *24.分享加钱接口
 */
-(void)requestShareAddWithParam:(NSDictionary *)dic;

/**
 *25.查询提现记录接口
 */
-(void)requestGetWithdRecordWithParam:(NSDictionary *)dic;
/**
 *26.申述接口
 */
-(void)requestSubAppealWithParam:(NSDictionary *)dic;
/**
 *27.查看申述记录接口
 */
-(void)requestGetAppealRecByCWithParam:(NSDictionary *)dic;
/**
 *28.请求上传头像
 */
-(void)requestUploadAvatarInterfaceWithImage:(UIImage *)image token:(NSString *)token user_version:(NSString *)user_version;
//
//-(void)requestUploadHeadImagewithImage:(UIImage* )image;

//
-(void)requestsaveMyInfoWithtoken:(NSDictionary *)dic;
/**
 *29.查看分享列表接口
 */
-(void)requestGetShareListWithParam:(NSDictionary *)dic;

/**
 *30.退出接口
 */
-(void)requestLogOutWithParam:(NSDictionary *)dic;

/**
 *31.查询个人信息
 */
-(void)requestGetReferInfoWithParam:(NSDictionary *)dic;
-(void)requestyunyingCitywithdic:(NSDictionary* )dic;

/**
 *32.修改个人信息
 */
-(void)requestUpdateReferInfoWithParam:(NSDictionary *)dic;

/**
 *33.获取分享明细
 */
-(void)requestGetShareRecWithParam:(NSDictionary *)dic;

/**
 *34.分享赚钱
 */
-(void)requestAddShareRecWithParam:(NSDictionary *)dic;

/**
 *35.公告接口
 */
-(void)requestGetAnnounceListWithParam:(NSDictionary *)dic;

/**
 *36.推送registrationID
 */
-(void)requestGetSetRegistIDWithParam:(NSDictionary *)dic;

/**
 *  搜索页面查询接口
 *
 */
-(void)requestGetSearchIDWithParam:(NSDictionary *)dic;
/**
 *  查询物业类型
 *
 */
-(void)requestGetEstateState;
/**
 *  查询公告接口
 *
 */
- (void)requestGetBulletinWithDic:(NSDictionary *)param;
#pragma mark 省钱电话

/**
 * 打电话
 */
-(void)freePhoneCallWithCallKey:(NSString *)key Called:(NSString *)called Token:(NSString *)token;

/**
 *  查询客户属性
 *
 */

- (void)requestGetCustomerPropertyWithParam:(NSDictionary *)dic;

/**
 *  查询客户被推荐楼盘信息
 *
 */
- (void)requestGetCustomerQueryRecWithParam:(NSDictionary *)dic;
/**
 *  发现首页数据接口
 */
-  (void)requestGEtDisCover;
/**
 *  我的分享赚钱
 */
- (void)requestForMoney;
/**
 *  我的带看
 */
- (void)requestTakeLookWithParam:(NSDictionary *)dic;

/**
 *  绑定解绑机构码
 */
- (void)requestOrgCodeWithParam:(NSDictionary *)dic;

/**
 *  我的团队查找下线
 */
- (void)requestMyTeamWithParam:(NSDictionary *)dic;

/**
 *  我的团队推荐记录
 */
- (void)requestMyTeamCustmerWithParam:(NSDictionary *)dic;

/**
 *  客户首页客户数量接口
 */
- (void)requestMyCustmorsHomePageCustmorCounts:(NSString *)token;
/**
 *  客户通讯录接口
 */
- (void)requestMyCustmorsManagerWithToken:(NSString *)token;
/**
 *  新增客户
 */
- (void)addClientsWithInfos:(NSDictionary *)dic;

/**
 *  搜索客户
 */
- (void)requestMyCustmorSearchWith:(NSDictionary *)dic;

/**
 *  修改客户信息
 */
- (void)requestEditClientsWithInfos:(NSDictionary *)dic;

/**
 *  查询跟进记录
 */
- (void)requestFollowUpDatasWith:(NSDictionary *)dic;
/**
 *  上传语音
 */
-(void)requestUploadAvatarInterfaceWithNSData:(NSData *)recordData;
/**
 *  新增跟进记录
 */
- (void)requestAddFollowUpWithDict:(NSDictionary *)dic;
/**
 *  消息记录列表
 */
- (void)requestMessageListWithDict:(NSDictionary *)dic;

//通过城市查询城市ID
-(void)requestGetLocationCityWithParam:(NSDictionary *)dic;

//首页根据地图大头针显示楼盘
//-(void)requestPropertiesFromAnnotationSearch:(NSString*)cityID;

#pragma mark --搜索 推荐记录
- (void)requestSearchRecommentWithDic:(NSDictionary *)dic;

#pragma mark --二手房下拉数据
- (void)requestTwohandSubTabWithDic:(NSDictionary *)dic;

#pragma mark --二手房首页列表
- (void)requestTwohandMainTabWithDic:(NSDictionary *)dic;

#pragma mark --地图大头针搜索楼盘
-(void)requestPropertiesFromAnnotationSearch:(NSString*)cityID;
#pragma mark --二手房详情页面
- (void)requestTwohandDetailWithDic:(NSDictionary *)dic;
#pragma mark --二手房热门搜索关键词
- (void)requestTwohandSearchHotWord;
#pragma mark --二手房搜索
- (void)requestTwohandSearchWithDic:(NSDictionary *)dic;
#pragma mark --申请到访记录
- (void)requestVisitHostoryWithDic:(NSDictionary *)dic;
#pragma mark --申请到访 选择列表
- (void)requestVisitSelectClientWithDic:(NSDictionary *)dic;
#pragma mark --申请到访 提交申请
- (void)requestVisitSendApplyWithDic:(NSDictionary *)dic;

#pragma mark --申请到访 提交申请
- (void)requestSharedSuccessWithDic:(NSDictionary *)dic;

/**
 *  邦会个人信息
 */
- (void)requestBHPersonalCenterWithDic:(NSDictionary *)dic;
/**
 * 邦会个人信息关注接口
 */
- (void)requestBHGuanZhuWithDic:(NSDictionary *)dic;
/**
 * 邦会个人信息我的粉丝接口
 */
- (void)requestBHMyFansWithDic:(NSDictionary *)dic;
/**
 * 邦会个人信息我的关注接口
 */
- (void)requestBHMyFocusWithDic:(NSDictionary *)dic;
/**
 * 邦会个人信息我的回复接口
 */
- (void)requestBHReplyWithDic:(NSDictionary *)dic;
/**
 * 邦会个人信息我的发帖接口
 */
- (void)requestBHPostsWithDic:(NSDictionary *)dic;
/**
 *  邦会左边抽屉的接口
 */
- (void)requestBHLeftDataWith:(NSDictionary *)dic;
/**
 *  邦会赞过的人页面接口
 */
- (void)requestLikeListWithDic:(NSDictionary *)dic;
/**
 *  邦会首页列表接口
 */
- (void)requestBHFirstListWithDic:(NSDictionary *)dic;
/**
 *  邦会关注的人的帖子列表接口
 */
- (void)requestBHGuanzhuListWithDic:(NSDictionary *)dic;
/**
 *  邦会圈子列表接口
 */
- (void)requestBHCircleListWithDic:(NSDictionary *)dic;
/**
 *  邦会话题列表接口
 */
- (void)requestBHHuaTiListWithDic:(NSDictionary *)dic;
/**
 *  邦会评论列表接口
 */
- (void)requestBHGongGaoWithDic:(NSDictionary *)dic;

/**
 *  邦会帖子公告话题详情接口
 */
- (void)requestBHDetailWithDic:(NSDictionary *)dic;
/**
 *  邦会搜索接口
 */
- (void)requestBHSeachWithDic:(NSDictionary *)dic;
/**
 *  邦会搜索接口
 */
- (void)requestMessageWithDict:(NSDictionary *)dic;
/**
 *  邦会话题列表接口
 */
- (void)requestBHListHuaTi:(NSDictionary *)dict;
/**
 *  邦会公告列表接口
 */
- (void)requestBHListGongGao:(NSDictionary *)dict;
/**
 *  邦会邦学院列表接口
 */
- (void)requestBHListBangXueYuan:(NSDictionary *)dict;
/**
 *  邦会首页标签列表接口
 */
- (void)requestBHListTopic:(NSDictionary *)dict;



#pragma mark -- 查询机构码解绑绑定状态
-(void)requestOrgCodeStateWithParam:(NSDictionary*)dict;

#pragma mark -- 机构码申请第二步
-(void)requestRefereeBindName:(NSDictionary*)dict;
#pragma mark -- 机构码申请第三步
-(void)requestApplyOrgCode:(NSDictionary*)dict;

#pragma mark --申请机构码上传图片
-(void)requestUploadPersonImgWithImage:(UIImage *)image;


#pragma mark -- 帮会搜索人名
-(void)requestBangHuiSearchUsername:(NSDictionary*)dict;
#pragma mark -- 帮会搜索机构
-(void)requestBangHuiSearchOrgName:(NSDictionary*)dict;
#pragma mark -- 帮会搜索帖子
-(void)requestBangHuiSearchContents:(NSDictionary*)dict;
/**
 *  邦会接收到消息接口
 */
- (void)requestBHMessageWithDic:(NSDictionary *)dic;
/**
 *  邦会是否显示圈子开关接口
 */
- (void)requestBHQuanZiShoworHiddenWithDic:(NSDictionary *)dic;


- (void)requestVisitCreditsShopWith:(NSDictionary *)dict;
#pragma mark -- 积分签到
-(void)requestAwardPointRefereeSignWith:(NSDictionary*)dict;
#pragma mark -- 会员等级
-(void)requestAwardPointQueryAP:(NSDictionary *)dict;

#pragma mark -- 验证码验证接口
-(void)requestVertifyCodeWith:(NSDictionary*)dict;

#pragma mark -- 各板块登录弹出广告接口
-(void)requestLoginAdPresentWithParam:(NSDictionary*)dict;

#pragma mark -- 客户反馈楼盘到销邦
-(void)requestClientRecommandPropertyToSaleHelperWithParam:(NSDictionary*)dict;
#pragma  mark -- 销邦申请选择房源接口
-(void)requestAPPlySelectHouseResourceWithParam:(NSDictionary*)dict;

#pragma  mark -- 申请签约客户选择的认购房源
-(void)requestApplyClientSignHouseResourceWithParam:(NSDictionary*)dict;

#pragma mark -- 申请信息详情
-(void)requestApplyInfomationDetailWithParam:(NSDictionary*)dict;

#pragma mark -- 我的售楼部楼盘数据请求
-(void)requestMySalesCentreBuildingSharedWithParam:(NSDictionary*)dict;

#pragma mark -- 我的售楼部选择楼盘分享上传到服务器
-(void)requestMySalesOfficeToShareWithParam:(NSDictionary*)dict;

#pragma mark -- 我的售楼部楼盘删除操作
-(void)requestMySalesCentreDeleteBuildingWithParam:(NSDictionary*)dict;

#pragma  mark -- 我的团队
-(void)requestMyTeamDataWithParam:(NSDictionary*)dict;
#pragma  mark -- 我的团队排行榜
-(void)requestMyTeamListDataWithParam:(NSDictionary*)dict;

@end