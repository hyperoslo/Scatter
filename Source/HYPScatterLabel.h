@import UIKit;
@import Foundation;

@interface HYPScatterLabel : NSObject
{
    
}
@property (nonatomic) UIColor *textColor;
@property (nonatomic) NSString* text;
@property (nonatomic) UIFont* font; //the font to use for drawing the label
@property (assign) BOOL autoSizeText;   //if YES then ignore the size specified in font property

- (id)initWithText:(NSString*)text textColor:(UIColor*)textColor font:(UIFont*)font autosize:(BOOL)autoSizeText;

@end