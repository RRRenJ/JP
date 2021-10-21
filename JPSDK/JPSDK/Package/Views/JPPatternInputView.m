//
//  JPPatternInputView.m
//  jper
//
//  Created by 藩 亜玲 on 2017/6/6.
//  Copyright © 2017年 MuXiao. All rights reserved.
//

#import "JPPatternInputView.h"

#define MAX_POSITION_LENGTH    15

@interface JPPatternInputView()<UITextViewDelegate> {
    UITextView *txtView;
    UITextView *subTxtView;
    UILabel *subLb;
    UILabel *topLb;
    UILabel *lb;
    JPPatternInteractiveView *_patternInteractiveView;
}

- (void)createUI;

@end

@implementation JPPatternInputView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        [self createUI];
    }
    return self;
}

#pragma mark - 

- (void)createUI {
    UIView *tittleView = [[UIView alloc] initWithFrame:CGRectZero];
    [self addSubview:tittleView];
    tittleView.sd_layout.topSpaceToView(self, JPShrinkStatusBarHeight).leftEqualToView(self).rightEqualToView(self).heightIs(45);
    
    lb = [[UILabel alloc] initWithFrame:CGRectZero];
    lb.font = [UIFont jp_pingFangWithSize:12];
    lb.textColor = [UIColor whiteColor];
    lb.textAlignment = NSTextAlignmentCenter;
    lb.text = @"添加标题";
    [tittleView addSubview:lb];
    lb.sd_layout.leftEqualToView(tittleView).rightEqualToView(tittleView).topEqualToView(tittleView).bottomSpaceToView(tittleView, 1);
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectZero];
    lineView.backgroundColor = [UIColor jp_colorWithHexString:@"1e1f20"];
    [tittleView addSubview:lineView];
    lineView.sd_layout.bottomEqualToView(tittleView).leftSpaceToView(tittleView, 15).rightSpaceToView(tittleView, 15).heightIs(0.5);
    
    UIButton *dismissBtn = [JPUtil createCustomButtonWithTittle:nil
                                                      withImage:JPImageWithName(@"white-back")
                                                      withFrame:CGRectZero
                                                         target:self
                                                         action:@selector(dismiss:)];
    [tittleView addSubview:dismissBtn];
    dismissBtn.sd_layout.leftEqualToView(tittleView).bottomSpaceToView(tittleView, 1).heightIs(44).widthIs(45);
    
    UIButton *comfirBtn = [JPUtil createCustomButtonWithTittle:nil
                                                      withImage:JPImageWithName(@"confirm")
                                                      withFrame:CGRectZero
                                                         target:self
                                                         action:@selector(comfirm:)];
    [tittleView addSubview:comfirBtn];
    comfirBtn.sd_layout.rightEqualToView(tittleView).bottomSpaceToView(tittleView, 1).heightIs(44).widthIs(45);
    
    topLb = [[UILabel alloc] initWithFrame:CGRectZero];
    topLb.font = [UIFont jp_pingFangWithSize:12];
    topLb.textColor = [UIColor jp_colorWithHexString:@"525252"];
    topLb.textAlignment = NSTextAlignmentCenter;
    topLb.text = @"主标题";
    [self addSubview:topLb];
    topLb.sd_layout.topSpaceToView(tittleView, JPScreenFitFloat6(57)).leftEqualToView(self).rightEqualToView(self).heightIs(13);
    
    txtView = [[UITextView alloc] initWithFrame:CGRectZero];
    txtView.font = [UIFont jp_pingFangWithSize:21];
    txtView.textColor = [UIColor whiteColor];
    txtView.backgroundColor = [UIColor clearColor];
    txtView.delegate = self;
    txtView.textAlignment = NSTextAlignmentCenter;
    [self addSubview:txtView];
    txtView.sd_layout.topSpaceToView(topLb, JPScreenFitFloat6(25)).leftSpaceToView(self, 15).rightSpaceToView(self, 15).heightIs(60);
    
    subLb = [[UILabel alloc] initWithFrame:CGRectZero];
    subLb.font = [UIFont jp_pingFangWithSize:12];
    subLb.textColor = [UIColor jp_colorWithHexString:@"525252"];
    subLb.textAlignment = NSTextAlignmentCenter;
    subLb.hidden = YES;
    subLb.text = @"副标题";
    [self addSubview:subLb];
    subLb.sd_layout.topSpaceToView(topLb, JPScreenFitFloat6(128)).leftEqualToView(self).rightEqualToView(self).heightIs(13);
    
    subTxtView = [[UITextView alloc] initWithFrame:CGRectZero];
    subTxtView.font = [UIFont jp_pingFangWithSize:21];
    subTxtView.textColor = [UIColor whiteColor];
    subTxtView.backgroundColor = [UIColor clearColor];
    subTxtView.delegate = self;
    subTxtView.hidden = YES;
    subTxtView.textAlignment = NSTextAlignmentCenter;
    [self addSubview:subTxtView];
    subTxtView.sd_layout.topSpaceToView(subLb, JPScreenFitFloat6(25)).leftSpaceToView(self, 15).rightSpaceToView(self, 15).heightIs(60);
}

