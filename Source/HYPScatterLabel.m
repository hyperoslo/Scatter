
#import "HYPScatterLabel.h"

@implementation HYPScatterLabel

- (instancetype)initWithText:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font autoSizeText:(BOOL)autoSizeText
{
    self = [self init];
    if (!self) return nil;

    _textColor = textColor;
    _text = text;
    _font = font;
    _autoSizeText = autoSizeText;

    return self;
}

@end
