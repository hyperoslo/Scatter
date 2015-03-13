
#import "HYPScatterLabel.h"

@implementation HYPScatterLabel

- (instancetype)initWithText:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font autosize:(BOOL)autoSize
{
    self = [self init];
    if (!self) return nil;
    
    _textColor = textColor;
    _text = text;
    _font = font;
    _autoSizeText = autoSize;
    
    return self;
}

@end
