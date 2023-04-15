//
//  MBPHUD.m
//  MBWrapDemo
//
//  Created by kkkelicheng on 2023/4/13.
//

#import "MBPHUD.h"

//默认的隐藏时间
double const MBPHUDDefaultHideDelay = 1.5;

@interface MBPHUDTool : NSObject
@end
@implementation MBPHUDTool
+ (BOOL)isEmptyString:(nullable NSString *)string{
    NSString * content = string ?: @"";
    return content.length < 1;
}

+ (nullable UIWindow *)keywindow { //这里可能需要改进
    NSArray<UIWindow *> *windows = [[UIApplication sharedApplication] windows];
    for (UIWindow *window in windows) {
        if (window.isKeyWindow) {
            return window;
        }
    }
    return nil;
}

+ (double)delayTimeAccordText:(NSString *)text {
    NSInteger textCount = text.length;
    double time = MBPHUDDefaultHideDelay;
    double cTime = textCount * 1.0 / 10 + 0.5;
    return MAX(time, cTime);
}


@end

@implementation MBPHUDPostion

/*
 values的的效果最终受到MBProgressHUD的margin的影响
 
 MBProgressHUD的margin
 1. bezelView 内容的内间距
 2. bezelView到superView的最小间距
 3. bezelView 内容到 bezelView的间距
 
 // 设置updateConstraints
 // Ensure minimum side margin is kept
 
 NSMutableArray *sideConstraints = [NSMutableArray array];
 [sideConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(>=margin)-[bezel]-(>=margin)-|" options:0 metrics:metrics views:NSDictionaryOfVariableBindings(bezel)]];
 [sideConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=margin)-[bezel]-(>=margin)-|" options:0 metrics:metrics views:NSDictionaryOfVariableBindings(bezel)]];
 [self applyPriority:999.f toConstraints:sideConstraints];
 [self addConstraints:sideConstraints];
 */

+ (instancetype)originWithOffset:(CGPoint)offset{
    MBPHUDPostion * p = [[MBPHUDPostion alloc] initWithPtType:MBPHUDPostionTypeOriginOffset values:UIEdgeInsetsMake(offset.x, offset.y, 0, 0)];
    return p;
}

+ (instancetype)centerWithOffset:(CGPoint)offset{
    MBPHUDPostion * p = [[MBPHUDPostion alloc] initWithPtType:MBPHUDPostionTypeCenterOffset values:UIEdgeInsetsMake(offset.x, offset.y, 0, 0)];
    return p;
}

+ (instancetype)stickTopMargin:(CGFloat)margin{
    MBPHUDPostion * p = [[MBPHUDPostion alloc] initWithPtType:MBPHUDPostionTypeMarginCenterTop values:UIEdgeInsetsMake(margin, 0, 0, 0)];
    return p;
}

+ (instancetype)stickLeftMargin:(CGFloat)margin{
    MBPHUDPostion * p = [[MBPHUDPostion alloc] initWithPtType:MBPHUDPostionTypeMarginCenterLeft values:UIEdgeInsetsMake(0, margin, 0, 0)];
    return p;
}

+ (instancetype)stickBottomMargin:(CGFloat)margin{
    MBPHUDPostion * p = [[MBPHUDPostion alloc] initWithPtType:MBPHUDPostionTypeMarginCenterBottom values:UIEdgeInsetsMake(0, 0, margin, 0)];
    return p;
}

+ (instancetype)stickRightMargin:(CGFloat)margin{
    MBPHUDPostion * p = [[MBPHUDPostion alloc] initWithPtType:MBPHUDPostionTypeMarginCenterRight values:UIEdgeInsetsMake(0, 0, 0, margin)];
    return p;
}

-(instancetype)initWithPtType:(MBPHUDPostionType)ptType values:(UIEdgeInsets)values{
    if (self = [super init]) {
        self.ptType = ptType;
        self.values = values;
    }
    return self;
}

- (void)applyToMBProgressHUD:(MBProgressHUD *)hud toView:(UIView *)view{
    switch (self.ptType) {
        case MBPHUDPostionTypeCenterOffset:
            hud.offset = CGPointMake(self.values.left,self.values.top);
            break;
        case MBPHUDPostionTypeCenterTop:
            hud.offset = CGPointMake(0,-MBProgressMaxOffset);
            break;
        case MBPHUDPostionTypeCenterLeft:
            hud.offset = CGPointMake(-MBProgressMaxOffset,0);
            break;
        case MBPHUDPostionTypeCenterBottom:
            hud.offset = CGPointMake(0,MBProgressMaxOffset);
            break;
        case MBPHUDPostionTypeCenterRight:
            hud.offset = CGPointMake(MBProgressMaxOffset,0);
            break;
        default:
            [self indirectApplyToMBProgressHUD:hud toView:view];
            break;
    }
}

