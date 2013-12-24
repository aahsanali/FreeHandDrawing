#import "MultiLineCachedLIView.h"

@implementation UITouch (TouchSorting)

- (NSComparisonResult)compareAddress:(id)obj {
    if ((__bridge void *)self < (__bridge void *)obj) return NSOrderedAscending;
    else if ((__bridge void *)self == (__bridge void *)obj) return NSOrderedSame;
	else return NSOrderedDescending;
}
@end


@implementation MultiLineCachedLIView
{
//    UIBezierPath *path;
    UIImage *incrementalImage; // (1)
    
    NSMutableArray *aTouches;
    NSMutableArray *paths;

}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self setMultipleTouchEnabled:YES];
        [self setBackgroundColor:[UIColor whiteColor]];
        
        aTouches = [NSMutableArray array];
        paths = [NSMutableArray array];
        
//        path = [UIBezierPath bezierPath];
//        [path setLineWidth:2.0];
        
    }
    return self;
}
- (void) eraseDrawing{

    incrementalImage = nil;
    [self setNeedsDisplay];
    
}

- (void)drawRect:(CGRect)rect
{
    [incrementalImage drawInRect:rect]; // (3)
    
    [paths enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        [(UIBezierPath *)obj stroke];
    }];
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

- (void)appendTouches:(NSArray *)allTouches
{
    for (UITouch *t in allTouches) {
        
        int index = [aTouches indexOfObject:t];
        
        if (index < [paths count]) {
            UIBezierPath *p = paths[index];
            [self addLinetoPath:p atTouch:t];
            
            
        }
        
    }
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    

    NSArray *allTouches = [[touches allObjects] sortedArrayUsingSelector:@selector(compareAddress:)];
    
//    NSArray *allTouches = [[event.allTouches allObjects] sortedArrayUsingSelector:@selector(compareAddress:)];
    
    NSLog(@"B[%d][%d]",[touches count],[allTouches count]);
    
    for (UITouch *t in touches) {
        
        UIBezierPath *p = [UIBezierPath bezierPath];
        [p stroke];
        [p setLineWidth:2.0];
        [aTouches addObject:t];
        [paths addObject:p];
        [self movePath:p toTouch:t];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    NSArray *allTouches = [[touches allObjects] sortedArrayUsingSelector:@selector(compareAddress:)];
    
//    NSArray *allTouches = [[event.allTouches allObjects] sortedArrayUsingSelector:@selector(compareAddress:)];

    
    NSLog(@"M[%d][%d]",[touches count],[allTouches count]);
    
    [self appendTouches:touches];
    
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event // (2)
{
//    NSArray *allTouches = [[touches allObjects] sortedArrayUsingSelector:@selector(compareAddress:)];
    
//    NSArray *allTouches = [[event.allTouches allObjects] sortedArrayUsingSelector:@selector(compareAddress:)];

    
//    NSLog(@"E[%d][%d]",[touches count],[allTouches count]);
    
    
//    [self appendTouches:allTouches];
    
    [self drawBitmap]; // (3)
    
    [aTouches removeAllObjects]; //(4)
    [paths removeAllObjects];

}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesEnded:touches withEvent:event];
}

- (void)drawBitmap // (3)
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, 0.0);
    [[UIColor blackColor] setStroke];

//    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
//    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
//    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
//    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
//    [color setStroke];
    
    if (!incrementalImage) // first draw; paint background white by ...
    {
        UIBezierPath *rectpath = [UIBezierPath bezierPathWithRect:self.bounds]; // enclosing bitmap by a rectangle defined by another UIBezierPath object
        [[UIColor whiteColor] setFill]; 
        [rectpath fill]; // filling it with white
    }
    
    [incrementalImage drawAtPoint:CGPointZero];
    
    
    [paths enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
       
        UIBezierPath *p = (UIBezierPath *)obj;
        [p stroke];
        
    }];

    incrementalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}
@end
