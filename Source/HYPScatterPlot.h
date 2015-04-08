@import UIKit;

@protocol HYPScatterPlotDelegate;
@protocol HYPScatterPlotDataSource;

@interface HYPScatterPlot : UIView

@property (nonatomic, weak) id<HYPScatterPlotDelegate> delegate;
@property (nonatomic, weak) id<HYPScatterPlotDataSource> dataSource;

@property (nonatomic) UIColor *averageYLineColor;
@property (nonatomic) UIColor *upperThresholdYLineColor;
@property (nonatomic) UIColor *lowerThresholdYLineColor;

@property (nonatomic) UIColor *yAxisMidGradient;
@property (nonatomic) UIColor *yAxisEndGradient;

@property (nonatomic) UIColor *defaultPointFillColor;
@property (nonatomic) UIColor *selectedPointFillColor;
@property (nonatomic) UIColor *selectedPointStrokeColor;
@property (nonatomic) UIColor *selectedPointVerticalLineColor;

@property (nonatomic) BOOL enableSelection;

@property (nonatomic) CGFloat axisLineWidth;
@property (nonatomic) CGFloat pointRadius;

@end

@protocol HYPScatterPlotDelegate <NSObject>

- (void)scatterPlotView:(HYPScatterPlot *)scatterPlotView didSelectPointAtIndex:(NSUInteger)index withScatterPlotCoordinates:(CGPoint)coordinates;

- (void)scatterPlotViewDidEndSelection:(HYPScatterPlot *)scatterPlotView;

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
- (CGFloat)upperThresholdYValueInScatterPlotView:(HYPScatterPlot *)scatterPlotView;
- (CGFloat)lowerThresholdYValueInScatterPlotView:(HYPScatterPlot *)scatterPlotView;

- (NSAttributedString *)averageYValueFormattedInScatterPlotView:(HYPScatterPlot *)scatterPlotView;
- (NSAttributedString *)upperThresholdYValueFormattedInScatterPlotView:(HYPScatterPlot *)scatterPlotView;
- (NSAttributedString *)lowerThresholdYValueFormattedInScatterPlotView:(HYPScatterPlot *)scatterPlotView;

- (UIColor *)fillColorOfPointAtIndex:(NSUInteger)index;

@end
