//
//  ChartBar.m
//  RunningNote
//
//  Created by qingyun on 16/7/22.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "ChartBar.h"
#import <AVOSCloudIM.h>
#import <Masonry.h>
#import "FunctionView.h"
#import "FacesView.h"
#import "RMessageBarButton.h"
#import "FaceModel.h"
#import "RVoiceRecordingView.h"
#import "RAudioRecorder.h"
#import <AVOSCloud.h>

#define kScreenWidth [[UIScreen mainScreen] bounds].size.width


@interface ChartBar ()<UITextViewDelegate>

@property (nonatomic, strong)FunctionView *functionView;//添加多媒体View
@property (nonatomic, strong)FacesView *facesView;//表情键盘
@property (weak, nonatomic) IBOutlet RMessageBarButton *addButton;
@property (weak, nonatomic) IBOutlet RMessageBarButton *sendButton;
@property (weak, nonatomic) IBOutlet UIButton *talkButton;
@property (weak, nonatomic) IBOutlet RMessageBarButton *facesButton;

@property (nonatomic, weak)RMessageBarButton *selectButton;


@property (nonatomic, strong)NSMutableArray *faces;


@property (nonatomic, strong)RAudioRecorder *recorder;
@property (nonatomic, strong)RVoiceRecordingView *voiceRecordingView;

@end

@implementation ChartBar
-(void)awakeFromNib{
    //xib初始化方法
    self.inputTextView.delegate =self;
    
    //存放表情
    _faces = [NSMutableArray array];
    _inputTextView.layer.borderColor = [UIColor blackColor].CGColor;
    _inputTextView.layer.borderWidth =0.6f;
    _inputTextView.layer.cornerRadius =6.0f;
    
    [_talkButton.layer setMasksToBounds:YES];
    [_talkButton.layer setCornerRadius:10.0];
    [_talkButton.layer setBorderWidth:0.3];

}

- (IBAction)btnClickAction:(RMessageBarButton *)sender {
    
    
    //排除选择发送按钮
    if (_selectButton.showType != kBarButtonSend && _selectButton.tag != sender.tag) {
        _selectButton.showType = _selectButton.tag;
        //保留这次选择的按钮,下次重置
        _selectButton = sender;
    }
    //点击按钮改变charbar 状态
    switch (sender.showType) {
        case kBarButtonAdd:
        {
            //点击加号,显示多媒体键盘
            sender.showType= kBarButtonKeyboard;
            
            [self showFunctionView];//设置键盘
            [self selectedKeyBoard];//显示出键盘
        }
            break;
        case kBarButtonFace:
        {
            sender.showType = kBarButtonKeyboard;
            //设置表情键盘
            [self showFacesView];
            //显示出键盘
            [self selectedKeyBoard];
        }
            break;
        case kBarButtonVoice:
        {
            sender.showType = kBarButtonKeyboard;
            //隐藏textView,取消键盘
            [self.inputTextView resignFirstResponder];//取消第一响应
            self.inputTextView.hidden = YES;
            
            //显示发送语音按钮
            self.talkButton.hidden = NO;
        }
            break;
        case kBarButtonSend:
        {
            sender.showType = kBarButtonVoice;
            [self sendMessage];
        }
            break;
        case kBarButtonKeyboard:
        {
            //回到原始状态
            sender.showType = sender.tag;
            //设置系统键盘
            self.inputTextView.inputView = nil;
            //显示出键盘
            [self selectedKeyBoard];
        }
            break;
        default:
            break;
    }
    
    
    
}

//发送文字内容
-(void)sendMessage{
    //发送内容;
    AVIMTextMessage *message = [AVIMTextMessage messageWithText:self.inputTextView.text attributes:nil];
    [self.delegate sendMessage:message];
    
    self.inputTextView.text = nil;
    //清空输入的表情
    [self.faces removeAllObjects];
    //更新输入栏
    [self changeSelfHeight];
}

#pragma text view delegate
-(void)textViewDidChange:(UITextView *)textView{
    //文字已经改变
    [self changeSelfHeight];
    //当输入有文字,显示发送按钮,不然显示语音
    if (textView.hasText) {
        self.sendButton.showType = kBarButtonSend;
    }else{
        self.sendButton.showType = kBarButtonVoice;
    }
    
}
-(void)changeSelfHeight{
    //根据现在文字的高度,调整父视图的高度
    CGSize size = self.inputTextView.contentSize;
    
    CGFloat height = size.height + 5 + 5;
    //限制最大高度150
    height  = height > 100 ? 100 : height;
    //最低高度 50
    
    height = height < 54 ? 54 : height;
    
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(height);
    }];
}

//监听用户输入
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    //用户输入的回车
    if ([text isEqualToString:@"\n"]) {
        //调用发送方法
        [self sendMessage];
        self.sendButton.showType = kBarButtonVoice;
        return NO;
    }
    return YES;
}


//将键盘切换为表情键盘
-(void)showFacesView{
    _inputTextView.inputView = self.facesView;
}

