//
//  YBMessageListVC.m
//  YBWechat
//
//  Created by 易博 on 2018/1/24.
//  Copyright © 2018年 易博. All rights reserved.
//

#import "YBMessageListVC.h"

#import "YBSearchView.h"
#import "YBDropDownMenu.h"

#import "YBSearchVC.h"

#import "YBPubSerConversationVC.h"

@interface YBMessageListVC ()<YBSearchViewDelegate,YBDropDownMenuDelegate>

@property (nonatomic,strong) YBSearchView *searchView;

@property (nonatomic,strong) YBDropDownMenu *dropDownMenu;

@property (nonatomic,assign) BOOL showDropMenu;

@end

@implementation YBMessageListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //去掉空白页面多余的横线
    self.conversationListTableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    //设置无会话的默认图
    CGFloat imageViewW = YB_SCREEN_WIDTH / 3;
    UIImageView *emptyImageView = [[UIImageView alloc]initWithFrame:CGRectMake(imageViewW, (YB_SCREEN_HEIGHT - imageViewW) / 2, imageViewW, imageViewW)];
    emptyImageView.image = [UIImage imageNamed:@"no_message"];
    self.emptyConversationView = emptyImageView;
    
    //设置需要显示哪些类型的会话
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),
                                        @(ConversationType_DISCUSSION),
                                        @(ConversationType_CHATROOM),
                                        @(ConversationType_GROUP),
                                        @(ConversationType_APPSERVICE),
                                        @(ConversationType_SYSTEM)]];
    
//    [self setCollectionConversationType:@[@(ConversationType_APPSERVICE)]];
    
    //添加搜索框
    self.conversationListTableView.tableHeaderView = self.searchView;
    
    UIBarButtonItem *addIcon = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"barbtn_add"] style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonClicked)];
    self.navigationItem.rightBarButtonItem = addIcon;
}

-(void)rightBarButtonClicked
{
    if (self.showDropMenu) {
        self.showDropMenu = NO;
        [self.dropDownMenu removeFromSuperview];
    }
    else
    {
        self.showDropMenu = YES;
        [self.view addSubview:self.dropDownMenu];
    }
}

//重写RCConversationListViewController的onSelectedTableRow事件
- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType
         conversationModel:(RCConversationModel *)model
               atIndexPath:(NSIndexPath *)indexPath {
    if (ConversationType_APPSERVICE == model.conversationType) {
        
        YBPubSerConversationVC *pubSerConversationVC = [[YBPubSerConversationVC alloc] init];
        pubSerConversationVC.conversationType = model.conversationType;
        pubSerConversationVC.targetId = model.targetId;
        pubSerConversationVC.title = model.conversationTitle;
        
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:pubSerConversationVC animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
    else
    {
        YBConversationVC *chatVC = [[YBConversationVC alloc]init];
        chatVC.conversationType = model.conversationType;
        chatVC.targetId = model.targetId;
        chatVC.title = model.conversationTitle;
        
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:chatVC animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
}

#pragma mark --YBSearchViewDelegate
-(void)voiceBtnTapped
{
    [self jumpToSearchVC:1];
}

-(void)searchViewTapped
{
    [self jumpToSearchVC:0];
}

-(void)jumpToSearchVC:(NSInteger)type
{
    YBSearchVC *searchVC = [[YBSearchVC alloc]init];
    [self presentViewController:searchVC animated:YES completion:^{
        //
    }];
}

#pragma mark --YBDropDownMenuDelegate
-(void)selectedMenuAtIndex:(NSInteger)index
{
    
}

#pragma mark --get
-(YBSearchView *)searchView
{
    if (!_searchView) {
        _searchView = [[YBSearchView alloc]initWithFrame:CGRectMake(0, 0, YB_SCREEN_WIDTH, 45 * YB_WIDTH_PRO) type:0];
        _searchView.delegate = self;
        _searchView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return _searchView;
}

-(YBDropDownMenu *)dropDownMenu
{
    if (!_dropDownMenu) {
        _dropDownMenu = [[YBDropDownMenu alloc]initWithFrame:CGRectMake(YB_SCREEN_WIDTH * 0.6667 - 10, 64, YB_SCREEN_WIDTH / 3, 35 * YB_WIDTH_PRO * 4 + 10)];
        _dropDownMenu.dataList = [[NSArray alloc]initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"DropDownMenuData.plist" ofType:nil]];
        _dropDownMenu.delegate = self;
    }
    return _dropDownMenu;
}

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
