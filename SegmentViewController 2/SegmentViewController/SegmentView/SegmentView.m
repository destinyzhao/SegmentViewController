//
//  SegmentView.m
//  SegmentView
//
//  Created by Alex on 16/4/8.
//  Copyright © 2016年 Alex. All rights reserved.
//

#import "SegmentView.h"
#import "UIColor+RGBColor.h"

#define BUTTON_TAG 10000

@interface SegmentView ()

/**
 *  上一次选中button
 */
@property (strong, nonatomic) UIButton *lastSeletedButton;
/**
 *  线
 */
@property (strong, nonatomic) UIImageView *lineView;
/**
 *  segment width
 */
@property (assign, nonatomic) CGFloat segmentWidth;
/**
 *  存储segmentButton
 */
@property (strong, nonatomic) NSMutableArray *segmentButtonArray;

@end

@implementation SegmentView

#define APP_BASE_COLOR [UIColor getColorWithHexString:@"FF6370"]

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSetting];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initSetting];
    }
    return self;
}

- (void)initSetting
{
    self.backgroundColor = [UIColor whiteColor];
    
    _segmentButtonArray = [NSMutableArray array];
    
    _lineView = [UIImageView new];
    _lineView.backgroundColor = APP_BASE_COLOR;
    [self addSubview:_lineView];
}

/**
 *  setter title Array
 *
 *  @param titleArray 
 */
- (void)setTitleArray:(NSArray *)titleArray
{
    _titleArray = titleArray;
    
    [self createSegmentWithTitleArray:_titleArray];
}

/**
 *  创建Segment
 *
 *  @param titleArray 标题数组
 */
- (void)createSegmentWithTitleArray:(NSArray *)titleArray
{
    CGRect bonds = [[UIScreen mainScreen] bounds];
    CGFloat width = bonds.size.width/titleArray.count;
    _segmentWidth = width;
    
    [titleArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *segmentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        segmentBtn.frame = CGRectMake(idx*width, 0, width, self.frame.size.height-2);
        [segmentBtn setTitleColor:APP_BASE_COLOR forState:UIControlStateSelected];
        [segmentBtn setTitleColor:[UIColor getColorWithHexString:@"A1A1A1"] forState:UIControlStateNormal];
        [segmentBtn setTitle:titleArray[idx] forState:UIControlStateNormal];
        [segmentBtn addTarget:self action:@selector(segmentClicked:) forControlEvents:UIControlEventTouchUpInside];
        segmentBtn.titleLabel.font = [UIFont systemFontOfSize:14.];
        segmentBtn.tag = idx + BUTTON_TAG;
        if (idx == 0) {
            segmentBtn.selected = YES;
            _lastSeletedButton = segmentBtn;
            [self segmentClicked:segmentBtn];
        }
        [self addSubview: segmentBtn];
        
        [_segmentButtonArray addObject:segmentBtn];
    }];
}

/**
 *  Block
 *
 *  @param segmentBlock 
 */
- (void)segmentBlock:(SegmentBlock)segmentBlock
{
    self.segmentBlock = segmentBlock;
}

/**
 *  按钮点击事件
 *
 *  @param sender
 */
- (void)segmentClicked:(UIButton *)sender
{
    [self exchangeButtonSelected:sender];
    [self lineAsLongAsSegmentButtonAnimation:sender];
    NSInteger tag = sender.tag;
    if (_segmentBlock != nil) {
        _segmentBlock(tag - BUTTON_TAG);
    }
}

/**
 *  交换按钮选中状态
 *
 *  @param sender
 */
- (void)exchangeButtonSelected:(UIButton *)sender
{
    _lastSeletedButton.selected = NO;
    sender.selected = YES;
    _lastSeletedButton = sender;
}

/**
 *  线和Segment一样长
 *
 *  @param sender
 */
- (void)lineAsLongAsSegmentButtonAnimation:(UIButton *)sender
{
    [UIView animateWithDuration:0.1 animations:^{
        _lineView.frame = CGRectMake(sender.frame.origin.x, self.frame.size.height-2, _segmentWidth, 2);
    } completion:^(BOOL finished) {
        
    }];
}

/**
 *  线和文本一样长动画
 *
 *  @param sender
 */
- (void)lineAsLongAsTextAnimation:(UIButton *)sender
{
    CGFloat lineWidth = [self sizeWithText:sender.titleLabel.text font:sender.titleLabel.font maxSize:sender.frame.size].width;
    
    [UIView animateWithDuration:0.1 animations:^{
        _lineView.frame = CGRectMake(sender.frame.origin.x +((_segmentWidth-lineWidth)/2), self.frame.size.height-2, lineWidth, 2);
    } completion:^(BOOL finished) {
        
    }];
}

/**
 *  计算文字Size
 *
 *  @param text    文本
 *  @param font    字号
 *  @param maxSize 最大Size
 *
 *  @return Size
 */
-(CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

/**
 *  设置当前选中的Button
 *
 *  @param currentSelectedIndex
 */
- (void)setCurrentSelectedIndex:(NSInteger)currentSelectedIndex
{
    UIButton *btn = (UIButton *)[self viewWithTag:currentSelectedIndex + BUTTON_TAG];
    //[self segmentClicked:btn];
    
    [self exchangeButtonSelected:btn];
    [self lineAsLongAsSegmentButtonAnimation:btn];
}

/**
 *  更新按钮标题
 *
 *  @param updateTitleArray 
 */
- (void)setUpdateTitleArray:(NSArray *)updateTitleArray
{
    [_segmentButtonArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *segmentBtn = (UIButton *)obj;
        [segmentBtn setTitle:updateTitleArray[idx]  forState:UIControlStateNormal];
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
