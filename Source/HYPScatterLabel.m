
#import "HYPScatterLabel.h"

@implementation HYPScatterLabel
{
    
}

- (id)initWithText:(NSString*)text textColor:(UIColor*)textColor font:(UIFont*)font autosize:(BOOL)autoSizeText;
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
