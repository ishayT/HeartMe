//
//  ViewController.h
//  HeartMe
//
//  Created by Ishay on 8/1/18.
//  Copyright © 2018 Ishay. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *pageHeader;
@property (weak, nonatomic) IBOutlet UITextField *testNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *testResultTextField;
@property (weak, nonatomic) IBOutlet UILabel *outputLabelForUser;
@property (weak, nonatomic) IBOutlet UIImageView *smielyImageForUser;

- (IBAction)submitResultsButtonPressed:(UIButton *)sender;

@end

