//
//  RMyDetailRecordVC.m
//  RunningNote
//
//  Created by qingyun on 16/7/28.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "RMyDetailRecordVC.h"
#import "DataBaseFile.h"
#import "QYDataBaseTool.h"
#import "RUserRunRecord.h"
#import "RUserRecordCell.h"
#import "RUserRunRecord.h"

@interface RMyDetailRecordVC ()

@property (nonatomic, strong) NSArray *datas;

@end

@implementation RMyDetailRecordVC
static NSString *cellIdentifier = @"recordCellHome";
static NSString *cellIdentifierOut = @"recordCellHomeOut";

//懒加载datas
-(NSArray *)datas {
    if (_datas == nil) {
        [QYDataBaseTool selectStatementsSql:SELECT_MyRunNote_ALL withParsmeters:nil forMode:@"RUserRunRecord" block:^(NSMutableArray *resposeOjbc, NSString *errorMsg) {
            _datas = resposeOjbc;
        }];
    }
    return _datas;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
    //注册Cell
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([RUserRecordCell class]) bundle:nil] forCellReuseIdentifier:cellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"RUserRecordCellOut" bundle:nil] forCellReuseIdentifier:cellIdentifierOut];
    
    self.tableView.backgroundColor = [UIColor blackColor];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.estimatedRowHeight = 110.5;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RUserRunRecord *recordModel = self.datas[indexPath.row];
    RUserRecordCell *cell;
    if (recordModel.isHome) {
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    }else {
        cell= [tableView dequeueReusableCellWithIdentifier:cellIdentifierOut forIndexPath:indexPath];
    }
    cell.recoedModel = recordModel;
    return cell;
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
