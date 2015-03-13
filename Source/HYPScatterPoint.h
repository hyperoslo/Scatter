@import UIKit;
@import Foundation;

@interface HYPScatterPoint : NSObject
{
    
}
@property (nonatomic) UIColor *fillColor;
@property (nonatomic) UIColor *strokeColor;
@property (assign) CGFloat x;
@property (assign) CGFloat y;

- (id)initWithValues:(UIColor*)fillColor strokeColor:(UIColor*)strokeColor x:(CGFloat)x y:(CGFloat)y;

@end