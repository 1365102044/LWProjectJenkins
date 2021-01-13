//
//  GMSimulationCustomSliderView.h
//  LWCustomSlider
//
//  Created by lwq on 2021/1/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, GMSliderDefalutType) {
    GMSliderDefalutTypeLeft,
    GMSliderDefalutTypeCenter,
};
@interface GMSimulationCustomSliderView : UIView

- (void)setSliderDefalut:(GMSliderDefalutType)type;

+ (instancetype)creatSimulationCustomSliderView:(GMSliderDefalutType)type;

@end

NS_ASSUME_NONNULL_END
