//
//  MBPHUD.h
//  MBWrapDemo
//
//  Created by kkkelicheng on 2023/4/13.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

NS_ASSUME_NONNULL_BEGIN

extern double const MBPHUDDefaultHideDelay;

/*
 注意： MBP内置的Margin的优先级最高

 MBPHUDPostionTypeCenterOffset = 直接使用的MBP的内置offset
 MBPHUDPostionTypeCenterDirection = 使用最大的偏移值贴到内置Margin（也是直接使用的MBP的内置offset）
 //间接设置值
 MBPHUDPostionTypeOriginOffset 算出的offset
 MBPHUDPostionTypeMarginCenterDirection 算出的offset
 */

typedef enum : NSUInteger {
    MBPHUDPostionTypeCenterOffset,
    MBPHUDPostionTypeCenterTop,
    MBPHUDPostionTypeCenterLeft,
    MBPHUDPostionTypeCenterBottom,
    MBPHUDPostionTypeCenterRight,
    //间接设置值
    MBPHUDPostionTypeOriginOffset,
    MBPHUDPostionTypeMarginCenterTop,
    MBPHUDPostionTypeMarginCenterLeft,
    MBPHUDPostionTypeMarginCenterBottom,
    MBPHUDPostionTypeMarginCenterRight,
} MBPHUDPostionType;

@interface MBPHUDPostion : NSObject
@property (nonatomic,assign) MBPHUDPostionType ptType;
@property (nonatomic,assign) UIEdgeInsets values;
//values的最小值受到MBProgressHUD的margin的影响
-(instancetype)initWithPtType:(MBPHUDPostionType)ptType values:(UIEdgeInsets)values;
+ (instancetype)centerWithOffset:(CGPoint)offset;   //MBPHUDPostionTypeCenterOffset
+ (instancetype)originWithOffset:(CGPoint)offset;   //MBPHUDPostionTypeOriginOffset
+ (instancetype)stickTopMargin:(CGFloat)margin;     //MBPHUDPostionTypeMarginCenterTop
+ (instancetype)stickLeftMargin:(CGFloat)margin;    //MBPHUDPostionTypeMarginCenterLeft
+ (instancetype)stickBottomMargin:(CGFloat)margin;  //MBPHUDPostionTypeMarginCenterBottom
+ (instancetype)stickRightMargin:(CGFloat)margin;   //MBPHUDPostionTypeMarginCenterRight
@end

@interface MBPHUD : NSObject

+ (void)hideHUDFromView:(nullable UIView *)view;
+ (void)hideHUD;


/*****************************  展示Text  ***************************/

/// 仅仅显示文字
/// - Parameters:
///   - text: 文字描述
///   - view: 显示所在的View,nil默认会加到window上显示.
///   - afterDelayTime: 消失的时间,小于0.2是默认时间MBPHUDDefaultHideDelay
///   - position: 位置信息
+ (void)showText:(nullable NSString *)text
          toView:(nullable UIView *)view
      afterDelay:(double)afterDelay
        position:(nullable MBPHUDPostion *)position;

+ (void)showBtmTxt:(nullable NSString *)text toView:(nullable UIView *)view;
+ (void)showTopTxt:(nullable NSString *)text toView:(nullable UIView *)view;
+ (void)showTxt:(nullable NSString *)text toView:(nullable UIView *)view;




/*****************************************  展示Image + Text ***********************************************/

/// 显示图片和文字 不能自动移除
/// - Parameters:
///   - image: 图片
///   - text: 文字
///   - view: 显示所在的View,nil默认会加到window上显示.
///   - position: 位置信息
///   - interactionEnable: 能否交互
+ (MBProgressHUD *)showImage:(nullable NSArray<UIImage *> *)image
                    withText:(nullable NSString *)text
                      toView:(nullable UIView *)view
                    position:(nullable MBPHUDPostion *)position
           interactionEnable:(BOOL)interactionEnable;

//自动消失
+ (void)showSucTxt:(nullable NSString *)text toView:(nullable UIView *)view;
//自动消失
+ (void)showErrTxt:(nullable NSString *)text toView:(nullable UIView *)view;
//不会自动消失
+ (void)showLoadingWithTxt:(nullable NSString *)text toView:(nullable UIView *)view actionEnable:(BOOL)actionEnable;


/************************  展示CustomView + Text 不会自动消失 **********************/

/// 显示自定义View和文字
/// - Parameters:
///   - customView: 自定义View
///   - text: 文字
///   - view: 显示所在的View,nil默认会加到window上显示.
///   - position: 位置信息
///   - interactionEnable: 能否交互
+ (MBProgressHUD *)showCustomView:(UIView *)customView
                         withText:(nullable NSString *)text
                           toView:(nullable UIView *)view
                         position:(nullable MBPHUDPostion *)position
                interactionEnable:(BOOL)interactionEnable;

+ (MBProgressHUD *)showCustomView:(UIView *)customView
                         withText:(nullable NSString *)text
                           toView:(nullable UIView *)view;

@end

NS_ASSUME_NONNULL_END
