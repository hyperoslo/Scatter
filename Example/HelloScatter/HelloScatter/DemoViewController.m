#import "DemoViewController.h"
#import "HYPScatterPoint.h"
#import "HYPScatterLabel.h"

#import "UIColor+Hex.h"

@interface DemoViewController ()

@property (nonatomic, weak) IBOutlet UIView *uiView;
@property (nonatomic) HYPScatterPlot *scatterPlot;
@property (nonatomic) NSArray *scatterPoints;

@end

@implementation DemoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.uiView addSubview:self.scatterPlot];

    UIColor *fillColor1 = [UIColor redColor];
    UIColor *fillColor2 = [UIColor yellowColor];
    UIColor *fillColor3 = [UIColor lightGrayColor];

    UIColor *strokeColor1 = [UIColor whiteColor];
    UIColor *strokeColor2 = [UIColor yellowColor];
    UIColor *strokeColor3 = [UIColor whiteColor];

    self.scatterPoints = [NSArray arrayWithObjects:
                          [[HYPScatterPoint alloc] initWithValues:fillColor1 strokeColor:strokeColor1 x:0.0f y:0.0f],
                          [[HYPScatterPoint alloc] initWithValues:fillColor2 strokeColor:strokeColor2 x:100.0f y:20.0f],
                          [[HYPScatterPoint alloc] initWithValues:fillColor3 strokeColor:strokeColor3 x:500.0f y:50.0f],
                          [[HYPScatterPoint alloc] initWithValues:fillColor3 strokeColor:strokeColor3 x:200.0f y:75.0f],
                          [[HYPScatterPoint alloc] initWithValues:fillColor3 strokeColor:strokeColor3 x:400.0f y:0.0f],
                          [[HYPScatterPoint alloc] initWithValues:fillColor3 strokeColor:strokeColor3 x:300.0f y:-125.0f],
                          nil];
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
    _scatterPlot.delegate = self;

    return _scatterPlot;
}

#pragma mark HYPScatterPlotDatasource

- (NSArray *)pointForScatterPlot:(HYPScatterPlot *)scatterPlot
{
    return self.scatterPoints;
}

- (HYPScatterPoint *)maximumXValue:(HYPScatterPlot *)scatterPlot
{
    __block HYPScatterPoint* maximumX = self.scatterPoints[0];

    [self.scatterPoints enumerateObjectsUsingBlock:^(HYPScatterPoint *obj, NSUInteger idx, BOOL *stop) {
        if (obj.x > maximumX.x) maximumX = obj;
    }];

    return maximumX;
}

- (HYPScatterPoint *)minimumXValue:(HYPScatterPlot *)scatterPlot
{
    __block HYPScatterPoint* minimumX = self.scatterPoints[0];
    [self.scatterPoints enumerateObjectsUsingBlock:^(HYPScatterPoint *obj, NSUInteger idx, BOOL *stop) {
        if (obj.x < minimumX.x) minimumX = obj;
    }];

    return minimumX;
}

- (HYPScatterPoint *)maximumYValue:(HYPScatterPlot *)scatterPlot
{
    __block HYPScatterPoint* maximumY = self.scatterPoints[0];

    [self.scatterPoints enumerateObjectsUsingBlock:^(HYPScatterPoint *obj, NSUInteger idx, BOOL *stop) {
        if (obj.y > maximumY.y) maximumY = obj;
    }];

    return maximumY;
}

- (HYPScatterPoint *)minimumYValue:(HYPScatterPlot *)scatterPlot
{
    __block HYPScatterPoint* minimumY = self.scatterPoints[0];
    [self.scatterPoints enumerateObjectsUsingBlock:^(HYPScatterPoint *obj, NSUInteger idx, BOOL *stop) {
        if (obj.y < minimumY.y) minimumY = obj;
    }];

    return minimumY;
}

- (CGFloat)avgYValue:(HYPScatterPlot *)scatterPlot
{
    __block CGFloat sum = 0.0;
    __block CGFloat count = 0;
    [self.scatterPoints enumerateObjectsUsingBlock:^(HYPScatterPoint *obj, NSUInteger idx, BOOL *stop) {
        sum += obj.y;
        ++count;
    }];

    if (count == 0) return 0;

    return sum/count;
}

- (HYPScatterLabel *)minimumYLabel:(HYPScatterPlot *)scatterPlot
{
    return [[HYPScatterLabel alloc] initWithText:@"- 5,4%" textColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:22] autosize:YES];
}

- (HYPScatterLabel *)maximumYLabel:(HYPScatterPlot *)scatterPlot
{
    return [[HYPScatterLabel alloc] initWithText:@"+ 7,2%" textColor:[UIColor redColor] font:[UIFont systemFontOfSize:22] autosize:YES];
}

- (HYPScatterLabel *)minimumXLabel:(HYPScatterPlot *)scatterPlot
{
    return [[HYPScatterLabel alloc] initWithText:@"19,0" textColor:[UIColor redColor] font:[UIFont systemFontOfSize:22] autosize:YES];
}

- (HYPScatterLabel *)maximumXLabel:(HYPScatterPlot *)scatterPlot
{
    return [[HYPScatterLabel alloc] initWithText:@"35,5 mill" textColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:22] autosize:YES];
}

- (HYPScatterLabel *)avgLabel:(HYPScatterPlot *)scatterPlot
{
    return [[HYPScatterLabel alloc] initWithText:@"+1,3%" textColor:[UIColor whiteColor] font:[UIFont systemFontOfSize:22] autosize:YES];
}

@end
