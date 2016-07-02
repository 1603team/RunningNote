//
//  RUserInfoTableVC.m
//  RunningNote
//
//  Created by qingyun on 16/6/30.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "RUserInfoTableVC.h"
#import "RUserModel.h"
#import <Masonry.h>

#define SCREEN [UIScreen mainScreen].bounds
@interface RUserInfoTableVC ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

{
    NSIndexPath *_indexPath;
    UIDatePicker *_datePicker;
    UIImage *_image;
}
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;

@end

@implementation RUserInfoTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.row == 4) {
        [self pickerView];
//        _indexPath = indexPath;
    }else if (indexPath.section == 1) {
        [self alertView:cell.textLabel.text indexPath:indexPath];
    }else if (indexPath.section == 0 && indexPath.row == 0) {
        [self loadCameraOrPhotoLibrary];
    }
}

//修改头像，访问相册或相机
-(void)loadCameraOrPhotoLibrary {
    //创建UIAlertController
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"选择头像" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
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
//弹出修改框
- (void)alertView:(NSString *)title indexPath:(NSIndexPath *)indexPath {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入修改信息";
        if (indexPath.row == 3 || indexPath.row == 2) {
            textField.keyboardType = UIKeyboardTypeNumberPad;
        }
    }];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        UITextField *textField = alertVC.textFields.firstObject;
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        if (![textField.text isEqualToString:@""]) {
            cell.detailTextLabel.text = textField.text;
        }
    }];
    
    [alertVC addAction:cancleAction];
    [alertVC addAction:action];
    [self presentViewController:alertVC animated:YES completion:nil];
}
//弹出datePicker
- (void)pickerView {
    //创建UIDatePicker
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectZero];
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.backgroundColor = [UIColor brownColor];
    datePicker.maximumDate = [NSDate date];
#warning datePicker创建时现实的时间应该是cell跳转是传过来的时间！！！！
    UIView *view = [[UIView alloc] initWithFrame:SCREEN];
    view.backgroundColor = [UIColor grayColor];
//    view.alpha = .9f;
    [view addSubview:datePicker];
    [self.view addSubview:view];
    
    [datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(@0);
        make.width.mas_equalTo(SCREEN.size.width);
        make.height.mas_equalTo(300);
    }];
    //确定UIButton
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectZero];
    [view addSubview:button];
    button.tag = 100;
    [button setTitle:@"确定" forState:(UIControlStateNormal)];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@(80));
        make.top.mas_equalTo(datePicker.mas_bottom).with.offset(50);
    }];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    //取消UIButton
    UIButton *cancleButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [view addSubview:cancleButton];
    cancleButton.tag = 101;
    [cancleButton setTitle:@"取消" forState:(UIControlStateNormal)];
    [cancleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@(-80));
        make.top.mas_equalTo(datePicker.mas_bottom).with.offset(50);
    }];
    [cancleButton addTarget:self action:@selector(buttonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    _datePicker = datePicker;
}

//UIButton的监听方法
- (void)buttonClick:(UIButton *)sender {
    //判断点击的是哪个UIButton
    if (sender.tag == 100) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[self.tableView indexPathForSelectedRow]];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy-MM-dd";
        cell.detailTextLabel.text = [dateFormatter stringFromDate:_datePicker.date];
        [self.tableView reloadData];
    }else if (sender.tag == 200) {
        self.iconImage.image = _image;
    }
    [sender.superview removeFromSuperview];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    UIView *view = [[UIView alloc] initWithFrame:SCREEN];
    view.backgroundColor = [UIColor lightGrayColor];
    view.alpha = 0.9f;
    [self.view addSubview:view];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [view addSubview:imageView];
    CGSize size = CGSizeMake(SCREEN.size.width, 300);
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(@0);
        make.size.mas_equalTo(size);
    }];
    imageView.image = image;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    imageView.userInteractionEnabled = YES;
    //imageView上添加平移手势
    UIPanGestureRecognizer *panGesture=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    [imageView addGestureRecognizer:panGesture];
    //imageView上添加捏合手势
    UIPinchGestureRecognizer *pinch = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGesture:)];
    //确定UIButton
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectZero];
    [view addSubview:button];
    button.tag = 200;
    [button setTitle:@"确定" forState:(UIControlStateNormal)];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@(80));
        make.top.mas_equalTo(imageView.mas_bottom).with.offset(50);
    }];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:(UIControlEventTouchUpInside)];
    //取消UIButton
    UIButton *cancleButton = [[UIButton alloc] initWithFrame:CGRectZero];
    [view addSubview:cancleButton];
    cancleButton.tag = 201;
    [cancleButton setTitle:@"取消" forState:(UIControlStateNormal)];
    [cancleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@(-80));
        make.top.mas_equalTo(imageView.mas_bottom).with.offset(50);
    }];
    [cancleButton addTarget:self action:@selector(buttonClick:) forControlEvents:(UIControlEventTouchUpInside)];
//    CGRect rect = CGRectMake(self.view.center.x, self.view.center.y, 100, 100);
//    self.iconImage.image = [self imageFromImage:image inRect:rect];
//    self.iconImage.image = image;
//    self.iconImage.layer.cornerRadius = 20;
//    self.iconImage.layer.masksToBounds = YES;
//    NSData *imageData = UIImageJPEGRepresentation(image, COMPRESSED_RATE);
//    UIImage *compressedImage = [UIImage imageWithData:imageData];
}

//捏合手势
- (void)pinchGesture:(UIPinchGestureRecognizer *)pinch {
    //1.获取当前放大的比例
    float scale=pinch.scale;
    NSLog(@"========%f",scale);
    //仿射变换 scale 比例
    pinch.view.transform=CGAffineTransformScale(pinch.view.transform, scale, scale);
    //scale 置1,因为它本身是个绝对值,我们所需要的是个增量值
    pinch.scale=1;
}
//平移手势
- (void)panGesture:(UIPanGestureRecognizer *)pan {
    //1.获取一个点绝对值,但是需要的是一个增量值
    CGPoint point=[pan translationInView:pan.view.superview];
    //2重置point坐标 x,y 设置初始化 从零开始
    [pan setTranslation:CGPointZero inView:pan.view.superview];
    pan.view.center=CGPointMake(pan.view.center.x+point.x, pan.view.center.y+point.y);
}

- (UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect {
    CGImageRef sourceImageRef = [image CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    return newImage;
}

@end