//初始化表情键盘
-(FacesView *)facesView{
    if (!_facesView) {
        _facesView = [[[NSBundle mainBundle] loadNibNamed:@"FacesView" owner:nil options:nil] firstObject];
        
        //初始化faceselect Block
        __weak ChartBar *chartbar = self;
        _facesView.selectedFace = ^(FaceModel *face){
            [chartbar addFace:face];
            NSLog(@"%@", face.text);
        };
    }
    return _facesView;
}

-(void)addFace:(FaceModel *)faceModel{
    //点击的空白
    if (faceModel.imgName == nil) {
        return;
    }
    if (!faceModel.isBack) {
        self.inputTextView.text  = [self.inputTextView.text stringByAppendingString:faceModel.text];
        [self.faces addObject:faceModel];
        [self textViewDidChange:_inputTextView];
    }else{
        [self removeLastFaces];
    }
}
-(void)removeLastFaces{
    if (self.faces.count == 0) {
        return;
    }
    FaceModel *faceModel = self.faces.lastObject;
    
    //查找表情在字符串中最后的位置
    NSRange range = [self.inputTextView.text rangeOfString:faceModel.text options:NSBackwardsSearch];
    if (range.length != 0) {
        self.inputTextView.text = [self.inputTextView.text stringByReplacingCharactersInRange:range withString:@""];
        [self.faces removeLastObject];
    }
}
//将键盘切换为多媒体键盘
-(void)showFunctionView{
    _inputTextView.inputView = self.functionView;
}
//初始化多媒体键盘
-(FunctionView *)functionView{
    if (!_functionView) {
        _functionView = [[[NSBundle mainBundle] loadNibNamed:@"FunctionView" owner:nil options:nil] firstObject];
        _functionView.delegate = (id)self.delegate;
    }
    return _functionView;
}
//显示出键盘
-(void)selectedKeyBoard{
    _inputTextView.hidden = NO;
    _talkButton.hidden = YES;
    if (_inputTextView.isFirstResponder) {
        //如果textView已经是第一响应,刷新键盘
        [_inputTextView reloadInputViews];
    }else{
        [_inputTextView becomeFirstResponder];
    }
}
-(RAudioRecorder *)recorder{
    if (!_recorder) {
        _recorder = [[RAudioRecorder alloc] init];
        __weak ChartBar *bar = self;
        _recorder.updatePower = ^(CGFloat powerValue){
            bar.voiceRecordingView.peakPower = powerValue;
        };
    }
    return  _recorder;
}
- (RVoiceRecordingView *)voiceRecordingView{
    if (_voiceRecordingView == nil) {
        _voiceRecordingView = [[[NSBundle mainBundle] loadNibNamed:@"RVoiceRecordingView" owner:nil options:nil] firstObject];
        _voiceRecordingView.center = self.superview.center;
        _voiceRecordingView.bounds = CGRectMake(0, 0, kScreenWidth / 3.0, kScreenWidth/ 3.0);
        
    }
    return _voiceRecordingView;
}

- (IBAction)touchCancel:(UIButton *)sender {//点击被打断
    [self.voiceRecordingView removeFromSuperview];
    NSLog(@"放弃录音,被系统打断");
    [self.recorder cancel];
    [self.voiceRecordingView removeFromSuperview];

}
- (IBAction)touchDown:(UIButton *)sender {//点击下去
    NSLog(@"touchDown");
    [self.recorder prepareRecordWith:[NSTemporaryDirectory() stringByAppendingPathComponent:@"temp.aac"]];
    //显示出显示音量的视图
    [self.superview addSubview:self.voiceRecordingView];
    
}
- (IBAction)drageEnter:(UIButton *)sender {//移入
    NSLog(@"drageEnter");
    [self.recorder continueRecord];


}
- (IBAction)drageExit:(UIButton *)sender {//移出
    NSLog(@"drageExit");
    NSLog(@"暂停录音");
    [self.recorder pauseRecord];

}
- (IBAction)touchUpInSide:(UIButton *)sender {//内部松开
    NSLog(@"touchUpInSide");
    [self.recorder stopRecord];
    
    [self.voiceRecordingView removeFromSuperview];
    
    //文件存在,录音成功
    if([[NSFileManager defaultManager] fileExistsAtPath:[NSTemporaryDirectory() stringByAppendingPathComponent:@"temp.aac"]]){
        AVFile *file = [AVFile fileWithName:@"temp.aac" contentsAtPath:[NSTemporaryDirectory() stringByAppendingPathComponent:@"temp.aac"]];
        
        //        AVIMAudioMessage *message = [AVIMAudioMessage messageWithText:[NSString stringWithFormat:@"%d", (int)self.recorder.currentTimeInterval] file:file attributes:nil];
        AVIMAudioMessage *message = [AVIMAudioMessage messageWithText:[NSString stringWithFormat:@"%d",(int)self.recorder.currentTimeInterval] file:file attributes:nil];
        [self.delegate sendMessage:message];
        
    }
    

}
- (IBAction)touchUpOutSiade:(UIButton *)sender {//外部松开
    NSLog(@"touchUpOutSiade");
    NSLog(@"放弃录音");
    [self.recorder cancel];
    [self.voiceRecordingView removeFromSuperview];
}





@end
