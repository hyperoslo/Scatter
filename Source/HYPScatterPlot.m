
@import CoreText;

#import "HYPScatterPlot.h"

#import "HYPScatterPoint.h"
#import "HYPScatterLabel.h"

#import "UIColor+Hex.h"

static const CGFloat HYPScatterPlotCircleRadius = 7.0f;
static const CGFloat HYPScatterPlotPadding = 10.0f;

static NSString * const HYPScatterPlotBackgroundColor = @"0E223D";
static NSString * const HYPScatterPlotXLineColor = @"EC3031";

@interface HYPScatterPlot()

@property (nonatomic) CGFloat graphWidth;
@property (nonatomic) CGFloat graphHeight;

@end

@implementation HYPScatterPlot

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;

    if (self.backgroundColor) {
        self.backgroundColor = [UIColor colorFromHex:HYPScatterPlotBackgroundColor];
    }

    if (!self.xAxisColor) {
        self.xAxisColor = [UIColor colorFromHex:HYPScatterPlotXLineColor];
    }

    if (!self.averageLineColor) {
        self.averageLineColor = [UIColor whiteColor];
    }

    if (!self.yAxisMidGradient) {
        self.yAxisMidGradient = [UIColor whiteColor];
    }

    if (!self.yAxisEndGradient) {
        self.yAxisEndGradient = [UIColor colorFromHex:HYPScatterPlotBackgroundColor];
    }

    return self;
}

- (void)drawLabels:(CGContextRef)context rect:(CGRect)rect
{
    if ([self.dataSource respondsToSelector:@selector(maximumYLabel:)]) {
        HYPScatterLabel *maximumYLabel = [self.dataSource maximumYLabel:self];
        UIFont *font = [maximumYLabel adjustedFontInRect:rect];
        CGPoint point = CGPointMake(0, CGRectGetMaxY(rect) - font.lineHeight);
        [self drawTextInContext:context rect:rect label:maximumYLabel font:font alignment:NSTextAlignmentCenter point:point];
    }

    if ([self.dataSource respondsToSelector:@selector(minimumYLabel:)]) {
        HYPScatterLabel *minimumYLabel = [self.dataSource minimumYLabel:self];
        UIFont *font = [minimumYLabel adjustedFontInRect:rect];
        CGPoint point = CGPointMake(0, CGRectGetMinY(rect));
        [self drawTextInContext:context rect:rect label:minimumYLabel font:font alignment:NSTextAlignmentCenter point:point];
    }

    if ([self.dataSource respondsToSelector:@selector(minimumXLabel:)]) {
        HYPScatterLabel *minimumXLabel = [self.dataSource minimumXLabel:self];
        UIFont *font = [minimumXLabel adjustedFontInRect:rect];
        CGPoint point = CGPointMake(CGRectGetMinX(rect) + HYPScatterPlotPadding, CGRectGetMinY(rect));
        [self drawTextInContext:context rect:rect label:minimumXLabel font:font alignment:NSTextAlignmentLeft point:point];
    }

    if ([self.dataSource respondsToSelector:@selector(maximumXLabel:)]) {
        HYPScatterLabel *maximumXLabel = [self.dataSource maximumXLabel:self];
        UIFont *font = [maximumXLabel adjustedFontInRect:rect];
        CGPoint point = CGPointMake(CGRectGetMaxX(rect) - CGRectGetMinX(rect) - HYPScatterPlotPadding, CGRectGetMinY(rect));
        [self drawTextInContext:context rect:rect label:maximumXLabel font:font alignment:NSTextAlignmentRight point:point];
    }
}

- (void)drawTextInContext:(CGContextRef)context rect:(CGRect)rect label:(HYPScatterLabel *)label font:(UIFont *)font alignment:(NSTextAlignment)alignment point:(CGPoint)point
{
    //  Note: we can't get a perfect bounding box for the text as the methods that are suppose to do it are buggy:
    //  http://stackoverflow.com/a/7014352/550393
    CTFontRef fontRef = CTFontCreateWithName((CFStringRef)font.fontName, font.pointSize, NULL);
    NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                          CFBridgingRelease(fontRef), (NSString*)kCTFontAttributeName,
                                          (id)label.textColor.CGColor, (NSString*)kCTForegroundColorAttributeName,
                                          nil];

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:label.text attributes:attributesDictionary];

    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = alignment;

    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [label.text length])];

    CGMutablePathRef path = CGPathCreateMutable();

    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attributedString);

    CGRect textRect = CGRectMake(point.x, point.y, CGRectGetMinX(rect), ceilf(font.lineHeight));
    CGPathAddRect(path, NULL, textRect);
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, [attributedString length]), path, NULL);

    CFRelease(framesetter);
    CFRelease(path);

    CTFrameDraw(frame, context);

    CFRelease(frame);
}

- (void)drawAxes:(CGContextRef)context rect:(CGRect)rect
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
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);

    // gradient based y-axis on right side
    startPoint = CGPointMake(CGRectGetMaxX(rect), CGRectGetMinY(rect));
    endPoint = CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect));
    CGContextSaveGState(context);
    CGContextAddRect(context, CGRectMake(CGRectGetMaxX(rect), CGRectGetMinY(rect), 1, CGRectGetMaxY(rect)));
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);

    CGColorSpaceRelease(colorspace);
    CGGradientRelease(gradient);
}

