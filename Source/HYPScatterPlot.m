#import "HYPScatterPlot.h"
#import "UIColor+Hex.h"

static const CGFloat HYPScatterPlotCircleRadius = 7.0f;
static const CGFloat HYPScatterPlotLabelPadding = 5.0f;
static const CGFloat HYPScatterPlotAxisLineWidth = 1.0f;

static const CGFloat HYPScatterPlotLeftYAxisMarginLeft = 55.0f;
static const CGFloat HYPScatterPlotRightYAxisMarginRight = 10.0f;
static const CGFloat HYPScatterPlotYAxisWidth = 1.0f;

static NSString * const HYPScatterPlotBackgroundColor = @"0E223D";
static NSString * const HYPScatterPlotXLineColor = @"EC3031";

@interface HYPScatterPlot()

@property (nonatomic) CGFloat graphWidth;
@property (nonatomic) CGFloat graphHeight;

@property (nonatomic) UILabel *minimumXLabel;
@property (nonatomic) UILabel *maximumXLabel;
@property (nonatomic) UILabel *minimumYLabel;
@property (nonatomic) UILabel *maximumYLabel;
@property (nonatomic) UILabel *averageYLabel;

@property (nonatomic) UIView *leftYAxis;
@property (nonatomic) UIView *rightYAxis;
@property (nonatomic) CAGradientLayer *leftYAxisGradient;
@property (nonatomic) CAGradientLayer *rightYAxisGradient;

@end

@implementation HYPScatterPlot

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;

    self.backgroundColor = [UIColor colorFromHex:HYPScatterPlotBackgroundColor];

    self.axisLineWidth = HYPScatterPlotAxisLineWidth;
    self.pointRadius = HYPScatterPlotCircleRadius;

    [self addSubview:self.leftYAxis];
    [self addSubview:self.rightYAxis];
    [self addSubview:self.minimumXLabel];
    [self addSubview:self.maximumXLabel];
    [self addSubview:self.minimumYLabel];
    [self addSubview:self.maximumYLabel];
    [self addSubview:self.averageYLabel];

    NSDictionary *metrics = @{@"yAxisWidth": @(HYPScatterPlotYAxisWidth),
                              @"leftYAxisMarginLeft": @(HYPScatterPlotLeftYAxisMarginLeft),
                              @"rightYAxisMarginRight" : @(HYPScatterPlotRightYAxisMarginRight),
                              @"padding": @(HYPScatterPlotLabelPadding)};

    NSDictionary *views   = @{@"leftYAxis": self.leftYAxis,
                              @"rightYAxis": self.rightYAxis,
                              @"minimumXLabel": self.minimumXLabel,
                              @"maximumXLabel": self.maximumXLabel,
                              @"minimumYLabel": self.minimumYLabel,
                              @"maximumYLabel": self.maximumYLabel,
                              @"averageYLabel": self.averageYLabel};

    [self addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-leftYAxisMarginLeft-[leftYAxis(yAxisWidth)]"
                                             options:0
                                             metrics:metrics
                                               views:views]];

    [self addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-padding-[leftYAxis]-padding-|"
                                             options:0
                                             metrics:metrics
                                               views:views]];

    [self addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:[rightYAxis(yAxisWidth)]-rightYAxisMarginRight-|"
                                             options:0
                                             metrics:metrics
                                               views:views]];

    [self addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-padding-[rightYAxis]-padding-|"
                                             options:0
                                             metrics:metrics
                                               views:views]];

    [self addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-padding-[minimumXLabel]"
                                             options:0
                                             metrics:metrics
                                               views:views]];

    [self addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:[minimumXLabel]-padding-|"
                                             options:0
                                             metrics:metrics
                                               views:views]];

    [self addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:[maximumXLabel]-padding-|"
                                             options:0
                                             metrics:metrics
                                               views:views]];

    [self addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:[maximumXLabel]-padding-|"
                                             options:0
                                             metrics:metrics
                                               views:views]];

    [self addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-padding-[maximumYLabel]"
                                             options:0
                                             metrics:metrics
                                               views:views]];

    [self addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-padding-[maximumYLabel]"
                                             options:0
                                             metrics:metrics
                                               views:views]];

    [self addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-padding-[minimumYLabel]"
                                             options:0
                                             metrics:metrics
                                               views:views]];

    [self addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:[minimumYLabel]-padding-[minimumXLabel]"
                                             options:0
                                             metrics:metrics
                                               views:views]];

    [self addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:[minimumYLabel]-padding-[minimumXLabel]"
                                             options:0
                                             metrics:metrics
                                               views:views]];

    [self addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-padding-[averageYLabel]"
                                             options:0
                                             metrics:metrics
                                               views:views]];

    [self addConstraint:
     [NSLayoutConstraint constraintWithItem:self.averageYLabel
                                  attribute:NSLayoutAttributeCenterY
                                  relatedBy:NSLayoutRelationEqual
                                     toItem:self
                                  attribute:NSLayoutAttributeCenterY
                                 multiplier:1.0f
                                   constant:-10.0f]];

    return self;
}

