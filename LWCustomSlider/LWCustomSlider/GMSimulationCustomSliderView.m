//
//  GMSimulationCustomSliderView.m
//  Gengmei
//
//  Created by lwq on 2021/1/5.
//  Copyright © 2021 更美互动信息科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GMSimulationCustomSliderView.h"
#import "Masonry.h"
#define thumbBound_x 10
#define thumbBound_y 40
@interface GMMYSlider:UISlider
{
    CGRect lastBounds;
}
@end

@implementation GMMYSlider

- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value
{
    
    rect.origin.x= rect.origin.x-10;
    
    rect.size.width= rect.size.width+10;
    
    CGRect result = CGRectInset([super thumbRectForBounds:bounds trackRect:rect value:value],10,10);
    lastBounds = result;
    return result;
}


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    
    UIView *result = [super hitTest:point withEvent:event];
    if (point.x < 0 || point.x > self.bounds.size.width){
        return result;
    }
    
    if ((point.y >= -thumbBound_y) && (point.y < lastBounds.size.height + thumbBound_y)) {
        float value = 0.0;
        value = point.x - self.bounds.origin.x;
        value = value/self.bounds.size.width;
        
        value = value < 0? 0 : value;
        value = value > 1? 1: value;
        
        value = value * (self.maximumValue - self.minimumValue) + self.minimumValue;
        [self setValue:value animated:YES];
    }
    return result;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    BOOL result = [super pointInside:point withEvent:event];
    if (!result && point.y > -10) {
        if ((point.x >= lastBounds.origin.x - thumbBound_x) && (point.x <= (lastBounds.origin.x + lastBounds.size.width + thumbBound_x)) && (point.y < (lastBounds.size.height + thumbBound_y))) {
            result = YES;
        }
    }
    return result;
}

@end

@interface GMSimulationCustomSliderView ()
{
    CGFloat SLIDER_HEIGHT;
    CGFloat DOT_HEIGHT;
}
@property (nonatomic, strong) GMMYSlider *slider;
@property (nonatomic, strong) UIView *defaultDotView;
@property (nonatomic, strong) UIView *customSlipView;
@property (nonatomic, strong) UIImageView *orginImageView;
@property (nonatomic, strong) UIView *orginSlipView;
@property (nonatomic, strong) UIView *orginSlipRightView;
@property (nonatomic, assign) GMSliderDefalutType sliderType;

@property (nonatomic, strong) UIImageView *numberBgImageView;
@property (nonatomic, strong) UILabel *numberLable;

@end

@implementation GMSimulationCustomSliderView

- (void)setSliderValue:(CGFloat)value;
{
    _slider.value = value/100;
    [self updateSlipViewConstrantWithValue:value/100];
}

+ (instancetype)creatSimulationCustomSliderView:(GMSliderDefalutType)type {
    GMSimulationCustomSliderView *instance = [GMSimulationCustomSliderView new];
    instance.sliderType = type;
    [instance inintSubView];
    return instance;
}

- (void)setSliderDefalut:(GMSliderDefalutType)type {
    _sliderType = type;
    _slider.value = type == GMSliderDefalutTypeCenter? 0.50 : 0;
    if (type == GMSliderDefalutTypeCenter) {
        [_customSlipView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_offset(0);
            make.height.mas_offset(SLIDER_HEIGHT);
            make.left.mas_equalTo(self.slider.mas_left).mas_offset(self.bounds.size.width/2);
            make.centerY.mas_equalTo(self.orginSlipView.mas_centerY).mas_offset(0);
        }];
        [_defaultDotView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_offset(DOT_HEIGHT);
            make.centerY.mas_equalTo(self.orginSlipView.mas_centerY).mas_offset(0);
            make.centerX.mas_equalTo(self.slider.mas_centerX).mas_offset(2);
        }];
    }else{
        [_defaultDotView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_offset(DOT_HEIGHT);
            make.centerY.mas_equalTo(self.orginSlipView.mas_centerY).mas_offset(0);
            make.left.mas_equalTo(_slider.mas_left);
        }];
        [_customSlipView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_offset(0);
            make.height.mas_offset(SLIDER_HEIGHT);
            make.left.mas_equalTo(_slider.mas_left).mas_offset(0);
            make.centerY.mas_equalTo(self.orginSlipView.mas_centerY).mas_offset(0);
        }];
    }
    _numberLable.text = @"0";
}

