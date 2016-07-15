//
//  RPublishedVC.m
//  RunningNote
//
//  Created by qingyun on 16/7/12.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "RPublishedVC.h"
#import <AVOSCloud.h>
#import <AVUser.h>
#import <SVProgressHUD.h>


@interface RPublishedVC ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation RPublishedVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.alpha = 1;
    self.view.backgroundColor = [UIColor colorWithRed:46/255.0 green:46/255.0 blue:46/255.0 alpha:1];
    
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(creatNewDynamic)];
    self.navigationItem.rightBarButtonItem = rightButtonItem;

    
}

- (void)creatNewDynamic{

    [SVProgressHUD showWithStatus:@"发布中..."];
    self.view.userInteractionEnabled = NO;
    self.navigationController.navigationBar.userInteractionEnabled = NO;
    self.view.alpha = 0.5;
#warning (self.imageView.image, 0.1);   0.1
    NSData *imageData = UIImageJPEGRepresentation(self.imageView.image, 0.1);
    NSString *string = self.textView.text;
    AVObject *todoFolder = [[AVObject alloc] initWithClassName:@"Dynamic"];// 构建对象
    [todoFolder setObject:[AVUser currentUser].username forKey:@"userName"];
    [todoFolder setObject:string forKey:@"body"];
    [todoFolder setObject:imageData forKey:@"images"];
    [todoFolder setObject:@"位置" forKey:@"location"];
    [todoFolder saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [SVProgressHUD showSuccessWithStatus:@"发布成功"];
            [self performSelector:@selector(delayDismiss) withObject:nil afterDelay:2.0f];
        } else {
            [SVProgressHUD showErrorWithStatus:@"发布失败!"];
            [SVProgressHUD dismissWithDelay:2.0f];
            self.view.userInteractionEnabled = YES;
            self.navigationController.navigationBar.userInteractionEnabled = YES;
            self.view.alpha = 1.0;
            NSLog(@"%@",error);
        }
    }];
    
    
}

- (void)delayDismiss{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)changeImage:(UIButton *)sender {//添加图片
    //创建UIAlertController
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"选择图片" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action;
    //创建UIImagePickerController
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    //创建类型
    __block NSUInteger sourceType;
    //判断能否访问相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        action = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePickerController.delegate = self;
            imagePickerController.allowsEditing = YES;
            imagePickerController.sourceType = sourceType;
            // 跳转到相机
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }];
    }
    if (action) {
        [alertVC addAction:action];
    }
    //从相册选择图片
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"从相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        imagePickerController.delegate = self;
        imagePickerController.allowsEditing = YES;
        imagePickerController.sourceType = sourceType;
        // 跳转到图集
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }];
    //取消Action
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertVC addAction:photoAction];
    [alertVC addAction:cancleAction];
    [self presentViewController:alertVC animated:YES completion:nil];
    
}


#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    self.imageView.image = image;
}


//
//通过 limit 语句来限定返回结果大小，比如限定返回 100 个：
//+
//
//select * from Comment limit 100
/**
 *  比较日期，使用 date 函数来转换，比如查询特定时间之前创建的对象：
 +
 
 select * from GameScore where createdAt < date('2011-08-20T02:06:57.931Z')
 */

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
