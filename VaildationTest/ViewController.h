//
//  ViewController.h
//  VaildationTest
//
//  Created by obigo on 2020/09/15.
//  Copyright © 2020 obigo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITextFieldDelegate>{
    
    IBOutlet UITextField *idEmail;
    IBOutlet UITextField *password;
    IBOutlet UITextField *passwordCheck;
    IBOutlet UITextField *name;
    IBOutlet UITextField *birth;
    IBOutlet UITextField *gender;
    IBOutlet UITextField *telNum;
    

    IBOutlet UIButton *idDoudleCheck;
    IBOutlet UIButton *nextBtn;
    
    IBOutlet UILabel *emailLabel;
    IBOutlet UILabel *idLabel;
    IBOutlet UILabel *pwLabel;
    IBOutlet UILabel *repwLabel;
}

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@end

