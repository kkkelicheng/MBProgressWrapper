//
//  TableViewController.m
//  MBWrapDemo
//
//  Created by kkkelicheng on 2023/4/13.
//

#import "TableViewController.h"
#import "MBPHUD.h"
#import "MBPHUD+Easy.h"
#import <MBWrapDemo-Swift.h>

@interface TableViewController ()
@property (nonatomic,strong) NSMutableArray<NSString *> * dataSource;
@end

@implementation TableViewController

- (NSMutableArray<NSString *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = @[@"自定义offset",@"图片和文字",@"自定义view用lottie",@"支持gif"].mutableCopy;
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"123" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"row:%@ %@",@(indexPath.row),self.dataSource[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    switch (indexPath.row) {
        case 0:
            [self rowAction0_customOffset];
            break;
        case 1:
            [self rowAction1_imageAndText];
            break;
        case 2:
            [self rowAction2_customViewForLottieAnimation];
            break;
        case 3:
            [self rowAction3_gifImage];
            break;
        default:
            break;
    }
}


- (void)rowAction0_customOffset{
    MBPHUDPostion * p = [[MBPHUDPostion alloc]initWithPtType:MBPHUDPostionTypeOriginOffset values:UIEdgeInsetsMake(100, 100, 0, 0)];
    [MBPHUD showText:@"UITableView" toView:self.view afterDelay:1.5 position:p];
}

- (void)rowAction1_imageAndText{
    UIImage * smallImage = [UIImage imageNamed:@"test56_54"];
    [MBPHUD showImage:smallImage withText:@"UITableView" toView:self.view position:nil interactionEnable:true];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBPHUD hideHUDFromView:self.view];
    });
}

- (void)rowAction2_customViewForLottieAnimation{
    MBPLottie * customView = [MBPLottie new];
    [MBPHUD showCustomView:customView withText:@"UITableView" toView:self.view position:nil interactionEnable:false];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBPHUD hideHUDFromView:self.view];
    });
}

- (void)rowAction3_gifImage{
    [MBPHUD showLoadingWithTxt:@"加载中..." toView:self.view actionEnable:false];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [MBPHUD hideHUDFromView:self.view];
    });
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
