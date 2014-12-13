//
//  XMDetailListController.m
//  WSY_XMHelper
//
//  Created by 袁仕崇 on 14/12/7.
//  Copyright (c) 2014年 wilson-yuan. All rights reserved.
//

#import "XMDetailListController.h"
#import "XMDataManager.h"
#import "XMDetailCell.h"
#import <MediaPlayer/MediaPlayer.h>
#import <UIAlertView+BlocksKit.h>

@interface XMDetailListController ()

@property (nonatomic, assign) VIDEO_TYPE type;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, assign) NSArray *detailList;

@end

static NSString *const cellIdentifier = @"XMDetailCell";
@implementation XMDetailListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.estimatedRowHeight = 110.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = _name;
    
    [[XMDataManager defaultDataManager] xm_detailListWithType:_type name:_ID page:_page];
    
    @weakify(self);
    [[RACObserve([XMDataManager defaultDataManager], detailList) deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(NSArray *list) {
        @strongify(self);
        self.detailList = list;
//        NSLog(@"%@", list);
        [self.tableView reloadData];
    }];
}
- (void)setVideoListType:(VIDEO_TYPE)type name:(NSString *)name videoId:(NSString *)ID
{
    self.type = type;
    self.name = name;
    self.ID = ID;
    self.page = 1;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.detailList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XMDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    [cell setCellData:[_detailList objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XMDetailCell *cell = (XMDetailCell *)[tableView cellForRowAtIndexPath:indexPath];

    UIAlertView *alertView = [UIAlertView bk_alertViewWithTitle:@"选择操作"];
    [alertView bk_addButtonWithTitle:NSLocalizedString(@"下载", @"下载") handler:^{
        NSString *urlString = cell.youku.video_addr;
//        NSString *name = cell.name.text;
        NSString *length = cell.length.text;
        NSString *time = cell.time.text;
        
urlString =@"http://pl.youku.com/playlist/m3u8?vid=118402875&type=mp4&ts=1415233731&keyframe=0&ep=diaVH0uOVckD5SPeiT8bMX3jdSUIXP8L%2FhuFg9plBdQmSuG9&sid=441523373001112fa11b7&token=2292&ctype=12&ev=1&oip=2081459012";
        
        NSDictionary *dic = @{@"name": cell.name.text, @"urlString": urlString, @"length":length, @"time": time, @"img": cell.imgString, @"youku_id": cell.youku.youku_id};
        
        [[XMDataManager defaultDataManager] xm_addVideoDownloadwithVideoDic:dic];
    }];
    [alertView bk_addButtonWithTitle:NSLocalizedString(@"播放", nil) handler:^{
        NSString *urlString = cell.youku.video_addr_super;
        MPMoviePlayerViewController *player = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:urlString]];
        [self.navigationController presentMoviePlayerViewControllerAnimated:player];
    }];
    [alertView bk_addButtonWithTitle:@"取消" handler:^{
        
    }];
    [alertView show];
   
}


//urlString	NSString *	@"http://pl.youku.com/playlist/m3u8?ep=eiaVHUmPUM0H5ybZiz8bbnnrciJeXJZ0vEiG%2FKYXSsVAMezQkT%2FRww%3D%3D&sid=8417026372563129e96ea&token=8104&ctype=12&ev=1&type=hd2&keyframe=0&oip=1931225911&ts=hXGJ9zRFKHwyRBt2AcC-SLQ&vid=XNzg3MDEzNTI4"	0x00007fb84bc9f910
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
