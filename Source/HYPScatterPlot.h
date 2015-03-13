@import UIKit;

@protocol HYPScatterPlotDatasource;
@class HYPScatterPoint;
@class HYPScatterLabel;

@interface HYPScatterPlot : UIView

//optional properties
@property (nonatomic) UIColor *avgLineColor;
@property (nonatomic) UIColor *xAxisColor;
@property (nonatomic) UIColor *yAxisMidGradient;
@property (nonatomic) UIColor *yAxisEndGradient;

//required properties
@property (nonatomic, weak) id<HYPScatterPlotDatasource> delegate;

@end

@protocol HYPScatterPlotDatasource <NSObject>

@required

- (NSArray *)pointForScatterPlot:(HYPScatterPlot *)scatterPlot;
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
