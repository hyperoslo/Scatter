#import "HYPScatterPlot.h"

#define NUM_ELEMS(x)  (sizeof(x) / sizeof(x[0]))

static const CGFloat HYPScatterPlotCircleRadius = 7.0f;
static const CGFloat HYPScatterPlotLabelPadding = 5.0f;
static const CGFloat HYPScatterPlotAxisLineWidth = 0.5f;

static const CGFloat HYPScatterPlotLeftYAxisMarginLeft = 55.0f;
static const CGFloat HYPScatterPlotRightYAxisMarginRight = 10.0f;
static const CGFloat HYPScatterPlotYAxisWidth = 0.5f;

static const CGFloat HYPAverageYLineDashLength[] = { 6.0f };

@interface HYPScatterPlot()

@property (nonatomic) UILabel *minimumXLabel;
@property (nonatomic) UILabel *maximumXLabel;
@property (nonatomic) UILabel *minimumYLabel;
@property (nonatomic) UILabel *maximumYLabel;

@property (nonatomic) UILabel *averageYLabel;
@property (nonatomic) UILabel *upperThresholdYLabel;
@property (nonatomic) UILabel *lowerThresholdYLabel;

@property (nonatomic) NSLayoutConstraint *averageYLabelBottomMarginConstraint;
@property (nonatomic) NSLayoutConstraint *upperThresholdYLabelBottomMarginConstraint;
@property (nonatomic) NSLayoutConstraint *lowerThresholdYLabelBottomMarginConstraint;

@property (nonatomic) UIView *leftYAxis;
@property (nonatomic) UIView *rightYAxis;
@property (nonatomic) CAGradientLayer *leftYAxisGradient;
@property (nonatomic) CAGradientLayer *rightYAxisGradient;

@property (nonatomic) UIView *plotView;

@end

@implementation HYPScatterPlot

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) return nil;

    self.backgroundColor = [UIColor blackColor];

    self.axisLineWidth = HYPScatterPlotAxisLineWidth;
    self.pointRadius = HYPScatterPlotCircleRadius;

    [self addSubview:self.leftYAxis];
    [self addSubview:self.rightYAxis];
    [self addSubview:self.minimumXLabel];
    [self addSubview:self.maximumXLabel];
    [self addSubview:self.minimumYLabel];
    [self addSubview:self.maximumYLabel];
    [self addSubview:self.averageYLabel];
    [self addSubview:self.upperThresholdYLabel];
    [self addSubview:self.lowerThresholdYLabel];
    [self addSubview:self.plotView];

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
                              @"averageYLabel": self.averageYLabel,
                              @"upperThresholdYLabel": self.upperThresholdYLabel,
                              @"lowerThresholdYLabel": self.lowerThresholdYLabel,
                              @"plotView": self.plotView};

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
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-padding-[maximumYLabel]-(padding)-[leftYAxis(yAxisWidth)]"
                                             options:0
                                             metrics:metrics
                                               views:views]];

    [self addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-padding-[maximumYLabel]"
                                             options:0
                                             metrics:metrics
                                               views:views]];

    [self addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-padding-[minimumYLabel]-(padding)-[leftYAxis(yAxisWidth)]"
                                             options:0
                                             metrics:metrics
                                               views:views]];

    [self addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:[minimumYLabel]-padding-[minimumXLabel]"
                                             options:0
                                             metrics:metrics
                                               views:views]];

    [self addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-padding-[averageYLabel]-(padding)-[leftYAxis(yAxisWidth)]"
                                             options:0
                                             metrics:metrics
                                               views:views]];

    [self addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:[rightYAxis(yAxisWidth)]-(padding)-[upperThresholdYLabel]-padding-|"
                                             options:0
                                             metrics:metrics
                                               views:views]];

    [self addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:[rightYAxis(yAxisWidth)]-(padding)-[lowerThresholdYLabel]-padding-|"
                                             options:0
                                             metrics:metrics
                                               views:views]];

    [self addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-padding-[leftYAxis]-padding-|"
                                             options:0
                                             metrics:metrics
                                               views:views]];

    [self addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-padding-[rightYAxis]-padding-|"
                                             options:0
                                             metrics:metrics
                                               views:views]];

    [self addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"H:[leftYAxis][plotView][rightYAxis]"
                                             options:0
                                             metrics:nil
                                               views:views]];

    [self addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[plotView][minimumXLabel]"
                                             options:0
                                             metrics:nil
                                               views:views]];

    [self addConstraints:
     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[plotView][maximumXLabel]"
                                             options:0
                                             metrics:nil
                                               views:views]];

    [self addConstraint:self.averageYLabelBottomMarginConstraint];
    [self addConstraint:self.upperThresholdYLabelBottomMarginConstraint];
    [self addConstraint:self.lowerThresholdYLabelBottomMarginConstraint];

    return self;
}

#pragma mark - Getters