- (void)indirectApplyToMBProgressHUD:(MBProgressHUD *)hud toView:(UIView *)view{
    [hud setNeedsLayout];
    [hud layoutIfNeeded];
    CGRect viewBounds = view.bounds;
    CGRect hudContentBounds = hud.bezelView.bounds;
    CGSize halfSize = CGSizeMake(viewBounds.size.width * 0.5, viewBounds.size.height * 0.5);
    CGSize hudCSize = CGSizeMake(hudContentBounds.size.width * 0.5 , hudContentBounds.size.height * 0.5) ;
    switch (self.ptType) {
        case MBPHUDPostionTypeOriginOffset:
            hud.offset = CGPointMake(-(halfSize.width - self.values.left) + hudCSize.width ,-(halfSize.height - self.values.top) + hudCSize.height);
            break;
        case MBPHUDPostionTypeMarginCenterTop:
            hud.offset = CGPointMake(0,-(halfSize.height - self.values.top) + hudCSize.height);
            break;
        case MBPHUDPostionTypeMarginCenterLeft:
            hud.offset = CGPointMake(-(halfSize.width - self.values.left) + hudCSize.width,0);
            break;
        case MBPHUDPostionTypeMarginCenterBottom:
            hud.offset = CGPointMake(0,halfSize.height - self.values.bottom - hudCSize.height);
            break;
        case MBPHUDPostionTypeMarginCenterRight:
            hud.offset = CGPointMake(halfSize.width - self.values.right - hudCSize.width,0);
            break;
        default:
            break;
    }
}

@end

@implementation MBPHUD

+ (MBProgressHUD *)configHUD:(MBProgressHUD *)hud
                        font:(UIFont *)font
                      margin:(CGFloat)margin
              contentBgColor:(UIColor *)contentBgColor
      userInteractionEnabled:(BOOL)userInteractionEnabled
              backgoundColor:(UIColor *)backgoundColor
{
    hud.label.font = font; //默认的是boldSystemFontOfSize 16
    hud.margin = margin;  //默认是20
    hud.bezelView.color = contentBgColor;
    hud.userInteractionEnabled = !userInteractionEnabled; //默认是True，表示不能穿透hud进行交互。
    hud.backgroundView.color = backgoundColor;
    return hud;
}

+ (void)hideHUDFromView:(nullable UIView *)view{
    UIView * aimView = view;
    if (aimView == nil) aimView = [MBPHUDTool keywindow];
    [MBProgressHUD hideHUDForView:view animated:true];
}

+ (void)hideHUD{
    [self hideHUDFromView:nil];
}

/***************************************************  展示Text  **************************************************************/
/*
 1. 会自己消失
 2. 可以与View交互
 */

+ (void)showText:(nullable NSString *)text toView:(nullable UIView *)view afterDelay:(double)afterDelay position:(nullable MBPHUDPostion *)position{
    if ([MBPHUDTool isEmptyString:text]) {return;}
    UIView * aimView = view;
    if (aimView == nil) {aimView = [MBPHUDTool keywindow];}
    if (aimView == nil) {return;}
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = text;
    hud.label.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium]; //默认的是boldSystemFontOfSize 16
    hud.animationType = MBProgressHUDAnimationZoomOut;
    hud.margin = 10;  //默认是20
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    hud.userInteractionEnabled = NO; //默认是True，表示不能穿透hud进行交互。
    double hideDelay = afterDelay <= 0.2 ? MBPHUDDefaultHideDelay : afterDelay;
    if (position) {
        [position applyToMBProgressHUD:hud toView:aimView];
    }
    [hud hideAnimated:YES afterDelay:hideDelay];
}

+ (void)showBtmTxt:(nullable NSString *)text toView:(nullable UIView *)view
{
    double delayTime = [MBPHUDTool delayTimeAccordText:text];
    CGFloat height = view.bounds.size.height;
    MBPHUDPostion * p = [MBPHUDPostion stickBottomMargin: height * 0.2];
    [self showText:text toView:view afterDelay:delayTime position:p];
}

+ (void)showTopTxt:(nullable NSString *)text toView:(nullable UIView *)view
{
    double delayTime = [MBPHUDTool delayTimeAccordText:text];
    CGFloat height = view.bounds.size.height;
    MBPHUDPostion * p = [MBPHUDPostion stickTopMargin: height * 0.2];
    [self showText:text toView:view afterDelay:delayTime position:p];
}

+ (void)showTxt:(nullable NSString *)text toView:(nullable UIView *)view
{
    double delayTime = [MBPHUDTool delayTimeAccordText:text];
    [self showText:text toView:view afterDelay:delayTime position:nil];
}

/*****************************************  展示Image + Text ***********************************************/


+ (MBProgressHUD *)showImage:(nullable NSArray<UIImage *> *)images
         withText:(nullable NSString *)text
           toView:(nullable UIView *)view
         position:(nullable MBPHUDPostion *)position
