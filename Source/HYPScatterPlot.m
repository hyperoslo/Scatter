
@import CoreText;

#import "HYPScatterPlot.h"

#import "HYPScatterPoint.h"
#import "HYPScatterLabel.h"

#import "UIColor+Hex.h"

static CGFloat graphWidth = 0.0f;
static CGFloat graphHeight = 0.0f;

static CGFloat kCircleRadius = 7.0f;
static CGFloat kPadding = 10.0f;

static NSString * bgColor = @"0E223D";
static NSString * xLineColor = @"EC3031";

@interface HYPScatterPlot()

@end

@implementation HYPScatterPlot

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
    if (self.backgroundColor == nil) self.backgroundColor = [UIColor colorFromHex:bgColor];
    if (self.xAxisColor == nil) self.xAxisColor = [UIColor colorFromHex:xLineColor];
    if (self.avgLineColor == nil) self.avgLineColor = [UIColor whiteColor];
    if (self.yAxisMidGradient == nil) self.yAxisMidGradient = [UIColor whiteColor];
    if (self.yAxisEndGradient == nil) self.yAxisEndGradient = [UIColor colorFromHex:bgColor];
    
    return self;
}

- (void)drawLabels:(CGContextRef)context rect:(CGRect)rect
{
    if ([self.delegate respondsToSelector:@selector(maximumYLabel:)]) {
        HYPScatterLabel *maxYLabel = [self.delegate maximumYLabel:self];
        UIFont *font = [self getAdjustedFont:maxYLabel rect:rect];
        CGPoint point = CGPointMake(0, CGRectGetMaxY(rect) - font.lineHeight);
        [self drawTextFor:context rect:rect label:maxYLabel font:font alignment:NSTextAlignmentCenter point:point];
    }
    
    if ([self.delegate respondsToSelector:@selector(minimumYLabel:)]) {
        HYPScatterLabel *minYLabel = [self.delegate minimumYLabel:self];
        UIFont *font = [self getAdjustedFont:minYLabel rect:rect];
        CGPoint point = CGPointMake(0, CGRectGetMinY(rect));
        [self drawTextFor:context rect:rect label:minYLabel font:font alignment:NSTextAlignmentCenter point:point];
    }
    
    if ([self.delegate respondsToSelector:@selector(minimumXLabel:)]) {
        HYPScatterLabel *minXLabel = [self.delegate minimumXLabel:self];
        UIFont *font = [self getAdjustedFont:minXLabel rect:rect];
        CGPoint point = CGPointMake(CGRectGetMinX(rect) + kPadding, CGRectGetMinY(rect));
        [self drawTextFor:context rect:rect label:minXLabel font:font alignment:NSTextAlignmentLeft point:point];
    }
    
    if ([self.delegate respondsToSelector:@selector(maximumXLabel:)]) {
        HYPScatterLabel *maxXLabel = [self.delegate maximumXLabel:self];
        UIFont *font = [self getAdjustedFont:maxXLabel rect:rect];
        CGPoint point = CGPointMake(CGRectGetMaxX(rect) - CGRectGetMinX(rect) - kPadding, CGRectGetMinY(rect));
        [self drawTextFor:context rect:rect label:maxXLabel font:font alignment:NSTextAlignmentRight point:point];
    }
}

//determines the correct font size based on whether auto_size_text is YES or NO
- (UIFont *)getAdjustedFont:(HYPScatterLabel *)label rect:(CGRect)rect
{
    //we use 6% of the drawing area width as size of font if auto_size_text option is YES
    CGFloat scaledFontSize = (0.05) * CGRectGetWidth(rect);
    UIFont *font = label.font;
    
    if (label.autoSizeText == YES) {
        font = [UIFont fontWithName:label.font.fontName size:scaledFontSize];
    }

    return font;
}

