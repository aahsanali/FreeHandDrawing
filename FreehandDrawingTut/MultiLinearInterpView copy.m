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
    UIBezierPath *path, *path1, *path2, *path3; // (3)
    NSArray *paths;
    NSMutableArray *dynamicPaths;
    
//    NSMutableDictionary *
}

- (id)initWithCoder:(NSCoder *)aDecoder // (1)
{
    if (self = [super initWithCoder:aDecoder])
    {
        
        [self setMultipleTouchEnabled:YES]; // (2)
        [self setBackgroundColor:[UIColor whiteColor]];
        
        
        path1 = [UIBezierPath bezierPath];
        [path1 setLineWidth:2.0];
        
        path2 = [UIBezierPath bezierPath];
        [path2 setLineWidth:2.0];

        
        path3 = [UIBezierPath bezierPath];
        [path3 setLineWidth:2.0];

        
        paths =@[path1,path2,path3];
        
        dynamicPaths = [NSMutableArray array];
        
        
        
//        path = [UIBezierPath bezierPath];
//        [path setLineWidth:2.0];

    }
    return self;
}

- (void)drawRect:(CGRect)rect // (4)
{
    [[UIColor blackColor] setStroke];
    [path1 stroke];
    
    [[UIColor redColor] setStroke];
    [path2 stroke];

}

- (void) createBezierPathWithTouches:(NSSet *)touches{
    
    
}
//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    [self cacheBeginPointForTouches:touches];
//}
//
//- (void)cacheBeginPointForTouches:(NSSet *)touches {
//    if ([touches count] > 0) {
//        for (UITouch *touch in [touches allObjects]) {
//            
//            
//            CGPoint *point = (CGPoint *)CFDictionaryGetValue(touchBeginPoints, (__bridge const void *)(touch));
//            if (point == NULL) {
//                point = (CGPoint *)malloc(sizeof(CGPoint));
//                CFDictionarySetValue(touchBeginPoints, (__bridge const void *)(touch), point);
//            }
//            *point = [touch locationInView:self];
//        }
//    }
//}
//
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//    [self incrementalTransformWithTouches:touches];
//}
//
//- (CGAffineTransform)incrementalTransformWithTouches:(NSSet *)touches {
//
//    NSArray *sortedTouches = [[touches allObjects] sortedArrayUsingSelector:@selector(compareAddress:)];
//    
//    [sortedTouches enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//        
//        NSLog(@"Address:%@",obj);
//
//    }];
//    NSLog(@"(%d)",[sortedTouches count]);
//    
//    // Other code here
//    CGAffineTransform transform = CGAffineTransformIdentity;
//    
////    UITouch *touch1 = [sortedTouches objectAtIndex:0];
////    UITouch *touch2 = [sortedTouches objectAtIndex:1];
//    
////    CGPoint beginPoint1 = *(CGPoint *)CFDictionaryGetValue(touchBeginPoints, (__bridge const void *)(touch1));
////    CGPoint currentPoint1 = [touch1 locationInView:self];
////    CGPoint beginPoint2 = *(CGPoint *)CFDictionaryGetValue(touchBeginPoints, (__bridge const void *)(touch2));
////    CGPoint currentPoint2 = [touch2 locationInView:self];
//    
//    
//    // Compute the affine transform
//    return transform;
//}
//

/******************** MULTIPLE LINES DRAWING **************************/

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSArray *arrTouches = [[event.allTouches allObjects] sortedArrayUsingSelector:@selector(compareAddress:)];

    NSLog(@"A[%d]",[arrTouches count]);
    if([arrTouches count] <2) return;
    
    UITouch *touch1 = arrTouches[0];
    UITouch *touch2 = arrTouches[1];
    
    
    CGPoint p1 = [touch1 locationInView:self];
    [paths[0] moveToPoint:p1];
    
    CGPoint p2 = [touch2 locationInView:self];
    [paths[1] moveToPoint:p2];

    NSLog(@"[%@] [%@]",NSStringFromCGPoint(p1),NSStringFromCGPoint(p1));
}



- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
//    NSArray *arrTouches = [touches allObjects];
    
    NSArray *arrTouches = [[event.allTouches allObjects] sortedArrayUsingSelector:@selector(compareAddress:)];
    NSLog(@"B[%d]",[arrTouches count]);
    
    if([arrTouches count] <2) return;
    
    UITouch *touch1 = arrTouches[0];
    UITouch *touch2 = arrTouches[1];
    
    CGPoint p1 = [touch1 locationInView:self];
    CGPoint p2 = [touch2 locationInView:self];
    
    NSLog(@"(%@) (%@)",NSStringFromCGPoint(p1),NSStringFromCGPoint(p1));
    
    [paths[0] addLineToPoint:p1]; // (4)
    [paths[1] addLineToPoint:p2]; // (4)
    
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
        [self setNeedsDisplay];
    }];
}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    UITouch *touch = [touches anyObject];
//    CGPoint p = [touch locationInView:self];
//    [path moveToPoint:p];
//}
//
//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    UITouch *touch = [touches anyObject];
//    CGPoint p = [touch locationInView:self];
//    [path addLineToPoint:p]; // (4)
//    [self setNeedsDisplay];
//}
//
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [self touchesMoved:touches withEvent:event];
//}
//
//- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    [self touchesEnded:touches withEvent:event];
//}
@end