interactionEnable:(BOOL)interactionEnable
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    if ([MBPHUDTool isEmptyString:text] && !images) {
        [hud hideAnimated:false];
        return hud;
    }
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.mode = MBProgressHUDModeCustomView;
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    hud.customView = imageView;
    if (images.count == 1) {
        imageView.image = images.firstObject;
    }
    else { //多个是支持gif的
        imageView.animationImages = images;
        imageView.animationDuration = 3; //需要优化
        [imageView startAnimating];
    }
    hud.animationType = MBProgressHUDAnimationZoomOut;
    hud.label.text = text;
    //confighud
    hud.label.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];; //默认的是boldSystemFontOfSize 16
    hud.margin = 10;  //默认是20
    hud.bezelView.color = [[UIColor blackColor] colorWithAlphaComponent:0.2];;
    hud.userInteractionEnabled = !interactionEnable; //默认是True，表示不能穿透hud进行交互。
    return hud;
}

//向上偏移0.1height
+ (MBProgressHUD *)showImage:(nullable UIImage *)image
         withText:(nullable NSString *)text
           toView:(nullable UIView *)view
interactionEnable:(BOOL)interactionEnable
{
    CGFloat centerYOffSet = view.frame.size.height * 0.5 * 0.2;
    MBPHUDPostion * p = [MBPHUDPostion centerWithOffset:CGPointMake(0, centerYOffSet)];
    return [self showImage:@[image] withText:text toView:view position:p interactionEnable:interactionEnable];
}

//自动隐藏
+ (void)showSucTxt:(nullable NSString *)text toView:(nullable UIView *)view {
    double delayTime = [MBPHUDTool delayTimeAccordText:text];
    UIImage * image = [UIImage imageNamed:@"your success image"];
    MBProgressHUD * hud = [self showImage:image withText:text toView:view interactionEnable:true];
    [hud hideAnimated:YES afterDelay:delayTime];
}

//自动隐藏
+ (void)showErrTxt:(nullable NSString *)text toView:(nullable UIView *)view {
    double delayTime = [MBPHUDTool delayTimeAccordText:text];
    UIImage * image = [UIImage imageNamed:@"your error image"];
    MBProgressHUD * hud = [self showImage:image withText:text toView:view interactionEnable:true];
    [hud hideAnimated:YES afterDelay:delayTime];
}

//不会自动隐藏
+ (void)showLoadingWithTxt:(nullable NSString *)text toView:(nullable UIView *)view actionEnable:(BOOL)actionEnable{
    //your loading image
    NSURL *fileUrl = [[NSBundle mainBundle] URLForResource:@"testGif" withExtension:@"gif"];
    CGImageSourceRef gifSource = CGImageSourceCreateWithURL((CFURLRef)fileUrl, NULL);
    size_t frameCout=CGImageSourceGetCount(gifSource);
    NSMutableArray* frames= [[NSMutableArray alloc] init];
    for (size_t i=0; i < frameCout ; i++){
        CGImageRef imageRef=CGImageSourceCreateImageAtIndex(gifSource, i, NULL);
        UIImage* imageName=[UIImage imageWithCGImage:imageRef];
        [frames addObject:imageName];
        CGImageRelease(imageRef);
    }
    CGFloat centerYOffSet = view.frame.size.height * 0.5 * 0.2;
    MBPHUDPostion * p = [MBPHUDPostion centerWithOffset:CGPointMake(0, centerYOffSet)];
    [self showImage:frames withText:text toView:view position:p interactionEnable:actionEnable];
}

/*******************************  展示CustomView + Text ****************************/

+ (MBProgressHUD *)showCustomView:(UIView *)customView
         withText:(nullable NSString *)text
           toView:(nullable UIView *)view
         position:(nullable MBPHUDPostion *)position
     interactionEnable:(BOOL)interactionEnable
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = customView;
    hud.animationType = MBProgressHUDAnimationZoomOut;
    hud.label.text = text;
    //confighud
    hud.label.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];; //默认的是boldSystemFontOfSize 16
    hud.margin = 10;  //默认是20
    hud.bezelView.color = [[UIColor blackColor] colorWithAlphaComponent:0.2];;
    hud.userInteractionEnabled = !interactionEnable; //默认是True，表示不能穿透hud进行交互。
    return hud;
}

//向上偏移0.1height
+ (MBProgressHUD *)showCustomView:(UIView *)customView
                         withText:(nullable NSString *)text
                           toView:(nullable UIView *)view
{
    CGFloat centerYOffSet = view.frame.size.height * 0.5 * 0.2;
    MBPHUDPostion * p = [MBPHUDPostion centerWithOffset:CGPointMake(0, centerYOffSet)];
    return [self showCustomView:customView withText:text toView:view position:p interactionEnable:false];
}


@end