- (void)drawPoints:(CGContextRef)context rect:(CGRect)rect
{
    NSArray *scatterPoints = [self.dataSource pointsForScatterPlot:self];

    HYPScatterPoint *maximumHorizontalPoint = [self.dataSource maximumXValue:self];
    HYPScatterPoint *minimumHorizontalPoint = [self.dataSource minimumXValue:self];
    HYPScatterPoint *maximumVerticalPoint = [self.dataSource maximumYValue:self];
    HYPScatterPoint *minimumVerticalPoint = [self.dataSource minimumYValue:self];

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

    // we shift all x values translate_x_by amount so that the min_horizontal value starts at 0
    CGFloat translateXBy = -minimumHorizontalPoint.x;

    //  we shift all y values translate_y_by amount
    //  we shouldn't shift y values if minimum y value is non-zero as we have to draw the horizontal line where y=0
    CGFloat translateYBy = -minimumVerticalPoint.y;
    if (minimumVerticalPoint.y > 0) {
        translateYBy = 0.0f;
    }

    // draw a horizontal line where y = 0
    CGContextSetLineWidth(context, 2);
    CGContextSetStrokeColorWithColor(context, self.xAxisColor.CGColor);

    // through out the following code CGRectGetMinY and CGRectGetMinX help us get the margins for the drawing box
    CGFloat zeroLine = translateYBy;

    // normalized co-ordinate of the horizontal line indicating where is y = 0
    zeroLine = zeroLine / (maximumVerticalPoint.y + translateYBy) * self.graphHeight + CGRectGetMinY(rect);

    CGContextMoveToPoint(context, 0, zeroLine);
    CGContextAddLineToPoint(context, self.bounds.size.width, zeroLine);

    CGContextStrokePath(context);

    // draw a horizontal line on average value of y
    if ([self.dataSource respondsToSelector:@selector(averageYValue:)]) {
        CGFloat averageVertical = [self.dataSource averageYValue:self];

        CGContextSetLineWidth(context, 2);
        CGContextSetStrokeColorWithColor(context, self.averageLineColor.CGColor);
        CGFloat dash[] = {6.0, 6.0};
        CGContextSetLineDash(context, 0.0, dash, 2);

        // normalization is done by dividing a value by maximum value in the list, see below inside for loop
        CGFloat averageLine = (averageVertical + translateYBy) / (maximumVerticalPoint.y + translateYBy) * self.graphHeight + CGRectGetMinY(rect);

        CGContextMoveToPoint(context, 0, averageLine);
        CGContextAddLineToPoint(context, self.bounds.size.width, averageLine);
        CGContextStrokePath(context);
        CGContextSetLineDash(context, 0, NULL, 0);  //remove the dash

        HYPScatterLabel *averageLabel = [self.dataSource averageLabel:self];
        UIFont *font = [averageLabel adjustedFontInRect:rect];
        CGPoint point = CGPointMake(0, averageLine);
        [self drawTextInContext:context rect:rect label:averageLabel font:font alignment:NSTextAlignmentCenter point:point];
    }


    for (NSInteger index = 0; index < scatterPoints.count; index++) {
        // normalization is done by dividing a value by maximum value in the list
        // for each point get their normalized co-ordinates with respect to the height and width of the drawing space
        HYPScatterPoint *point = scatterPoints[index];
        CGFloat x = (point.x + translateXBy) / (maximumHorizontalPoint.x + translateXBy) * self.graphWidth + CGRectGetMinX(rect);
        CGFloat y = (point.y + translateYBy) / (maximumVerticalPoint.y + translateYBy) * self.graphHeight + CGRectGetMinY(rect);

        // draw the point as circle
        CGRect rect = CGRectMake(x - HYPScatterPlotCircleRadius, y - HYPScatterPlotCircleRadius, 2 * HYPScatterPlotCircleRadius, 2 * HYPScatterPlotCircleRadius);
        CGContextSetStrokeColorWithColor(context, point.strokeColor.CGColor);
        CGContextSetFillColorWithColor(context, point.fillColor.CGColor);
        CGContextAddEllipseInRect(context, rect);
        CGContextDrawPath(context, kCGPathFillStroke);
    }
}

- (void)drawRect:(CGRect)rect
{
    CGRect drawInRect = CGRectInset(rect, 0.10 * rect.size.width, 15);
    drawInRect = CGRectOffset(drawInRect, 0.07 * rect.size.width, 0);

    CGContextRef context = UIGraphicsGetCurrentContext();

    self.graphWidth = CGRectGetWidth(drawInRect);
    self.graphHeight = CGRectGetHeight(drawInRect);

    //  width and height of the bounding box inside which the graph is drawn
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);

    [self drawAxes:context rect:drawInRect];
    [self drawLabels:context rect:drawInRect];
    [self drawPoints:context rect:drawInRect];
}

@end
