//
//  RootViewController.m
//  Restaurants
//
//  Created by Philip Tolton on 10/28/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import "RootViewController.h"
#import "REFrostedViewController.h"
//#import "CHDraggableView.h"
//#import "CHDraggableView+Avatar.h"
#import "CHDraggableView+OrderTracker.h"
#import "OrderTrackerViewController.h"
#import "RAppDelegate.h"
#import "UserSession.h"

@interface RootViewController ()

@end

@implementation RootViewController

    CGSize avatar_size;
    UIWindow *win;

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
}

-(void) viewDidAppear:(BOOL)animated {
    win = self.view.window;
    avatar_size = CGSizeMake(100, 100);
    CGRect boundz = CGRectMake(0, 0, avatar_size.width, avatar_size.height);
    _draggingCoordinator = [[CHDraggingCoordinator alloc] initWithWindow:win draggableViewBounds:boundz];
    _draggingCoordinator.delegate = self;
    _draggingCoordinator.snappingEdge = CHSnappingEdgeBoth;
}

-(void) showOldOrders {
    User *main = [[UserSession sharedManager] fetchUser];
    NSLog(@"Putting old orders out");
    for(Order_Status *o in main.current_orders){
        NSLog(@"Tracking old order: %@",o.order_id);
        [self trackOrder:o.order_id confirmed:o.confirmed];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIViewController *)draggingCoordinator:(CHDraggingCoordinator *)coordinator viewControllerForDraggableView:(CHDraggableView *)draggableView
{
    return [self.storyboard instantiateViewControllerWithIdentifier:@"orderTracker"];
}

- (void)awakeFromNib
{
    self.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"contentViewController"];
    self.menuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"menuViewController"];
}

- (void) trackOrder:(NSString *)order_id {
    CHDraggableView *draggableView = [CHDraggableView draggableViewWithImage:[UIImage imageNamed:@"stop_watch.png"] size:avatar_size];
    draggableView.tag = 1;
    [draggableView set_order_id:order_id];
    [draggableView timer:[NSNumber numberWithInt:10]];
    draggableView.delegate = _draggingCoordinator;
    [win addSubview:draggableView];
}

- (void) trackOrder:(NSString *)order_id confirmed:(int) confirmed {
    UIWindow *win = self.view.window;
    CHDraggableView *draggableView = [CHDraggableView draggableViewWithImage:[UIImage imageNamed:@"stop_watch_confirmed.png"] size:avatar_size];
    draggableView.tag = 1;
    [draggableView set_order_id:order_id];
    if(confirmed != 0){
        [draggableView timer:[NSNumber numberWithInt:10]];
    }
    draggableView.delegate = _draggingCoordinator;
    [win addSubview:draggableView];
}

@end
