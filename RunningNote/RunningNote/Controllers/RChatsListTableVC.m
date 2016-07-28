//
//  ChatsListTableVC.m
//  RunningNote
//
//  Created by qingyun on 16/7/27.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "RChatsListTableVC.h"
#import "AVIMCommon.h"
#import "AVIMSignature.h"
#import "RMessageManager.h"
#import "RUserModel.h"
@interface RChatsListTableVC ()

@property (nonatomic, strong) NSArray *chatsList;

@end

@implementation RChatsListTableVC

//- (NSArray *)chatsList{
//    if (!_chatsList) {
//        _chatsList = [[NSArray alloc] init];
//    }
//    return _chatsList;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    _chatsList = [[NSArray alloc] init];

    AVIMClient *client = [RMessageManager sharemessageManager].clint;
    AVIMConversationQuery *query = [client conversationQuery];
    
//    AVIMConversation *com = [[AVIMConversation alloc] init];
//    [query whereKey:[AVUser currentUser].username containedIn: com.members];
    [query whereKey:@"m" containsAllObjectsInArray:@[[AVUser currentUser].username ]];
    [query addDescendingOrder:@"updateAt"];
    __weak RChatsListTableVC *weakSelf = self;
    // 执行查询
    if (client.status == AVIMClientStatusOpened) {
        NSLog(@"开着");
        [query findConversationsWithCallback:^(NSArray *objects, NSError *error) {
            if (error) {
                NSLog(@"%@",error);
            }
            NSLog(@"%@",objects);
            weakSelf.chatsList = objects;
            [weakSelf.tableView reloadData];
        }];

    }else{
        NSLog(@"关着");
        [client openWithCallback:^(BOOL succeeded, NSError *error){
            [query findConversationsWithCallback:^(NSArray *objects, NSError *error) {
                if (error) {
                    NSLog(@"%@",error);
                }
                NSLog(@"%@",objects);
                weakSelf.chatsList = objects;
                [weakSelf.tableView reloadData];
            }];
        }];
    }
    
//    AVIMAttr(<#attr#>)
    
 
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"reuseIdentifier"];
    
}



#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.chatsList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AVIMConversation *conversation = self.chatsList[indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"reuseIdentifier"];
    }
    
    cell.textLabel.text = conversation.name;
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
