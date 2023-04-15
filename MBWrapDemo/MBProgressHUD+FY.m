//
//  MBProgressHUD+FY.m
//
//  Created by licheng ke on 2023/4/13.
//

#import "MBProgressHUD+FY.h"

@implementation MBProgressHUD (FY)
+ (void)fy_show:(NSString *)text icon:(NSString *)icon view:(UIView *)view afterDelay:(double)afterDelay
{
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = text;
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]]];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // afterDelay秒之后再消失
    [hud hideAnimated:YES afterDelay:afterDelay];
}

#pragma mark - 成功提示
+ (void)fy_showSuccess:(NSString *)success afterDelay:(double)afterDelay
{
    [self fy_showSuccess:success toView:nil afterDelay:afterDelay];
}

+ (void)fy_showSuccess:(NSString *)success toView:(UIView *)view afterDelay:(double)afterDelay
{
    [self fy_show:success icon:@"success.png" view:view afterDelay:afterDelay];
}

#pragma mark - 失败提示
+ (void)fy_showError:(NSString *)error afterDelay:(double)afterDelay
{
    [self fy_showError:error toView:nil afterDelay:afterDelay];
}

+ (void)fy_showError:(NSString *)error toView:(UIView *)view afterDelay:(double)afterDelay
{
    [self fy_show:error icon:@"error.png" view:view afterDelay:afterDelay];
}


#pragma mark - 提示信息

+ (void)fy_showMsg:(NSString *)msg imageName:(NSString *)imageName toView:(UIView *)view clock:(BOOL)clock
{
    if (view == nil) view = (UIView *)[UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    // 设置文本
    hud.label.text = msg;
    // 隐藏时候从父控件中移除,自定义情况下默认为NO
    hud.removeFromSuperViewOnHide = YES;
    // 配置需要可以进行交互
    hud.userInteractionEnabled = clock;
    view.userInteractionEnabled = !clock;
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
    // 根据是否有文字设置样式
    if (msg && msg.length > 0) {
        // 设置方框view为该模式后修改颜色才有效果
        hud.bezelView.style = MBProgressHUDBackgroundStyleBlur;
        // 设置方框view背景色
        hud.bezelView.backgroundColor = [UIColor whiteColor];
    } else {
        // 设置方框view为该模式后修改颜色才有效果
        hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        // 设置方框view背景色
        hud.bezelView.backgroundColor = [UIColor clearColor];
    }
}

+ (void)fy_showMsg:(NSString *)msg gifName:(NSString *)gifName toView:(UIView *)view clock:(BOOL)clock
{
    if (view == nil) view = (UIView *)[UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    // 设置文本
    hud.label.text = msg;
    // 隐藏时候从父控件中移除,自定义情况下默认为NO
    hud.removeFromSuperViewOnHide = YES;
    // 配置需要可以进行交互
    hud.userInteractionEnabled = clock;
    view.userInteractionEnabled = !clock;
    hud.mode = MBProgressHUDModeCustomView;
    UIImage *image = [UIImage sd_animatedGIFWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:resource ofType:@"gif"]]];
    
    // 自定义imageView
    UIImageView *cusImgView = [[UIImageView alloc] initWithImage:image];
    [cusImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(80);
    }];
    hud.customView = cusImgView;
    // 根据是否有文字设置样式
    if (msg && msg.length > 0) {
        // 设置方框view为该模式后修改颜色才有效果
        hud.bezelView.style = MBProgressHUDBackgroundStyleBlur;
        // 设置方框view背景色
        hud.bezelView.backgroundColor = [UIColor whiteColor];
    } else {
        // 设置方框view为该模式后修改颜色才有效果
        hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        // 设置方框view背景色
        hud.bezelView.backgroundColor = [UIColor clearColor];
    }
}


+ (void)fy_showMsg:(NSString *)msg customView:(UIView *)customView toView:(UIView *)view clock:(BOOL)clock
{
    if (view == nil) view = (UIView *)[UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    // 设置文本
    hud.label.text = msg;
    // 隐藏时候从父控件中移除,自定义情况下默认为NO
    hud.removeFromSuperViewOnHide = YES;
    // 配置需要可以进行交互
    hud.userInteractionEnabled = clock;
    view.userInteractionEnabled = !clock;
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = customView;
    // 根据是否有文字设置样式
    if (msg && msg.length > 0) {
        // 设置方框view为该模式后修改颜色才有效果
        hud.bezelView.style = MBProgressHUDBackgroundStyleBlur;
        // 设置方框view背景色
        hud.bezelView.backgroundColor = [UIColor whiteColor];
    } else {
        // 设置方框view为该模式后修改颜色才有效果
        hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        // 设置方框view背景色
        hud.bezelView.backgroundColor = [UIColor clearColor];
    }
}

+ (void)fy_hideHUDForView:(UIView *)view
{
    [self hideHUDForView:view animated:YES];
}

+ (void)fy_hideHUD
{
    [self fy_hideHUDForView:nil];
}
@end
