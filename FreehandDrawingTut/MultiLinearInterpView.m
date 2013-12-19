#import "MultiLinearInterpView.h"


@implementation UITouch (TouchSorting)

- (NSComparisonResult)compareAddress:(id)obj {
    if ((__bridge void *)self < (__bridge void *)obj) return NSOrderedAscending;
    else if ((__bridge void *)self == (__bridge void *)obj) return NSOrderedSame;
	else return NSOrderedDescending;
}
@end



@implementation MultiLinearInterpView
{
    NSMutableArray *paths;
    NSMutableDictionary *dict;
    
}

- (void) createPaths{
    
    for (int i = 0; i<10; i++) {

        UIBezierPath *bPath = [UIBezierPath bezierPath];
        [bPath setLineWidth:2.0];
        [paths addObject:bPath];
        

    }
}
- (id)initWithCoder:(NSCoder *)aDecoder // (1)
{
    if (self = [super initWithCoder:aDecoder])
    {
        
        [self setMultipleTouchEnabled:YES]; // (2)
        [self setBackgroundColor:[UIColor whiteColor]];
        
        paths = [NSMutableArray array];
        [self createPaths];
        
        dict = [NSMutableDictionary dictionary];
        




    }
    return self;
}

- (void)drawRect:(CGRect)rect // (4)
{

    for (UIBezierPath *p in paths) {

        CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
        CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
        CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
        UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
        [color setStroke];
        [p stroke];
    }
    
//    for (id key in [dict allKeys]) {
//        
//        UIBezierPath *pt = [dict objectForKey:key];
//        [[UIColor blueColor] setStroke];
//        [pt stroke];
//        
//    }

}

- (void) createBezierPathWithTouches:(NSArray *)touches{
    
    for (id t in touches) {
        
        UIBezierPath *bPath = [UIBezierPath bezierPath];
        [bPath setLineWidth:2.0];

        [dict setObject:bPath forKey:t];
        
    }
    
}

/******************** MULTIPLE LINES DRAWING **************************/

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSArray *arrTouches = [[event.allTouches allObjects] sortedArrayUsingSelector:@selector(compareAddress:)];

    NSLog(@"A[%d][%d]",[touches count],[arrTouches count]);

//    [self createBezierPathWithTouches:arrTouches];

    [arrTouches enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    
        UITouch *touch = (UITouch *)obj;
        CGPoint point = [touch locationInView:self];
        [paths[idx] moveToPoint:point];
        
    }];

}



- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{

    NSArray *arrTouches = [[event.allTouches allObjects] sortedArrayUsingSelector:@selector(compareAddress:)];
    NSLog(@"B[%d][%d]",[touches count],[arrTouches count]);

//    for (id t in arrTouches) {
//        
//        UIBezierPath *p = [dict objectForKey:t];
//        UITouch *touch = (UITouch *)t;
//        CGPoint point = [touch locationInView:self];
//        [p addLineToPoint:point];
//        
//    }
    [arrTouches enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        UITouch *touch = (UITouch *)obj;
        CGPoint point = [touch locationInView:self];
        [paths[idx] addLineToPoint:point];
        
    }];
    
    [self setNeedsDisplay];

    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    [self touchesMoved:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesEnded:touches withEvent:event];
}

- (void) eraseDrawing{
    
    [paths enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
       
        [(UIBezierPath*)obj removeAllPoints];
    }];
    
    [self setNeedsDisplay];

}

@end
