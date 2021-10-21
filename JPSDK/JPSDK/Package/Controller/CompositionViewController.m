//
//  CompositionViewController.m
//  JPSDK
//
//  Created by 任敬 on 2021/10/19.
//

#import "CompositionViewController.h"

@interface CompositionViewController ()<JPCompositionManagerDelegate>

@property (nonatomic, strong) UILabel * progressLb;

@end

@implementation CompositionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    [self.view addSubview:self.progressLb];
    self.progressLb.frame = CGRectMake(100, 100, 100, 30);
    self.manager.delegate = self;
    [self.manager startComposition];
}

#pragma - mark init view
- (void)setupViews{
    self.view.backgroundColor = UIColor.whiteColor;
}

- (void)compositionStatusChangeed:(JPCompositionManager *)compositionManager{
    if (compositionManager.compositinType == JPCompositionTypeCompositioning) {
        self.progressLb.text = [NSString stringWithFormat:@"%.2f",compositionManager.compositionProgress];
    }else if(compositionManager.compositinType == JPCompositionTypeCompositioned){
        self.progressLb.text = @"完成";
    }else if (compositionManager.compositinType == JPCompositionTypeCompositionFaild){
        self.progressLb.text = @"失败";
    }
   
}

- (void)compositionErrorWillBackToPage {
    
}


- (void)compositionErrorWillEndEdit {
    
}



#pragma - mark request


#pragma - mark set


#pragma - mark get
- (UILabel *)progressLb{
    if (!_progressLb) {
        _progressLb = [[UILabel alloc]init];
        _progressLb.textColor = UIColor.blackColor;
        _progressLb.font = [UIFont systemFontOfSize:15];
    }
    return _progressLb;
}










@end