/// 更新滑竿视图
/// @param value value description
- (void)updateSlipViewConstrantWithValue:(CGFloat)value {
    if (_sliderType == GMSliderDefalutTypeCenter) {
        if (value >= 0.5) {
            [_customSlipView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_offset((value-0.5)*self.bounds.size.width);
                make.height.mas_offset(SLIDER_HEIGHT);
                make.left.mas_equalTo(self.slider.mas_left).mas_offset(self.bounds.size.width/2);
                make.centerY.mas_equalTo(self.orginSlipView.mas_centerY).mas_offset(0);
            }];
            
            _numberLable.text = [NSString stringWithFormat:@"%.0f",(value-0.5)*100];
            
        }else{
            _numberLable.text = [NSString stringWithFormat:(value)>0.49?@"-1":@"-%.0f",(0.5-value)*100];
            
            [_customSlipView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_offset(value<0.01 ? self.bounds.size.width/2 - 3 :(0.5-value)*self.bounds.size.width);
                make.height.mas_offset(4);
                make.right.mas_equalTo(self.slider.mas_right).mas_offset(-self.bounds.size.width/2);
                make.centerY.mas_equalTo(self.orginSlipView.mas_centerY).mas_offset(0);
            }];
        }
        
    }else{
        [_customSlipView mas_remakeConstraints:^(MASConstraintMaker *make) {
            //            make.width.mas_offset(value * self.bounds.size.width);
            make.height.mas_offset(SLIDER_HEIGHT);
            make.left.mas_equalTo(_slider.mas_left).mas_offset(0);
            make.right.mas_equalTo(self.orginImageView.mas_left).mas_offset(0);
            make.centerY.mas_equalTo(self.orginSlipView.mas_centerY).mas_offset(0);
        }];
        _numberLable.text = [NSString stringWithFormat:@"%.0f",value*100];
    }
}

- (void)didChangeSliderValue:(UISlider *)slider {
    CGFloat value = slider.value;
    
    [self updateSlipViewConstrantWithValue:value];
    
    _numberBgImageView.hidden = NO;
    
}

- (void)hiddenNumberImageView {
    [UIView animateWithDuration:0.25 animations:^{
        self.numberBgImageView.alpha = 0;
    }completion:^(BOOL finished) {
        self.numberBgImageView.hidden = YES;
        self.numberBgImageView.alpha = 1;
    }];
}

- (void)sliderTouchDown {
    self.numberBgImageView.hidden = NO;
}

- (void)sliderTouchUpInSide {
    [self hiddenNumberImageView];
    
}

- (void)inintSubView {
    SLIDER_HEIGHT = 3;
    DOT_HEIGHT = 5;
    [self addSubview:self.slider];
    [_slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(35);
        make.left.mas_equalTo(self.mas_left).mas_offset(0);
        make.right.mas_equalTo(self.mas_right).mas_offset(0);
        make.top.bottom.mas_equalTo(self);
    }];
    
    [self addSubview:self.defaultDotView];
    [_defaultDotView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_offset(DOT_HEIGHT);
        make.centerY.mas_equalTo(self.slider.mas_centerY).mas_offset(0);
        make.left.mas_equalTo(_slider.mas_left);
    }];
    
    [self addSubview:self.customSlipView];
    [_customSlipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(0);
        make.height.mas_offset(SLIDER_HEIGHT);
        make.left.mas_equalTo(_slider.mas_left).mas_offset(0);
        make.centerY.mas_equalTo(self.slider.mas_centerY).mas_offset(0);
    }];
    
    
    [self layoutIfNeeded];
    NSArray *sliderSubViews = self.slider.subviews;
    @try {
        if (sliderSubViews.count == 1) {
            self.orginImageView = self.slider.subviews.firstObject.subviews[2];
            self.orginSlipView = self.slider.subviews.firstObject.subviews[1];
            self.orginSlipRightView = self.slider.subviews.firstObject.subviews[0];
        }else if (sliderSubViews.count >= 3){
            self.orginImageView = self.slider.subviews[2];
            self.orginSlipView = self.slider.subviews[1];
            self.orginSlipRightView = self.slider.subviews[0];
        }
    } @catch (NSException *exception) {
        
    } @finally {
            
    }
    
    [self insertSubview:_orginImageView belowSubview:self.customSlipView];
    [self insertSubview:_customSlipView belowSubview:self.defaultDotView];
    
    [self addSubview:self.numberBgImageView];
    [_numberBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_slider.mas_top).mas_offset(2);
        make.centerX.mas_equalTo(self.orginImageView.mas_centerX).mas_offset(0);
    }];
    
    self.orginSlipView.layer.cornerRadius = 1.5;
    self.orginSlipView.layer.masksToBounds = YES;
    self.orginSlipRightView.layer.cornerRadius = 1.5;
    self.orginSlipRightView.layer.masksToBounds = YES;
}

