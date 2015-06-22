//
//  ClTLoadingActivity.m
//  ClearToken
//
//  Created by Ravi Patel on 08/05/15.
//  Copyright (c) 2015 ClearToken. All rights reserved.
//

#import "ClTLoadingActivity.h"
#import "Utility.h"

static ClTLoadingActivity* loading;

@implementation ClTLoadingActivity


- (id)init{
    return nil;
}




/*********************************************************************************
 @function	-myinit
 @discussion This is instance method which is responsible for create the custom Activity indicator UI.
 *********************************************************************************/

- (id)myinit
{
    if( (self = [super init]))
    {
        
        UIWindow* keywindow = [[[UIApplication sharedApplication] delegate] window];
        busyCount = 0;
        
        view= [[UIView alloc] init];
        view.frame=keywindow.frame;
        [view.layer setCornerRadius:10.0f];
        view.backgroundColor = [UIColor clearColor];
        
        UIView *mView = [[UIView alloc] init];
        mView.frame=view.frame;
        [mView setBackgroundColor:[UIColor blackColor]];
        [mView setAlpha:0.4];
        [view addSubview:mView];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
        imageView.frame=mView.frame;
        [imageView setBackgroundColor:[UIColor clearColor]];
        [view addSubview:imageView];
        
        busyLabel = [[UILabel alloc] init];
        //busyLabel.textColor = [UIColor blackColor];
        busyLabel.numberOfLines = 2;
        busyLabel.frame=CGRectMake((mView.frame.size.width/2)-50, (mView.frame.size.height/2)-50, 100, 100);
        busyLabel.backgroundColor = [UIColor blackColor];
        busyLabel.alpha=0.8;
        // busyLabel.text =@"Processing Request... Please Wait";
        busyLabel.textAlignment = NSTextAlignmentCenter;
        [imageView addSubview:busyLabel];
        
        [busyLabel.layer setBorderColor:[[UIColor blackColor] CGColor]];
        [busyLabel.layer setBorderWidth:1.0];
        [busyLabel.layer setCornerRadius:8.0];
        [busyLabel.layer setMasksToBounds:YES];
        
        wait = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        wait.hidesWhenStopped = NO;
        wait.center=busyLabel.center;
        [imageView addSubview:wait];
        
        [wait startAnimating];
        
        return self;
    }
    
    return nil;
}




/*********************************************************************************
 @function	-makeBusy:
 @discussion	This method increase the dicrease the busyCount value.
 @param	 1. yesOrno: BOOl value use for show or hide the Activity Indicator.
 *********************************************************************************/
- (void) makeBusy:(BOOL)yesOrno{
    if(yesOrno){
        
        busyCount++;
        NSLog(@"count++=%d",busyCount);
        
        
    }else {
        busyCount--;
        NSLog(@"count--=%d",busyCount);
        if(busyCount<0){
            busyCount = 0;
        }
    }
    
        
    if(busyCount == 1)
    {
        [[[UIApplication sharedApplication] keyWindow] addSubview:view];
        [[[UIApplication sharedApplication] keyWindow] bringSubviewToFront:view];
    }else if(busyCount == 0) {
        [view removeFromSuperview];
    }else {
        [[[UIApplication sharedApplication] keyWindow] bringSubviewToFront:view];
    }
    
}



/*********************************************************************************
 @function	-forceRemoveBusyState:
 @discussion	This method remove the Activity Indicator from superView.
 *********************************************************************************/
- (void) forceRemoveBusyState{
    busyCount = 0;
    [view removeFromSuperview];
}



/*********************************************************************************
 @function	-defaultAgent:
 @discussion	This method create the instance of ClTLoadingActivity class.
 @return This method return the instance of ClTLoadingActivity class.
 *********************************************************************************/

+ (ClTLoadingActivity*)defaultAgent{
    if(!loading){
        loading =[[ClTLoadingActivity alloc] myinit];
    }
    return loading;
}



/*********************************************************************************
 @function	-shouldAutorotateToInterfaceOrientation:
 @discussion	This method check the orientation of the app's user interface
  *********************************************************************************/

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void)dealloc{
    [view release];
    [wait release];
    [busyLabel release];
    [super dealloc];
}



@end