//for drawing text at different points in the drawing area using core text api
- (void)drawTextFor:(CGContextRef)context rect:(CGRect)rect label:(HYPScatterLabel *)label font:(UIFont *)font alignment:(NSTextAlignment)alignment point:(CGPoint)point
{
    //  Note: we can't get a perfect bounding box for the text as the methods that are suppose to do it are buggy:
    //  http://stackoverflow.com/a/7014352/550393
    CTFontRef fontRef = CTFontCreateWithName((CFStringRef)font.fontName, font.pointSize, NULL);
    NSDictionary *attrDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                    CFBridgingRelease(fontRef), (NSString*)kCTFontAttributeName,
                                    (id)label.textColor.CGColor, (NSString*)kCTForegroundColorAttributeName,
                                    nil];
    
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:label.text attributes:attrDictionary];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init] ;
    [paragraphStyle setAlignment:alignment];
    
    [attString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [label.text length])];
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attString);
    
    CGRect textRect =  CGRectMake(point.x, point.y, CGRectGetMinX(rect), ceilf(font.lineHeight));
    CGPathAddRect(path, NULL, textRect);
    CTFrameRef theFrame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, [attString length]), path, NULL);
    
    CFRelease(framesetter);
    CFRelease(path);
    
    CTFrameDraw(theFrame, context); //draw text
    
    CFRelease(theFrame);
    
    //  un-comment to see the bounding box of the drawn text
/*
    CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextAddRect(context,textRect);
    CGContextDrawPath(context, kCGPathFillStroke);
*/
}

- (void)drawAxes:(CGContextRef)context rect:(CGRect)rect;
{
    CGFloat locations[3] = {0.0, 0.65, 1.0};

    NSArray *colors = [NSArray arrayWithObjects:
                       (id)self.yAxisEndGradient.CGColor,
                       (id)self.yAxisMidGradient.CGColor,
                       (id)self.yAxisEndGradient.CGColor, nil];
    
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColors(colorspace, (CFArrayRef)colors, locations);

    //  gradient based y-axis on left side
    //  where the gradient pattern will start and end
    CGPoint startPoint = CGPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMinX(rect), CGRectGetMaxY(rect));
    
    CGContextSaveGState(context);
    CGContextAddRect(context, CGRectMake(CGRectGetMinX(rect), CGRectGetMinY(rect), 1, CGRectGetMaxY(rect)));
    CGContextClip(context);
    CGContextDrawLinearGradient (context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    
    //  gradient based y-axis on right side
    startPoint = CGPointMake(CGRectGetMaxX(rect), CGRectGetMinY(rect));
    endPoint = CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect));
    
    CGContextSaveGState(context);
    CGContextAddRect(context, CGRectMake(CGRectGetMaxX(rect), CGRectGetMinY(rect), 1, CGRectGetMaxY(rect)));
    CGContextClip(context);
    CGContextDrawLinearGradient (context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    
    // release the color resources
    CGColorSpaceRelease(colorspace);
    CGGradientRelease(gradient);
}

