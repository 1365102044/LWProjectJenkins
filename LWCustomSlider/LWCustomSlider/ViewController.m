//
//  ViewController.m
//  LWCustomSlider
//
//  Created by lwq on 2021/1/4.
//

#import "ViewController.h"
#import "GMSimulationCustomSliderView.h"
#import "Masonry.h"
@interface ViewController ()
@property (nonatomic, strong) GMSimulationCustomSliderView *sliderView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *btn1 = [UIButton new];
    btn1.backgroundColor = UIColor.redColor;
    [self.view addSubview:btn1];
    [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(100);
        make.height.mas_offset(30);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-50);
        make.top.mas_equalTo(self.view.mas_top).mas_offset(100);
    }];
    
    UIButton *btn2 = [UIButton new];
    btn2.backgroundColor = UIColor.redColor;
    [self.view addSubview:btn2];
    [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(100);
        make.height.mas_offset(30);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-50);
        make.top.mas_equalTo(self.view.mas_top).mas_offset(100+60);
    }];
    [btn1 addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [btn2 addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    btn1.tag = 1;
    btn2.tag = 2;
    
    self.view.backgroundColor = UIColor.grayColor;
    
    GMSimulationCustomSliderView *sliderView = [GMSimulationCustomSliderView creatSimulationCustomSliderView:(GMSliderDefalutTypeLeft)];
    [self.view addSubview:sliderView];
    
    [sliderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.centerY.mas_equalTo(self.view);
        make.width.mas_offset(350);
    }];
    _sliderView = sliderView;
}

- (void)clickBtn:(UIButton *)sender {
    NSInteger tag = sender.tag;
    if (tag == 1) {
        [_sliderView setSliderDefalut:(GMSliderDefalutTypeLeft)];
    }else{
        [_sliderView setSliderDefalut:(GMSliderDefalutTypeCenter)];
    }
}
@end
