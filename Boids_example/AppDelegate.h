//
//  AppDelegate.h
//  Boids_example
//
//  Created by Xc Xu on 2/13/12.
//  Copyright Break-medai 2012. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;

@end
