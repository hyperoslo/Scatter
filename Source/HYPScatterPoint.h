@import UIKit;
@import Foundation;

@interface HYPScatterPoint : NSObject

@property (nonatomic) UIColor *fillColor;
@property (nonatomic) UIColor *strokeColor;
@property (nonatomic) CGFloat x;
@property (nonatomic) CGFloat y;

- (instancetype)initWithValues:(UIColor *)fillColor strokeColor:(UIColor *)strokeColor x:(CGFloat)x y:(CGFloat)y;

@end
