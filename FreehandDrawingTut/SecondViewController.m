//
//  SecondViewController.m
//  FreehandDrawingTut
//
//  Created by Ahsan on 12/18/13.
//
//

#import "SecondViewController.h"

@interface SecondViewController (){
    
    __weak IBOutlet UIView *placardView;
    
}

@end

@implementation SecondViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    // App supports only single touches, so anyObject retrieves just
    // that touch from touches
    UITouch *touch = [touches anyObject];
    
    // Move the placard view only if the touch was in the placard view
    if ([touch view] != placardView) {
        // In case of a double tap outside the placard view, update
        // the placard's display string
        if ([touch tapCount] == 2) {
//            [placardView setupNextDisplayString];
        }
        return;
    }
    
    // Animate the first touch
    CGPoint touchPoint = [touch locationInView:self.view];
    [self animateFirstTouchAtPoint:touchPoint];


}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    
    // If the touch was in the placardView, move the placardView to its location
    if ([touch view] == placardView) {
        CGPoint location = [touch locationInView:self.view];
        placardView.center = location;
    }
}



- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    
    // If the touch was in the placardView, bounce it back to the center
    if ([touch view] == placardView) {
        // Disable user interaction so subsequent touches
        // don't interfere with animation
        self.view.userInteractionEnabled = YES;
//        [self animatePlacardViewToCenter];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    
    // To impose as little impact on the device as possible, simply set
    // the placard view's center and transformation to the original values
    placardView.center = self.view.center;
    placardView.transform = CGAffineTransformIdentity;
}

- (void) animateFirstTouchAtPoint:(CGPoint)points{
    
    [placardView setCenter:points];
}

@end
