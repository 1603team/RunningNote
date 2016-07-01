//
//  RRuningVC.m
//  RunningNote
//
//  Created by qingyun on 16/6/30.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "RRuningVC.h"
#import "UIViewController+RVCForStoryBoard.h"
#import "RHomeSportVC.h"
#import "ROutSideVC.h"

@interface RRuningVC ()
@property (weak, nonatomic) IBOutlet UIImageView *homeSportImage;
@property (weak, nonatomic) IBOutlet UIImageView *outsideSportImage;

@end

@implementation RRuningVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)homeClick:(UITapGestureRecognizer *)sender {
    RHomeSportVC *homeVC = [UIViewController controllerForStoryBoardName:@"RXiaoDong" ControllerName:@"RHomeSportVC"];
    [self.navigationController pushViewController:homeVC animated:YES];
}
- (IBAction)outsideClick:(UITapGestureRecognizer *)sender {
    ROutSideVC *outVC = [UIViewController controllerForStoryBoardName:@"RXiaoDong" ControllerName:@"ROutSideVC"];
    [self.navigationController pushViewController:outVC animated:YES];
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