- (void)drawPoints:(CGContextRef)context rect:(CGRect)rect
{
    NSArray* scatterPoints = [self.delegate pointForScatterPlot:self];
    
    HYPScatterPoint *maxHorizontal = [self.delegate maximumXValue:self];
    HYPScatterPoint *minHorizontal = [self.delegate minimumXValue:self];
    HYPScatterPoint *maxVertical = [self.delegate maximumYValue:self];
    HYPScatterPoint *minVertical = [self.delegate minimumYValue:self];
    
    /*
        min_horizontal and max_horizontal are the left and right boundaries between which the graph is drawn
    
     min_horizontal or 0   max_horizontal
        <-----------------------------------> min_vertical or 0
            |                   |
            |                   |
            |                   |
            |                   |
        <-----------------------------------> max_vertical
     
        max_vertical and min_vertical are the top and bottom boundaries between which the graph is drawn
     */
    
    //  we shift all x values translate_x_by amount so that the min_horizontal value starts at 0
    CGFloat translateXBy = -minHorizontal.x;

    //  we shift all y values translate_y_by amount
    //  we shouldn't shift y values if minimum y value is non-zero as we have to draw the horizontal line where y=0
    CGFloat translateYBy = -minVertical.y;
    if (minVertical.y > 0) translateYBy = 0.0f;
    
    //draw a horizontal line where y=0
    CGContextSetLineWidth(context, 2);
    CGContextSetStrokeColorWithColor(context, self.xAxisColor.CGColor);
    
    //through out the following code CGRectGetMinY and CGRectGetMinX help us get the margins for the drawing box
    CGFloat zeroLine = translateYBy;
    
    //normalized co-ordinate of the horizontal line indicating where is y = 0
    zeroLine = zeroLine / (maxVertical.y + translateYBy) * graphHeight + CGRectGetMinY(rect);
    
    CGContextMoveToPoint(context, 0, zeroLine);
    CGContextAddLineToPoint(context, self.bounds.size.width, zeroLine);
    
    CGContextStrokePath(context);
    
    //draw a horizontal line on average value of y
    if ([self.delegate respondsToSelector:@selector(avgYValue:)]) {
        CGFloat avgVertical = [self.delegate avgYValue:self];
        
        CGContextSetLineWidth(context, 2);
        CGContextSetStrokeColorWithColor(context, self.avgLineColor.CGColor);
        CGFloat dash[] = {6.0, 6.0};
        CGContextSetLineDash(context, 0.0, dash, 2);

        //  normalization is done by dividing a value by maximum value in the list, see below inside for loop
        CGFloat avgLine = (avgVertical + translateYBy) / (maxVertical.y + translateYBy) * graphHeight + CGRectGetMinY(rect);
        
        CGContextMoveToPoint(context, 0, avgLine);
        CGContextAddLineToPoint(context, self.bounds.size.width, avgLine);
        CGContextStrokePath(context);
        CGContextSetLineDash(context, 0, NULL, 0);  //remove the dash
        
        HYPScatterLabel* avgLabel = [self.delegate avgLabel:self];
        UIFont *font = [self getAdjustedFont:avgLabel rect:rect];
        CGPoint point = CGPointMake(0, avgLine);
        [self drawTextFor:context rect:rect label:avgLabel font:font alignment:NSTextAlignmentCenter point:point];
    }
    
    
    for (int pointNo=0; pointNo < scatterPoints.count; pointNo++) {
        //  normalization is done by dividing a value by maximum value in the list
        //  for each point get their normalized co-ordinates with respect to the height and width of the drawing space
        HYPScatterPoint *point = scatterPoints[pointNo];
        CGFloat x = (point.x + translateXBy) / (maxHorizontal.x + translateXBy) * graphWidth + CGRectGetMinX(rect);
        CGFloat y = (point.y + translateYBy) / (maxVertical.y + translateYBy) * graphHeight + CGRectGetMinY(rect);
        
        //draw the point as circle
        CGRect rect = CGRectMake(x-kCircleRadius, y-kCircleRadius, 2*kCircleRadius, 2*kCircleRadius);
        CGContextSetStrokeColorWithColor(context, point.strokeColor.CGColor);
        CGContextSetFillColorWithColor(context, point.fillColor.CGColor);
        CGContextAddEllipseInRect(context, rect);
        CGContextDrawPath(context, kCGPathFillStroke);
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGRect drawInRect = CGRectInset(rect, 0.10 * rect.size.width, 15);
    drawInRect = CGRectOffset(drawInRect, 0.07 * rect.size.width, 0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //  width and height of the bounding box inside which the graph is drawn
    graphWidth = CGRectGetWidth(drawInRect);
    graphHeight = CGRectGetHeight(drawInRect);
    
    //un-comment to see the bounding box of the drawing area
    /*
    CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextAddRect(context, newRect);
    CGContextDrawPath(context, kCGPathFillStroke);
    */
    
    // flip the co-ordinate system
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    [self drawAxes:context rect:drawInRect];
    [self drawLabels:context rect:drawInRect];
    [self drawPoints:context rect:drawInRect];
}

@end
