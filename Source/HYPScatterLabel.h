@import UIKit;
@import Foundation;

@interface HYPScatterLabel : NSObject

@property (nonatomic) UIColor *textColor;
@property (nonatomic) NSString *text;
@property (nonatomic) UIFont *font;
@property (assign) BOOL autoSizeText;

- (instancetype)initWithText:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font autosize:(BOOL)autoSize;

@end
