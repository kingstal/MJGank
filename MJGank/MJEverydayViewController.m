//
//  SecondViewController.m
//  MJGank
//
//  Created by WangMinjun on 15/8/10.
//  Copyright (c) 2015年 WangMinjun. All rights reserved.
//

#import "MJEverydayViewController.h"
#import "MJGankHTTPManager.h"
#import "MJData.h"
#import "MJBrowserViewController.h"
#import "MBProgressHUD.h"

@interface MJEverydayViewController () <UITableViewDataSource, UITabBarDelegate>

@property (nonatomic, strong) NSMutableArray* datas;

@property (nonatomic, weak) IBOutlet UITableView* tableView;

@end

@implementation MJEverydayViewController

#pragma mark - Accessors

- (NSMutableArray*)datas
{
    if (!_datas) {
        _datas = [NSMutableArray new];
    }
    return _datas;
}

#pragma mark - LifeCircle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    [self getDayDataWithCurrentDateComps:[self getCurrentDateComponents]];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
    return self.datas.count;
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray* array = self.datas[section];
    return array.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    MJData* data = (MJData*)self.datas[indexPath.section][indexPath.row];
    cell.textLabel.text = data.title;
    return cell;
}

- (NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"iOS";
    }
    else if (section == 1) {
        return @"扩展资源";
    }
    else {
        return @"轻松一下";
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    MJBrowserViewController* browserVC = [MJBrowserViewController new];
    MJData* data = (MJData*)self.datas[indexPath.section][indexPath.row];
    browserVC.url = data.url;
    [self.navigationController pushViewController:browserVC animated:YES];
}

#pragma mark - Private

/**
 *  获得当前时间的年、月、日和 weekday
 *
 */
- (NSDateComponents*)getCurrentDateComponents
{
    NSDate* currentDate = [NSDate date];
    NSCalendar* currentCalendar = [NSCalendar currentCalendar];
    NSDateComponents* currentComps = [[NSDateComponents alloc] init];

    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday;
    currentComps = [currentCalendar components:unitFlags fromDate:currentDate];

    return currentComps;
}

- (void)getDayDataWithCurrentDateComps:(NSDateComponents*)currentComps
{
    MBProgressHUD* hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:hud];

    [hud showAnimated:YES
        whileExecutingBlock:^{
            [[MJGankHTTPManager sharedManager] getDataWithYear:currentComps.year
                month:currentComps.month
                day:currentComps.day
                success:^(MJGankHTTPManager* manager, id data) {
                    NSDictionary* dict = data;
                    if (!dict[@"iOS"]) {
                        MBProgressHUD* hudWarning = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                        hudWarning.mode = MBProgressHUDModeText;
                        hudWarning.labelText = @"今日暂时无干货！";
                        hudWarning.margin = 10.f;
                        hudWarning.removeFromSuperViewOnHide = YES;
                        [hudWarning hide:YES afterDelay:1.5];
                        return;
                    }

                    NSArray* iOS = dict[@"iOS"];
                    [self addData:iOS];

                    NSArray* extension = dict[@"拓展资源"];
                    [self addData:extension];

                    NSArray* video = dict[@"休息视频"];
                    [self addData:video];

                    [self.tableView reloadData];
                }
                failure:^(MJGankHTTPManager* manager, NSError* error) {

                    MBProgressHUD* hudWarning = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                    hudWarning.mode = MBProgressHUDModeText;
                    hudWarning.labelText = @"今日暂时无干货！";
                    hudWarning.margin = 10.f;
                    hudWarning.removeFromSuperViewOnHide = YES;
                    [hudWarning hide:YES afterDelay:1.5];

                    NSLog(@"%@", error);
                }];
        }
        completionBlock:^{
            [hud removeFromSuperview];
        }];
}

- (void)addData:(NSArray*)data;
{
    NSMutableArray* temp = [NSMutableArray new];
    for (NSDictionary* dict in data) {
        MJData* d = [[MJData alloc] initWithTitle:dict[@"desc"] URL:dict[@"url"]];
        [temp addObject:d];
    }
    [self.datas addObject:temp];
}
@end
