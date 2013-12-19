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
    UIBezierPath *path1; // (3)
    UIBezierPath *path2; // (3)
}

- (id)initWithCoder:(NSCoder *)aDecoder // (1)
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self setMultipleTouchEnabled:YES]; // (2)
        [self setBackgroundColor:[UIColor whiteColor]];

        aTouches = [NSMutableArray array];
        paths = [NSMutableArray array];
        
        path1 = [UIBezierPath bezierPath];
        [path1 setLineWidth:2.0];
        
        path2 = [UIBezierPath bezierPath];
        [path2 setLineWidth:2.0];

    }
    return self;
}

- (void) eraseDrawing{

    
    for (UIBezierPath *p in paths) {
        
        [p removeAllPoints];
        [self setNeedsDisplay];
    }
    return;
    [path1 removeAllPoints];
    [path2 removeAllPoints];
    
    [self setNeedsDisplay];
}



- (void)drawRect:(CGRect)rect // (4)
{
    
    for (UIBezierPath *p in paths) {
        
        [[UIColor blackColor] setStroke];
        [p stroke];
    }
    
    return;
    
    [[UIColor blackColor] setStroke];
    [path1 stroke];
    
    [[UIColor redColor] setStroke];
    [path2 stroke];

    
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

    
    return;
    
    switch ([allTouches count]) {
        case 1:
            [self movePath:path1 toTouch:allTouches[0]];
            break;
        case 2:{
            one = allTouches[0];
            two = allTouches[1];
            
            
            [self movePath:path1 toTouch:allTouches[0]];
            [self movePath:path2 toTouch:allTouches[1]];
            break;
        }
        default:
            break;
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
    
    return;
    switch ([allTouches count]) {
        case 1: {
            if (one == allTouches[0]) {
                [self addLinetoPath:path1 atTouch:allTouches[0]];
            } else {
                [self addLinetoPath:path2 atTouch:allTouches[0]];
            }
        }
            break;
        case 2:{
            [self addLinetoPath:path1 atTouch:allTouches[0]];
            [self addLinetoPath:path2 atTouch:allTouches[1]];
            break;
        }
        default:
            break;
    }

//    UITouch *touch = [touches anyObject];
//    CGPoint p = [touch locationInView:self];
//    [path1 addLineToPoint:p]; // (4)
//    [self setNeedsDisplay];
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
