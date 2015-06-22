//
//  ClTLoadingActivity.h
//  ClearToken
//
//  Created by Ravi Patel on 08/05/15.
//  Copyright (c) 2015 ClearToken. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ClTLoadingActivity : NSObject {
    UIView* view;
    UIView *IndicatorView;
    UIActivityIndicatorView* wait;
    UILabel* busyLabel;
    int busyCount;
    UIButton *CancelButton;
}

/* Pass 'YES' if want to show activity indicator. 'NO' if you want to stop animating */
- (void) makeBusy:(BOOL)yesOrno;
- (void) forceRemoveBusyState;

+ (ClTLoadingActivity*)defaultAgent;
@end
