#import "TwoLinearInterpView.h"


@implementation UITouch (TouchSorting)

- (NSComparisonResult)compareAddress:(id)obj {
    if ((__bridge void *)self < (__bridge void *)obj) return NSOrderedAscending;
    else if ((__bridge void *)self == (__bridge void *)obj) return NSOrderedSame;
	else return NSOrderedDescending;
}
@end

@implementation TwoLinearInterpView
{
    
    NSMutableArray *aTouches;
    NSMutableArray *paths;
    
}

- (id)initWithCoder:(NSCoder *)aDecoder // (1)
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self setMultipleTouchEnabled:YES]; // (2)
        [self setBackgroundColor:[UIColor whiteColor]];

        aTouches = [NSMutableArray array];
        paths = [NSMutableArray array];
        
    }
    return self;
}

- (void) eraseDrawing{

    
    for (UIBezierPath *p in paths) {
        
        [p removeAllPoints];
        [self setNeedsDisplay];
    }
}



- (void)drawRect:(CGRect)rect // (4)
{
    
    for (UIBezierPath *p in paths) {
        
        [[UIColor blackColor] setStroke];
        [p stroke];
    }
    
    
}

- (void) movePath:(UIBezierPath *)path toTouch:(UITouch *)touch{
    
    CGPoint p = [touch locationInView:self];
    [path moveToPoint:p];

}
- (void) addLinetoPath:(UIBezierPath *)path atTouch:(UITouch *)touch{
    
    CGPoint p = [touch locationInView:self];
    [path addLineToPoint:p]; // (4)
    [self setNeedsDisplay];

}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSArray *allTouches = [[event.allTouches allObjects] sortedArrayUsingSelector:@selector(compareAddress:)];
    
    NSLog(@"B[%d][%d]",[touches count],[allTouches count]);
    
    for (UITouch *t in allTouches) {
        UIBezierPath *p = [UIBezierPath bezierPath];
        [p setLineWidth:2.0];
        [aTouches addObject:t];
        [paths addObject:p];
        [self movePath:p toTouch:t];
    }

}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    NSArray *allTouches = [[event.allTouches allObjects] sortedArrayUsingSelector:@selector(compareAddress:)];
    
    NSLog(@"M[%d][%d]",[touches count],[allTouches count]);
    
    for (UITouch *t in allTouches) {
        
        int index = [aTouches indexOfObject:t];
        if (index < [paths count]) {
            UIBezierPath *p = paths[index];
            [self addLinetoPath:p atTouch:t];
        
        }
    }
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesMoved:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesEnded:touches withEvent:event];
}
@end