#pragma mark - Getters

- (UIColor *)averageLineColor
{
    if (_averageLineColor) return _averageLineColor;

    _averageLineColor = [UIColor whiteColor];

    return _averageLineColor;
}

- (UIColor *)xAxisColor
{
    if (_xAxisColor) return _xAxisColor;

    _xAxisColor = [UIColor colorFromHex:HYPScatterPlotXLineColor];

    return _xAxisColor;
}

- (UIColor *)yAxisMidGradient
{
    if (_yAxisMidGradient) return _yAxisMidGradient;

    _yAxisMidGradient = [UIColor whiteColor];

    return _yAxisMidGradient;
}

- (UIColor *)yAxisEndGradient
{
    if (_yAxisEndGradient) return _yAxisEndGradient;

    _yAxisEndGradient = [UIColor clearColor];

    return _yAxisEndGradient;
}

- (UIColor *)defaultPointFillColor
{
    if (_defaultPointFillColor) return _defaultPointFillColor;

    _defaultPointFillColor = [UIColor whiteColor];

    return _defaultPointFillColor;
}

- (UIColor *)selectedPointFillColor
{
    if (_selectedPointFillColor) return _selectedPointFillColor;

    _selectedPointFillColor = [UIColor whiteColor];

    return _selectedPointFillColor;
}

- (UIColor *)selectedPointStrokeColor
{
    if (_selectedPointStrokeColor) return _selectedPointStrokeColor;

    _selectedPointStrokeColor = [UIColor whiteColor];

    return _selectedPointStrokeColor;
}

- (UIView *)leftYAxis
{
    if (_leftYAxis) return _leftYAxis;

    _leftYAxis = [UIView new];
    _leftYAxis.translatesAutoresizingMaskIntoConstraints = NO;
    [_leftYAxis.layer addSublayer:self.leftYAxisGradient];

    return _leftYAxis;
}

- (UIView *)rightYAxis
{
    if (_rightYAxis) return _rightYAxis;

    _rightYAxis = [UIView new];
    _rightYAxis.translatesAutoresizingMaskIntoConstraints = NO;
    [_rightYAxis.layer addSublayer:self.rightYAxisGradient];

    return _rightYAxis;
}

- (CAGradientLayer *)leftYAxisGradient
{
    if (_leftYAxisGradient) return _leftYAxisGradient;

    _leftYAxisGradient = [CAGradientLayer layer];

    return _leftYAxisGradient;
}

- (CAGradientLayer *)rightYAxisGradient
{
    if (_rightYAxisGradient) return _rightYAxisGradient;

    _rightYAxisGradient = [CAGradientLayer layer];

    return _rightYAxisGradient;
}

- (UILabel *)minimumXLabel
{
    if (_minimumXLabel) return _minimumXLabel;

    _minimumXLabel = [UILabel new];
    _minimumXLabel.translatesAutoresizingMaskIntoConstraints = NO;

    return _minimumXLabel;
}

- (UILabel *)maximumXLabel
{
    if (_maximumXLabel) return _maximumXLabel;

    _maximumXLabel = [UILabel new];
    _maximumXLabel.translatesAutoresizingMaskIntoConstraints = NO;

    return _maximumXLabel;
}

- (UILabel *)minimumYLabel
{
    if (_minimumYLabel) return _minimumYLabel;

    _minimumYLabel = [UILabel new];
    _minimumYLabel.translatesAutoresizingMaskIntoConstraints = NO;

    return _minimumYLabel;
}

- (UILabel *)maximumYLabel
{
    if (_maximumYLabel) return _maximumYLabel;

    _maximumYLabel = [UILabel new];
    _maximumYLabel.translatesAutoresizingMaskIntoConstraints = NO;

    return _maximumYLabel;
}

- (UILabel *)averageYLabel
{
    if (_averageYLabel) return _averageYLabel;

    _averageYLabel = [UILabel new];
    _averageYLabel.translatesAutoresizingMaskIntoConstraints = NO;

    return _averageYLabel;
}

- (NSArray *)gradientColors
{
    return [NSArray arrayWithObjects:
            (id)self.yAxisEndGradient.CGColor,
            (id)self.yAxisMidGradient.CGColor,
            (id)self.yAxisEndGradient.CGColor, nil];
}

- (void)drawRect:(CGRect)rect
{
    CGFloat marginY = HYPScatterPlotCircleRadius + 1.0f;
    CGFloat marginX = HYPScatterPlotLeftYAxisMarginLeft + 0.5f;

    CGRect drawInRect = CGRectMake(marginX, marginY, CGRectGetWidth(rect) - (2 * marginX), CGRectGetHeight(rect) - (2 * marginY));

    self.graphWidth = CGRectGetWidth(drawInRect);
    self.graphHeight = CGRectGetHeight(drawInRect);

    [self updateYAxes];
    [self updateLabels];
    [self drawPointsInRect:drawInRect];
}

