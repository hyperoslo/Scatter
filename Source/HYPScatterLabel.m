
#import "HYPScatterLabel.h"

static const CGFloat HYPScatterLabelPercentageOfUsedScreenWidth = 0.05;

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

- (UIFont *)adjustedFontInRect:(CGRect)rect
{
    if (self.autoSizeText) {
        CGFloat scaledFontSize = HYPScatterLabelPercentageOfUsedScreenWidth * CGRectGetWidth(rect);
        self.font = [UIFont fontWithName:self.font.fontName size:scaledFontSize];
    }

    return self.font;
}

@end
