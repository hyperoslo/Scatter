@import UIKit;

@protocol HYPScatterPlotDataSource;

@class HYPScatterPoint;
@class HYPScatterLabel;

@interface HYPScatterPlot : UIView

@property (nonatomic) UIColor *avgLineColor;
@property (nonatomic) UIColor *xAxisColor;
@property (nonatomic) UIColor *yAxisMidGradient;
@property (nonatomic) UIColor *yAxisEndGradient;

@property (nonatomic, weak) id<HYPScatterPlotDataSource> dataSource;

@end

@protocol HYPScatterPlotDataSource <NSObject>

@required

- (NSArray *)scatterPointsForScatterPlot:(HYPScatterPlot *)scatterPlot;
- (HYPScatterPoint *)maximumXValue:(HYPScatterPlot *)scatterPlot;
- (HYPScatterPoint *)minimumXValue:(HYPScatterPlot *)scatterPlot;
- (HYPScatterPoint *)maximumYValue:(HYPScatterPlot *)scatterPlot;
- (HYPScatterPoint *)minimumYValue:(HYPScatterPlot *)scatterPlot;

@optional

- (CGFloat)avgYValue:(HYPScatterPlot*)scatterPlot;
- (HYPScatterLabel *)minimumYLabel:(HYPScatterPlot *)scatterPlot;
- (HYPScatterLabel *)maximumYLabel:(HYPScatterPlot *)scatterPlot;
- (HYPScatterLabel *)minimumXLabel:(HYPScatterPlot *)scatterPlot;
- (HYPScatterLabel *)maximumXLabel:(HYPScatterPlot *)scatterPlot;
- (HYPScatterLabel *)avgLabel:(HYPScatterPlot *)scatterPlot;

@end
