//
//  ClTPhoneViewController.h
//  ClearTokenApp
//
//  Created by Ravi Patel on 21/05/15.
//  Copyright (c) 2015 ClearToken. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClTPhoneViewController : UIViewController{
    
    __weak IBOutlet NSLayoutConstraint *rightDoneConst;
    __weak IBOutlet NSLayoutConstraint *horzSpace;
    __weak IBOutlet NSLayoutConstraint *phnWid;
    

}

@property (weak, nonatomic) IBOutlet UILabel *labelHintMessage;


@property (weak, nonatomic) IBOutlet UIButton *buttonBack;



@property (weak, nonatomic) IBOutlet UITextField *textFieldPhoneNo;



@property (weak, nonatomic) IBOutlet UIButton *buttonDone;

@end
