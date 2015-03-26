@import UIKit;

@protocol HYPScatterPlotDataSource;

@class HYPScatterPoint;
@class HYPScatterLabel;

@interface HYPScatterPlot : UIView

@property (nonatomic, weak) id<HYPScatterPlotDataSource> dataSource;

//  optional properties
@property (nonatomic) UIColor *averageLineColor;
@property (nonatomic) UIColor *xAxisColor;
@property (nonatomic) UIColor *yAxisMidGradient;
@property (nonatomic) UIColor *yAxisEndGradient;
@property (nonatomic) UIColor *defaultPointFillColor;
@property (nonatomic) UIColor *selectedPointFillColor;
@property (nonatomic) UIColor *selectedPointStrokeColor;
@property (nonatomic) CGFloat axisLineWidth;
@property (nonatomic) CGFloat pointRadius;

@end

@protocol HYPScatterPlotDataSource <NSObject>

@required

- (CGFloat)minimumXValueInScatterPlotView:(HYPScatterPlot *)scatterPlotView;
- (CGFloat)maximumXValueInScatterPlotView:(HYPScatterPlot *)scatterPlotView;
- (CGFloat)minimumYValueInScatterPlotView:(HYPScatterPlot *)scatterPlotView;
- (CGFloat)maximumYValueInScatterPlotView:(HYPScatterPlot *)scatterPlotView;

- (NSAttributedString *)minimumXValueFormattedInScatterPlotView:(HYPScatterPlot *)scatterPlotView;
- (NSAttributedString *)maximumXValueFormattedInScatterPlotView:(HYPScatterPlot *)scatterPlotView;
- (NSAttributedString *)minimumYValueFormattedInScatterPlotView:(HYPScatterPlot *)scatterPlotView;
- (NSAttributedString *)maximumYValueFormattedInScatterPlotView:(HYPScatterPlot *)scatterPlotView;

- (NSUInteger)numberOfPointsInScatterPlotView:(HYPScatterPlot *)scatterPlotView;
- (CGPoint)pointAtIndex:(NSUInteger)index;

@optional

- (CGFloat)averageYValueInScatterPlotView:(HYPScatterPlot *)scatterPlotView;
- (NSAttributedString *)averageYValueFormattedInScatterPlotView:(HYPScatterPlot *)scatterPlotView;
- (UIColor *)fillColorOfPointAtIndex:(NSUInteger)index;

@end
