//
//  RootViewController.m
//  Restaurants
//
//  Created by Philip Tolton on 10/28/2013.
//  Copyright (c) 2013 Philip Tolton. All rights reserved.
//

#import "RootViewController.h"
#import "REFrostedViewController.h"
#import "CHDraggableView.h"
#import "CHDraggableView+Avatar.h"
#import "AddressForDeliveryViewController.h"
#import "RAppDelegate.h"

@interface RootViewController ()

@end

@implementation RootViewController

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIViewController *)draggingCoordinator:(CHDraggingCoordinator *)coordinator viewControllerForDraggableView:(CHDraggableView *)draggableView
{
    return [[AddressForDeliveryViewController alloc] initWithNibName:@"AddressForDeliveryViewController" bundle:nil];
}

- (void)awakeFromNib
{
    self.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"contentViewController"];
    self.menuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"menuViewController"];
}

- (void) trackOrder:(NSString *)order_id {
    UIWindow *win = self.view.window;
    
    NSLog(@"IMAGE SIZE: %@",CGRectCreateDictionaryRepresentation(self.view.window.frame));
    
    CHDraggableView *draggableView = [CHDraggableView draggableViewWithImage:[UIImage imageNamed:@"stop_watch.png"] size:CGSizeMake(100, 100)];
    draggableView.tag = 1;
    
    _draggingCoordinator = [[CHDraggingCoordinator alloc] initWithWindow:win draggableViewBounds:draggableView.bounds];
    _draggingCoordinator.delegate = self;
    _draggingCoordinator.snappingEdge = CHSnappingEdgeBoth;
    draggableView.delegate = _draggingCoordinator;
    
    [win addSubview:draggableView];
}

@end
