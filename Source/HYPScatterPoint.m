#import "HYPScatterPoint.h"

@implementation HYPScatterPoint

- (instancetype)initWithValues:(UIColor *)fillColor strokeColor:(UIColor *)strokeColor x:(CGFloat)x y:(CGFloat)y;
{
    self = [self init];
    if (!self) return nil;
    
    _fillColor = fillColor;
    _strokeColor = strokeColor;
    _x = x;
    _y = y;
    
    return self;
}

@end