- (void)updateLabels
{
    self.minimumXLabel.attributedText = [self.dataSource minimumXValueFormattedInScatterPlotView:self];
    self.maximumXLabel.attributedText = [self.dataSource maximumXValueFormattedInScatterPlotView:self];
    self.minimumYLabel.attributedText = [self.dataSource minimumYValueFormattedInScatterPlotView:self];
    self.maximumYLabel.attributedText = [self.dataSource maximumYValueFormattedInScatterPlotView:self];

    if ([self.dataSource respondsToSelector:@selector(averageYValueFormattedInScatterPlotView:)]) {
        self.averageYLabel.attributedText = [self.dataSource averageYValueFormattedInScatterPlotView:self];
    }
}

- (void)updateYAxes
{
    self.leftYAxisGradient.frame = CGRectMake(0, HYPScatterPlotLabelPadding, HYPScatterPlotYAxisWidth, CGRectGetHeight(self.bounds)-HYPScatterPlotLabelPadding);
    self.leftYAxisGradient.colors = self.gradientColors;

    self.rightYAxisGradient.frame = CGRectMake(0, HYPScatterPlotLabelPadding, HYPScatterPlotYAxisWidth, CGRectGetHeight(self.bounds)-HYPScatterPlotLabelPadding);
    self.rightYAxisGradient.colors = self.gradientColors;
}

- (void)drawPointsInRect:(CGRect)rect
{
    NSUInteger numberOfPoints = [self.dataSource numberOfPointsInScatterPlotView:self];

    CGFloat maximumXValue = [self.dataSource maximumXValueInScatterPlotView:self];
    CGFloat minimumXValue = [self.dataSource minimumXValueInScatterPlotView:self];
    CGFloat maximumYValue = [self.dataSource maximumYValueInScatterPlotView:self];
    CGFloat minimumYValue = [self.dataSource minimumYValueInScatterPlotView:self];

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

    CGContextRef context = UIGraphicsGetCurrentContext();

    // draw a horizontal line where y = 0
    CGContextSetLineWidth(context, self.axisLineWidth);
    CGContextSetStrokeColorWithColor(context, self.xAxisColor.CGColor);

    // through out the following code CGRectGetMinY and CGRectGetMinX help us get the margins for the drawing
    // normalized co-ordinate of the horizontal line indicating where is y = 0
    CGFloat zeroLine = self.graphHeight - ((minimumYValue + minimumYValue) / (maximumYValue + minimumYValue)) * self.graphHeight + CGRectGetMinY(rect);

    CGContextMoveToPoint(context, 0, zeroLine);
    CGContextAddLineToPoint(context, self.bounds.size.width, zeroLine);

    CGContextStrokePath(context);

    // draw a horizontal line on average value of y
    if ([self.dataSource respondsToSelector:@selector(averageYValueInScatterPlotView:)]) {
        CGFloat averageVertical = [self.dataSource averageYValueInScatterPlotView:self];

        CGContextSetLineWidth(context, self.axisLineWidth);
        CGContextSetStrokeColorWithColor(context, self.averageLineColor.CGColor);
        CGFloat dash[] = {6.0, 6.0};
        CGContextSetLineDash(context, 0.0, dash, 2);

        // normalization is done by dividing a value by maximum value in the list, see below inside for loop
        CGFloat averageLine = (averageVertical + minimumYValue) / (maximumYValue + minimumYValue) * self.graphHeight + CGRectGetMinY(rect);

        CGContextMoveToPoint(context, 0, averageLine);
        CGContextAddLineToPoint(context, self.bounds.size.width, averageLine);
        CGContextStrokePath(context);
        CGContextSetLineDash(context, 0, NULL, 0);  //remove the dash
    }

    for (NSInteger index = 0; index < numberOfPoints; index++) {
        // normalization is done by dividing a value by maximum value in the list
        // for each point get their normalized co-ordinates with respect to the height and width of the drawing space
        CGPoint point = [self.dataSource pointAtIndex:index];

        UIColor *fillColor = self.defaultPointFillColor;
        if ([self.dataSource respondsToSelector:@selector(fillColorOfPointAtIndex:)]) {
            fillColor = [self.dataSource fillColorOfPointAtIndex:index];
        }

        CGFloat x = (point.x + minimumXValue) / (maximumXValue + minimumXValue) * self.graphWidth + CGRectGetMinX(rect);

        CGFloat y = self.graphHeight - (point.y + minimumYValue) / (maximumYValue + minimumYValue) * self.graphHeight + CGRectGetMinY(rect);

        // draw the point as circle
        CGRect rect = CGRectMake(x - HYPScatterPlotCircleRadius, y - HYPScatterPlotCircleRadius, 2 * HYPScatterPlotCircleRadius, 2 * HYPScatterPlotCircleRadius);

        CGContextSetStrokeColorWithColor(context, fillColor.CGColor);
        CGContextSetFillColorWithColor(context, fillColor.CGColor);
        CGContextAddEllipseInRect(context, rect);
        CGContextDrawPath(context, kCGPathFillStroke);
    }
}

@end
