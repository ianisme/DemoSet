//
//  RootViewController.m
//  NSCoderDemo
//
//  Created by ian on 15/12/11.
//  Copyright © 2015年 ian. All rights reserved.
//

#import "RootViewController.h"
#import "IanScrollView.h"
#import "CpuModel.h"
#import "IanAlert.h"

#define Button_Tag 999
#define Plist_Name @"cpulist.plist"

@interface RootViewController ()

@property (nonatomic, strong) NSString *storageListPath;

@property (nonatomic, strong) NSMutableArray *cpuList;

@property (nonatomic, strong) CpuModel *model;

@property (nonatomic, strong) IanScrollView *scrollView;

@end

@implementation RootViewController

#pragma mark - life style
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    [self creatButtonView];
    NSArray *codePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    _storageListPath = [codePath[0] stringByAppendingPathComponent:Plist_Name];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    
}

#pragma mark - private methods
- (void)creatButtonView
{
    NSUInteger count = 3;
    for (NSUInteger i = 0; i < count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor blackColor];
        btn.frame = CGRectMake((self.view.frame.size.width/count)*i, 303, self.view.frame.size.width/count, 40);
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        btn.tag = Button_Tag + i;
        [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        if (i == 0) {
            [btn setTitle:@"归档" forState:UIControlStateNormal];
        } else if (i == 1){
            [btn setTitle:@"解归档" forState:UIControlStateNormal];
        } else {
            [btn setTitle:@"清除归档" forState:UIControlStateNormal];
        }

    }
}

- (void)creatScrollView
{
    if (_scrollView) {
        return;
    }
    IanScrollView *scrollView = [[IanScrollView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, (450/600.0f)*self.view.frame.size.width)];
    NSMutableArray *array = [NSMutableArray array];
    for (NSInteger i = 0; i < 5; i ++) {
        [array addObject:[(CpuModel *)self.cpuList[i] picture]];
    }
    scrollView.slideImagesArray = array;
    scrollView.ianEcrollViewSelectAction = ^(NSInteger i){
        
        NSLog(@"点击了%ld张图片",(long)i);
        
    };
    scrollView.ianCurrentIndex = ^(NSInteger index){
        NSLog(@"测试一下：%ld",(long)index);
    };
    scrollView.PageControlPageIndicatorTintColor = [UIColor colorWithRed:255/255.0f green:244/255.0f blue:227/255.0f alpha:1];
    scrollView.pageControlCurrentPageIndicatorTintColor = [UIColor colorWithRed:67/255.0f green:174/255.0f blue:168/255.0f alpha:1];
    scrollView.autoTime = [NSNumber numberWithFloat:4.0f];
    NSLog(@"%@",scrollView.slideImagesArray);
    [self.view addSubview:scrollView];
    [scrollView startLoading];
    _scrollView = scrollView;
}

- (void)deleteFile:(NSString *)plistName
{
    NSFileManager* fileManager=[NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *uniquePath=[[paths objectAtIndex:0] stringByAppendingPathComponent:plistName];
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:uniquePath];
    if (!blHave) {
        NSLog(@"no  have");
        return ;
    }else {
        NSLog(@" have");
        BOOL blDele= [fileManager removeItemAtPath:uniquePath error:nil];
        if (blDele) {
            NSLog(@"dele success");
        }else {
            NSLog(@"dele fail");
        }
        
    }
}


#pragma mark action methods
- (void)BtnClick:(id)sender
{
    _cpuList = [@[] mutableCopy];
    UIButton *btn = (UIButton *)sender;
    if (btn.tag == Button_Tag + 0) {
        for (NSUInteger i = 0; i < 5; i++) {
            CpuModel *model = [[CpuModel alloc] init];
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%zd.jpg",i+1]];
            model.picture = image;
            [_cpuList addObject:model];
        }
        
        if ([NSKeyedArchiver archiveRootObject:self.cpuList toFile:_storageListPath]) {
            [IanAlert alertSuccess:[NSString stringWithFormat:@"数据归档成功\n%@",_storageListPath]];
        }
    } else if (btn.tag == Button_Tag + 1){
        self.cpuList = [NSKeyedUnarchiver unarchiveObjectWithFile:_storageListPath];
        if(!self.cpuList) return;
        [self creatScrollView];
    } else if (btn.tag == Button_Tag + 2) {
        [self deleteFile:Plist_Name];
        if (_scrollView) {
            [IanAlert alertSuccess:@"归档删除成功"];
            [_scrollView removeFromSuperview];
            _scrollView = nil;
        }

    }
}

@end