- (UIColor *)averageYLineColor
{
    if (_averageYLineColor) return _averageYLineColor;

    _averageYLineColor = [UIColor whiteColor];

    return _averageYLineColor;
}

- (UIColor *)upperThresholdYLineColor
{
    if (_upperThresholdYLineColor) return _upperThresholdYLineColor;

    _upperThresholdYLineColor = [UIColor greenColor];

    return _upperThresholdYLineColor;
}

- (UIColor *)lowerThresholdYLineColor
{
    if (_lowerThresholdYLineColor) return _lowerThresholdYLineColor;

    _lowerThresholdYLineColor = [UIColor redColor];

    return _lowerThresholdYLineColor;
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

- (UILabel *)upperThresholdYLabel
{
    if (_upperThresholdYLabel) return _upperThresholdYLabel;

    _upperThresholdYLabel = [UILabel new];
    _upperThresholdYLabel.translatesAutoresizingMaskIntoConstraints = NO;

    return _upperThresholdYLabel;
}

- (UILabel *)lowerThresholdYLabel
{
    if (_lowerThresholdYLabel) return _lowerThresholdYLabel;

    _lowerThresholdYLabel = [UILabel new];
    _lowerThresholdYLabel.translatesAutoresizingMaskIntoConstraints = NO;

    return _lowerThresholdYLabel;
}

- (NSLayoutConstraint *)averageYLabelBottomMarginConstraint
{
    if (_averageYLabelBottomMarginConstraint) return _averageYLabelBottomMarginConstraint;

    _averageYLabelBottomMarginConstraint =
    [NSLayoutConstraint constraintWithItem:self
                                 attribute:NSLayoutAttributeBottom
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.averageYLabel
                                 attribute:NSLayoutAttributeBottom
                                multiplier:1.0f
                                  constant:0.0f];

    return _averageYLabelBottomMarginConstraint;
}

- (NSLayoutConstraint *)upperThresholdYLabelBottomMarginConstraint
{
    if (_upperThresholdYLabelBottomMarginConstraint) return _upperThresholdYLabelBottomMarginConstraint;

    _upperThresholdYLabelBottomMarginConstraint =
    [NSLayoutConstraint constraintWithItem:self
                                 attribute:NSLayoutAttributeBottom
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.upperThresholdYLabel
                                 attribute:NSLayoutAttributeBottom
                                multiplier:1.0f
                                  constant:0.0f];

    return _upperThresholdYLabelBottomMarginConstraint;
}

- (NSLayoutConstraint *)lowerThresholdYLabelBottomMarginConstraint
{
    if (_lowerThresholdYLabelBottomMarginConstraint) return _lowerThresholdYLabelBottomMarginConstraint;

    _lowerThresholdYLabelBottomMarginConstraint =
    [NSLayoutConstraint constraintWithItem:self
                                 attribute:NSLayoutAttributeBottom
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.lowerThresholdYLabel
                                 attribute:NSLayoutAttributeBottom
                                multiplier:1.0f
                                  constant:0.0f];

    return _lowerThresholdYLabelBottomMarginConstraint;
}

- (UIView *)plotView
{
    if (_plotView) return _plotView;

    _plotView = [UIView new];
    _plotView.translatesAutoresizingMaskIntoConstraints = NO;

    return _plotView;
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
    CGRect plotRect = CGRectInset(self.plotView.frame, self.pointRadius, self.pointRadius);

    [self updateYAxes];
    [self updateLabels];
    [self drawPointsAndYThresholdsInRect:plotRect];
}

- (void)updateYAxes
{
    self.leftYAxisGradient.frame = CGRectMake(0.0f, 0.0f, HYPScatterPlotYAxisWidth, CGRectGetHeight(self.leftYAxis.frame));
    self.leftYAxisGradient.colors = self.gradientColors;

    self.rightYAxisGradient.frame = CGRectMake(0.0f, 0.0f, HYPScatterPlotYAxisWidth, CGRectGetHeight(self.rightYAxis.frame));
    self.rightYAxisGradient.colors = self.gradientColors;
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

    if ([self.dataSource respondsToSelector:@selector(upperThresholdYValueFormattedInScatterPlotView:)]) {
        self.upperThresholdYLabel.attributedText = [self.dataSource upperThresholdYValueFormattedInScatterPlotView:self];
    }

    if ([self.dataSource respondsToSelector:@selector(lowerThresholdYValueFormattedInScatterPlotView:)]) {
        self.lowerThresholdYLabel.attributedText = [self.dataSource lowerThresholdYValueFormattedInScatterPlotView:self];
    }
}

- (void)drawPointsAndYThresholdsInRect:(CGRect)rect
{
    NSUInteger numberOfPoints = [self.dataSource numberOfPointsInScatterPlotView:self];

    CGFloat srcMinX = [self.dataSource minimumXValueInScatterPlotView:self];
    CGFloat srcMaxX = [self.dataSource maximumXValueInScatterPlotView:self];
    CGFloat srcMinY = [self.dataSource minimumYValueInScatterPlotView:self];
    CGFloat srcMaxY = [self.dataSource maximumYValueInScatterPlotView:self];

    CGFloat destMinX = CGRectGetMinX(rect);
    CGFloat destMaxX = CGRectGetWidth(rect);
    CGFloat destMinY = CGRectGetMinY(rect);
    CGFloat destMaxY = CGRectGetHeight(rect);

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0.0f, CGRectGetHeight(self.plotView.frame));
    CGContextScaleCTM(context, 1.0f, -1.0f);

    if ([self.dataSource respondsToSelector:@selector(upperThresholdYValueInScatterPlotView:)]) {
        CGFloat y = [self.dataSource upperThresholdYValueInScatterPlotView:self];
        CGFloat translatedY = [self translateValue:y srcMin:srcMinY srcMax:srcMaxY destMin:destMinY destMax:destMaxY];
        self.upperThresholdYLabelBottomMarginConstraint.constant = translatedY + CGRectGetHeight(self.upperThresholdYLabel.frame) + HYPScatterPlotLabelPadding;
        [self drawLineWithYValue:translatedY usingColor:self.upperThresholdYLineColor dashedStyle:NO];
    }

    if ([self.dataSource respondsToSelector:@selector(lowerThresholdYValueInScatterPlotView:)]) {
        CGFloat y = [self.dataSource lowerThresholdYValueInScatterPlotView:self];
        CGFloat translatedY = [self translateValue:y srcMin:srcMinY srcMax:srcMaxY destMin:destMinY destMax:destMaxY];
        self.lowerThresholdYLabelBottomMarginConstraint.constant = translatedY + CGRectGetHeight(self.lowerThresholdYLabel.frame) + HYPScatterPlotLabelPadding;
        [self drawLineWithYValue:translatedY usingColor:self.lowerThresholdYLineColor dashedStyle:NO];
    }

    if ([self.dataSource respondsToSelector:@selector(averageYValueInScatterPlotView:)]) {
        CGFloat y = [self.dataSource averageYValueInScatterPlotView:self];
        CGFloat translatedY = [self translateValue:y srcMin:srcMinY srcMax:srcMaxY destMin:destMinY destMax:destMaxY];
        self.averageYLabelBottomMarginConstraint.constant = translatedY + CGRectGetHeight(self.averageYLabel.frame) + HYPScatterPlotLabelPadding;
        [self drawLineWithYValue:translatedY usingColor:self.averageYLineColor dashedStyle:YES];
    }

    for (NSInteger index = 0; index < numberOfPoints; index++) {
        CGPoint point = [self.dataSource pointAtIndex:index];
        CGPoint translatedPoint = CGPointMake(
            [self translateValue:point.x srcMin:srcMinX srcMax:srcMaxX destMin:destMinX destMax:destMaxX],
            [self translateValue:point.y srcMin:srcMinY srcMax:srcMaxY destMin:destMinY destMax:destMaxY]
        );

        UIColor *fillColor = self.defaultPointFillColor;

        if ([self.dataSource respondsToSelector:@selector(fillColorOfPointAtIndex:)]) {
            fillColor = [self.dataSource fillColorOfPointAtIndex:index];
        }

        CGRect pointRect = CGRectMake(translatedPoint.x - self.pointRadius,
                                      translatedPoint.y - self.pointRadius,
                                      2 * self.pointRadius,
                                      2 * self.pointRadius);

        CGContextSetStrokeColorWithColor(context, fillColor.CGColor);
        CGContextSetFillColorWithColor(context, fillColor.CGColor);
        CGContextAddEllipseInRect(context, pointRect);
        CGContextDrawPath(context, kCGPathFillStroke);
    }
}

- (void)drawLineWithYValue:(CGFloat)yValue usingColor:(UIColor *)color dashedStyle:(BOOL)dashed
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, self.axisLineWidth);
    CGContextSetStrokeColorWithColor(context, color.CGColor);

    if (dashed) {
        CGContextSetLineDash(context, 0.0f, HYPAverageYLineDashLength, NUM_ELEMS(HYPAverageYLineDashLength));
    }

    CGContextMoveToPoint(context, 0.0f, yValue);
    CGContextAddLineToPoint(context, CGRectGetWidth(self.bounds), yValue);
    CGContextStrokePath(context);

    if (dashed) {
        CGContextSetLineDash(context, 0, NULL, 0);
    }
}

- (CGFloat)translateValue:(CGFloat)value srcMin:(CGFloat)srcMin srcMax:(CGFloat)srcMax destMin:(CGFloat)destMin destMax:(CGFloat)destMax;
{
    if (srcMax - srcMin == 0) return 0.0f;

    return (value - srcMin) / (srcMax - srcMin) * destMax + destMin;
}


@end