- (void)showWithPatternInteractiveView:(JPPatternInteractiveView *)patternInteractiveView {
    _patternInteractiveView = patternInteractiveView;
    txtView.text = _patternInteractiveView.patternAttribute.text;
    if (JPPackagePatternTypePosition == _patternInteractiveView.patternAttribute.patternType) {
        lb.text = @"编辑地理位置";
        topLb.hidden = YES;
    } else {
        lb.text = @"添加标题";
        topLb.hidden = NO;
    }
    if ([txtView.text isEqualToString:@"双击输入"]) {
        txtView.text = @"";
    }
    subTxtView.text = _patternInteractiveView.patternAttribute.subTitle;
    if ([subTxtView.text isEqualToString:@"添加副标题"]) {
        subTxtView.text = @"";
    }
    subLb.hidden = YES;
    subTxtView.hidden = YES;
    switch (patternInteractiveView.patternAttribute.patternType) {
        case JPPackagePatternTypeSixthTextPattern:
        case JPPackagePatternTypeNinthTextPattern:
        case JPPackagePatternTypeTenthTextPattern:
            subLb.hidden = NO;
            subTxtView.hidden = NO;
            break;
            
        default:
            break;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboradWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardwillhide:) name:UIKeyboardWillHideNotification object:nil];
    if (JPPackagePatternTypePosition == _patternInteractiveView.patternAttribute.patternType) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textViewEditChanged:)
                                                    name:UITextViewTextDidChangeNotification
                                                  object:txtView];
    }

    [txtView becomeFirstResponder];
}

#pragma mark - notification

- (void)keyboradWillShow:(NSNotification*)aNotification{
    NSDictionary* info = [aNotification userInfo];
    NSNumber *duration = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    [UIView animateWithDuration:[duration doubleValue] animations:^{
        self.top = 0;
    }];
}

- (void)keyboardwillhide:(NSNotification*)aNotification{
    NSDictionary* info = [aNotification userInfo];
    NSNumber *duration = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    [UIView animateWithDuration:[duration doubleValue] animations:^{
        self.top = JP_SCREEN_HEIGHT;
    }completion:^(BOOL finish){
        [self removeFromSuperview];
    }];
}

-(void)textViewEditChanged:(NSNotification*)notification{
    
    UITextView *textView = (UITextView *)notification.object;
    
    NSString *toBeString = textView.text;
    NSString *lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage; // 键盘输入模式
    if([lang isEqualToString:@"zh-Hans"]) { //简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textView markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        //没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if(!position) {
            if(toBeString.length > MAX_POSITION_LENGTH) {
                textView.text = [toBeString substringToIndex:MAX_POSITION_LENGTH];
            }
        } else{//有高亮选择的字符串，则暂不对文字进行统计和限制
            if(toBeString.length > MAX_POSITION_LENGTH) {
                textView.text = [toBeString substringToIndex:MAX_POSITION_LENGTH];
            }
        }
    }else{ //中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        if(toBeString.length > MAX_POSITION_LENGTH) {
            textView.text= [toBeString substringToIndex:MAX_POSITION_LENGTH];
        }
    }
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    return YES;
}

#pragma mark - 

- (void)dismiss {
    if ([txtView isFirstResponder]) {
        [txtView resignFirstResponder];
    }
    if ([subTxtView isFirstResponder]) {
        [subTxtView resignFirstResponder];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    if (JPPackagePatternTypePosition == _patternInteractiveView.patternAttribute.patternType) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(patternInputViewWillDismiss)]) {
        [self.delegate patternInputViewWillDismiss];
    }
}

- (void)dismiss:(id)sender {
    [self dismiss];
}

- (void)comfirm:(id)sender {
    _patternInteractiveView.patternAttribute.text = txtView.text;
    if (txtView.text == nil ||txtView.text.length == 0) {
        _patternInteractiveView.patternAttribute.text = @"双击输入";
//        if (JPPackagePatternTypePosition == _patternInteractiveView.patternAttribute.patternType) {
//            _patternInteractiveView.patternAttribute.text = [JPSession sharedInstance].cityName;
//        }
    }
    _patternInteractiveView.patternAttribute.subTitle = subTxtView.text;
    if (subTxtView.text == nil ||subTxtView.text.length == 0) {
        _patternInteractiveView.patternAttribute.subTitle = @"添加副标题";
    }
    [_patternInteractiveView updateContent];
    [self dismiss:nil];
}

@end