- (void)layoutSubviews
{
    CGRect rect = self.orginImageView.frame;
    self.orginImageView.frame = CGRectMake(rect.origin.x, rect.origin.y, 12, 12);
    CGRect slipRect = self.orginSlipView.frame;
    self.orginSlipView.frame = CGRectMake(slipRect.origin.x, slipRect.origin.y, slipRect.size.width, SLIDER_HEIGHT);
    CGRect slipRightRect = self.orginSlipRightView.frame;
    self.orginSlipRightView.frame = CGRectMake(slipRightRect.origin.x, slipRightRect.origin.y, slipRightRect.size.width, SLIDER_HEIGHT);
    CGPoint center = CGPointMake(self.orginImageView.center.x, self.defaultDotView.center.y+2);
    self.orginImageView.center = center;
    
}

- (GMMYSlider *)slider {
    if (!_slider) {
        _slider = [[GMMYSlider alloc] init];
        
        [_slider addTarget:self action:@selector(didChangeSliderValue:) forControlEvents:(UIControlEventValueChanged)];
        [_slider addTarget:self action:@selector(sliderTouchDown) forControlEvents:UIControlEventTouchDown];
        [_slider addTarget:self action:@selector(sliderTouchUpInSide) forControlEvents:UIControlEventTouchUpInside];
        _slider.minimumTrackTintColor = UIColor.whiteColor;
        _slider.maximumTrackTintColor = UIColor.whiteColor;
        _slider.thumbTintColor = UIColor.whiteColor;
        
        [_slider setThumbImage:[UIImage imageNamed:@"SimulationFaceSliderIcon"] forState:UIControlStateNormal];
        [_slider setThumbImage:[UIImage imageNamed:@"SimulationFaceSliderIcon"] forState:UIControlStateHighlighted];
        
    }
    return _slider;
}

- (UIView *)defaultDotView {
    if (!_defaultDotView) {
        _defaultDotView = [[UIView alloc] init];
        _defaultDotView.backgroundColor = UIColor.redColor;
        _defaultDotView.layer.cornerRadius = 2.5;
        _defaultDotView.layer.masksToBounds = YES;
    }
    return _defaultDotView;
}

- (UIView *)customSlipView {
    if (!_customSlipView) {
        _customSlipView = [[UIView alloc] init];
        _customSlipView.backgroundColor = UIColor.redColor;
    }
    return _customSlipView;
}

- (UIImageView *)numberBgImageView {
    if (!_numberBgImageView) {
        _numberBgImageView = [[UIImageView alloc] init];
        _numberBgImageView.image = [UIImage imageNamed:@"SimulationFaceSliderNumberBgIcon"];
        
        _numberLable = [[UILabel alloc] init];
        _numberLable.text = @"0";
        _numberLable.font = [UIFont systemFontOfSize:12];
        [_numberBgImageView addSubview:_numberLable];
        [_numberLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_numberBgImageView.mas_centerY).mas_offset(-5);
            make.centerX.mas_equalTo(_numberBgImageView.mas_centerX);
        }];
        _numberBgImageView.hidden = YES;
    }
    return _numberBgImageView;
}

@end
