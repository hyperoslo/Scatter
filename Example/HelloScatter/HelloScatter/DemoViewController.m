#import "DemoViewController.h"

#import "HYPScatterPlot.h"

#import "UIColor+Hex.h"

@interface DemoViewController () <HYPScatterPlotDataSource>

@property (nonatomic, weak) IBOutlet UIView *uiView;
@property (nonatomic) HYPScatterPlot *scatterPlot;
@property (nonatomic) NSArray *scatterPoints;
@property (nonatomic) NSArray *scatterPointColors;
@property (nonatomic) CGFloat minimumXValue;
@property (nonatomic) CGFloat maximumXValue;
@property (nonatomic) CGFloat minimumYValue;
@property (nonatomic) CGFloat maximumYValue;

@end

@implementation DemoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.uiView addSubview:self.scatterPlot];

    UIColor *fillColor1 = [UIColor colorFromHex:@"CC2A41"];
    UIColor *fillColor2 = [UIColor colorFromHex:@"64908A"];
    UIColor *fillColor3 = [UIColor colorFromHex:@"E6AC27"];

    self.scatterPoints = @[ [NSValue valueWithCGPoint:CGPointMake(0, 20)],
                            [NSValue valueWithCGPoint:CGPointMake(100, 20)],
                            [NSValue valueWithCGPoint:CGPointMake(500, 50)],
                            [NSValue valueWithCGPoint:CGPointMake(200, 75)],
                            [NSValue valueWithCGPoint:CGPointMake(400, 0)],
                            [NSValue valueWithCGPoint:CGPointMake(300, -125)]
                            ];
    self.scatterPointColors = @[ fillColor1, fillColor2, fillColor3, fillColor2, fillColor3, fillColor2 ];
    self.minimumXValue = 0;
    self.maximumXValue = 500;
    self.minimumYValue = -125;
    self.maximumYValue = 75;
}


- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];

    _scatterPlot.frame = self.uiView.bounds;
    [_scatterPlot setNeedsDisplay];
}

- (HYPScatterPlot *)scatterPlot
{
    if (_scatterPlot) return _scatterPlot;

    _scatterPlot = [[HYPScatterPlot alloc] initWithFrame:self.view.bounds];
    _scatterPlot.dataSource = self;
    _scatterPlot.backgroundColor = [UIColor colorFromHex:@"351330"];
    _scatterPlot.yAxisEndGradient = [UIColor colorFromHex:@"351330"];
    _scatterPlot.upperThresholdYLineColor = [UIColor redColor];
    _scatterPlot.averageYLineColor = [UIColor whiteColor];
    _scatterPlot.lowerThresholdYLineColor = [UIColor greenColor];

    return _scatterPlot;
}

#pragma mark - HYPScatterPlotDatasource

- (CGFloat)minimumXValueInScatterPlotView:(HYPScatterPlot *)scatterPlotView
{
    return self.minimumXValue;
}

- (CGFloat)maximumXValueInScatterPlotView:(HYPScatterPlot *)scatterPlotView
{
    return self.maximumXValue;
}

- (CGFloat)minimumYValueInScatterPlotView:(HYPScatterPlot *)scatterPlotView
{
    return self.minimumYValue;
}

- (CGFloat)maximumYValueInScatterPlotView:(HYPScatterPlot *)scatterPlotView
{
    return self.maximumYValue;
}

- (NSAttributedString *)minimumXValueFormattedInScatterPlotView:(HYPScatterPlot *)scatterPlotView
{
    return [self attributedStringWithValue:self.minimumXValue color:[UIColor whiteColor]];
}

- (NSAttributedString *)maximumXValueFormattedInScatterPlotView:(HYPScatterPlot *)scatterPlotView
{
    return [self attributedStringWithValue:self.maximumXValue color:[UIColor whiteColor]];
}

- (NSAttributedString *)minimumYValueFormattedInScatterPlotView:(HYPScatterPlot *)scatterPlotView
{
    return [self attributedStringWithValue:self.minimumYValue color:self.scatterPlot.lowerThresholdYLineColor];
}

- (NSAttributedString *)maximumYValueFormattedInScatterPlotView:(HYPScatterPlot *)scatterPlotView
{
    return [self attributedStringWithValue:self.maximumYValue color:self.scatterPlot.upperThresholdYLineColor];
}

- (NSUInteger)numberOfPointsInScatterPlotView:(HYPScatterPlot *)scatterPlotView
{
    return self.scatterPoints.count;
}

- (CGPoint)pointAtIndex:(NSUInteger)index
{
    return [self.scatterPoints[index] CGPointValue];
}

- (CGFloat)averageYValueInScatterPlotView:(HYPScatterPlot *)scatterPlotView
{
    if (self.scatterPoints.count > 0) {
        CGFloat average = 0;
        for (NSValue *value in self.scatterPoints) {
            average += [value CGPointValue].y;
        }
        return average / self.scatterPoints.count;
    } else {
        return 0;
    }
}

- (CGFloat)upperThresholdYValueInScatterPlotView:(HYPScatterPlot *)scatterPlotView
{
    return 55.0f;
}

- (CGFloat)lowerThresholdYValueInScatterPlotView:(HYPScatterPlot *)scatterPlotView
{
    return -30.0f;
}

- (NSAttributedString *)averageYValueFormattedInScatterPlotView:(HYPScatterPlot *)scatterPlotView
{
    return [self attributedStringWithValue:[self averageYValueInScatterPlotView:self.scatterPlot] color:self.scatterPlot.averageYLineColor];
}

- (NSAttributedString *)upperThresholdYValueFormattedInScatterPlotView:(HYPScatterPlot *)scatterPlotView
{
    return [self attributedStringWithValue:[self upperThresholdYValueInScatterPlotView:self.scatterPlot] color:self.scatterPlot.upperThresholdYLineColor];
}

- (NSAttributedString *)lowerThresholdYValueFormattedInScatterPlotView:(HYPScatterPlot *)scatterPlotView
{
    return [self attributedStringWithValue:[self lowerThresholdYValueInScatterPlotView:self.scatterPlot] color:self.scatterPlot.lowerThresholdYLineColor];
}

- (UIColor *)fillColorOfPointAtIndex:(NSUInteger)index
{
    UIColor *color = self.scatterPlot.averageYLineColor;

    CGFloat value = [((NSValue *)self.scatterPoints[index]) CGPointValue].y;
    if (value < [self lowerThresholdYValueInScatterPlotView:self.scatterPlot]) {
        color = self.scatterPlot.lowerThresholdYLineColor;
    } else if (value > [self upperThresholdYValueInScatterPlotView:self.scatterPlot]) {
        color = self.scatterPlot.upperThresholdYLineColor;
    }
    
    return color;
}

#pragma mark - Other methods

- (NSAttributedString *)attributedStringWithValue:(CGFloat)value color:(UIColor *)color
{
    NSString *text = [NSString stringWithFormat:@"%f", value];
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:text attributes:
                                          @{NSFontAttributeName: [UIFont systemFontOfSize:9],
                                            NSForegroundColorAttributeName: color}];
    return attributedText;
}

@end
