//
//  ViewController.m
//  JPSDK
//
//  Created by 任敬 on 2021/9/10.
//

#import "ViewController.h"
#import "JPNewCameraViewController.h"
#import "JPManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    UIButton * bt = [UIButton buttonWithType:UIButtonTypeCustom];
    bt.frame = CGRectMake(100, 100, 100, 40);
    [self.view addSubview: bt];
    [bt setTitle:@"非编" forState:UIControlStateNormal];
    bt.titleLabel.font = [UIFont systemFontOfSize:16];
    [bt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [bt addTarget:self action:@selector(btClicked) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton * bt1 = [UIButton buttonWithType:UIButtonTypeCustom];
    bt1.frame = CGRectMake(100, 200, 100, 40);
    [self.view addSubview: bt1];
    [bt1 setTitle:@"草稿箱" forState:UIControlStateNormal];
    bt1.titleLabel.font = [UIFont systemFontOfSize:16];
    [bt1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [bt1 addTarget:self action:@selector(bt1Clicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * bt2 = [UIButton buttonWithType:UIButtonTypeCustom];
    bt2.frame = CGRectMake(100, 300, 100, 40);
    [self.view addSubview: bt2];
    [bt2 setTitle:@"删除" forState:UIControlStateNormal];
    bt2.titleLabel.font = [UIFont systemFontOfSize:16];
    [bt2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [bt2 addTarget:self action:@selector(bt2Clicked) forControlEvents:UIControlEventTouchUpInside];
}

- (void)btClicked{
    
    JPNewCameraViewController * vc = [[JPNewCameraViewController alloc]initWithNibName:@"JPNewCameraViewController" bundle:[JPUtil bundleWithName:@"JPResource"]];
    
//    JPNewCameraViewController * vc = [[JPNewCameraViewController alloc]init];
    

    
    UINavigationController * navi = [[UINavigationController alloc]initWithRootViewController:vc];
    navi.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:navi animated:YES completion:nil];
}

- (void)bt1Clicked{
    
    [JPManager getLocalVideoDraft:^(NSArray<JPVideoRecordInfo *> * _Nonnull videoArray) {
       
        for (JPVideoRecordInfo * info in videoArray) {
            NSLog(@"info = %@",info);
        }
        
    }];
   
}

- (void)bt2Clicked{
    
    [JPManager getLocalVideoDraft:^(NSArray<JPVideoRecordInfo *> * _Nonnull videoArray) {
       
        for (JPVideoRecordInfo * info in videoArray) {
            [JPManager removeDraftWithVideo:info completion:^{
               
                [JPManager getLocalVideoDraft:^(NSArray<JPVideoRecordInfo *> * _Nonnull videoArray) {
                   
                    NSLog(@"%@",videoArray);
                    
                }];
                
            }];
        }
        
    }];
   
}


@end
