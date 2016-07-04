//
//  RMyRecordTableVC.m
//  RunningNote
//
//  Created by qingyun on 16/6/29.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "RMyRecordTableVC.h"

@interface RMyRecordTableVC ()

@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *pm;
@property (weak, nonatomic) IBOutlet UILabel *airQuality;
@property (weak, nonatomic) IBOutlet UILabel *temperature;
@property (weak, nonatomic) IBOutlet UIImageView *icon;     //用户头像
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;    //用户名
@property (weak, nonatomic) IBOutlet UILabel *idLabel;      //用户ID
@property (weak, nonatomic) IBOutlet UIButton *medalBtn;    //勋章按钮
@property (weak, nonatomic) IBOutlet UILabel *totalDistance;//累计距离
@property (weak, nonatomic) IBOutlet UILabel *totalTime;    //累计时间
@property (weak, nonatomic) IBOutlet UILabel *totalCalorie; //累计消耗
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;//最长距离
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;    //最长时间
@property (weak, nonatomic) IBOutlet UILabel *averageLabel; //最快匀速
@property (weak, nonatomic) IBOutlet UILabel *deserveLabel; //最快速配
@property (weak, nonatomic) IBOutlet UILabel *fastFiveLabel;//五公里最快时间
@property (weak, nonatomic) IBOutlet UILabel *fastTenLabel; //十公里最快时间
@property (weak, nonatomic) IBOutlet UIImageView *weatherImage;

@property (weak, nonatomic) IBOutlet UIView *tableHeadView;
@property (      nonatomic)          CGRect   frame;

@end

@implementation RMyRecordTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:46/255.0 green:46/255.0 blue:46/255.0 alpha:1];
    CGRect frame = _weatherImage.frame;
    _frame = frame;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)iconClick:(UITapGestureRecognizer *)sender {
    NSLog(@"头像点击事件");
}
- (IBAction)medalBtnClick:(UIButton *)sender {
    NSLog(@"勋章点击事件");
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            //跑步记录
            NSLog(@"跑步记录");
            //[self.navigationController pushViewController:<#(nonnull UIViewController *)#> animated:<#(BOOL)#>];
        }else if (indexPath.row == 1){
            //跑步日历
            NSLog(@"跑步日历");
            //[self.navigationController pushViewController:<#(nonnull UIViewController *)#> animated:<#(BOOL)#>];
        }
    }
}

#pragma mark -UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGPoint offset = self.tableView.contentOffset;
    NSInteger offsetY = -offset.y;
    if (offsetY > 0) {
        CGRect oldFrame = _frame;
        oldFrame.size.height += offsetY;
        oldFrame.origin.y    -= offsetY;
        _weatherImage.frame = oldFrame;
    }
}


#pragma mark - Table view data source


/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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
