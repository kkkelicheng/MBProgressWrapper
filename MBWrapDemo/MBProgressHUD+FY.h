//
//  MBProgressHUD+FY.h
//
//  Created by licheng ke on 2023/4/13.
//

#import <MBProgressHUD/MBProgressHUD.h>

NS_ASSUME_NONNULL_BEGIN

@interface MBProgressHUD (FY)
#pragma mark - 成功提示
+ (void)fy_showSuccess:(NSString *)success afterDelay:(double)afterDelay;
+ (void)fy_showSuccess:(NSString *)success toView:(UIView *)view afterDelay:(double)afterDelay;

#pragma mark - 失败提示
+ (void)fy_showError:(NSString *)error afterDelay:(double)afterDelay;
+ (void)fy_showError:(NSString *)error toView:(UIView *)view afterDelay:(double)afterDelay;


+ (void)fy_showMsg:(NSString *)msg imageName:(NSString *)imageName toView:(UIView *)view clock:(BOOL)clock;
+ (void)fy_showMsg:(NSString *)msg gifName:(NSString *)gifName toView:(UIView *)view clock:(BOOL)clock;
+ (void)fy_showMsg:(NSString *)msg customView:(UIView *)customView toView:(UIView *)view clock:(BOOL)clock;

#pragma mark - 隐藏hud
+ (void)fy_hideHUDForView:(UIView *)view;
+ (void)fy_hideHUD;

@end

NS_ASSUME_NONNULL_END
