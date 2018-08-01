//
//  ViewController.m
//  HeartMe
//
//  Created by Ishay on 7/31/18.
//  Copyright © 2018 Ishay. All rights reserved.
//

#import "ViewController.h"
#import "BloodTestConfig.h"

@interface ViewController () <UITextFieldDelegate>{
    
}

@property NSMutableArray<BloodTestConfig *> *bloodTestsArray;

//(strong, nonatomic)

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self fetchHeartDataFromJson];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) fetchHeartDataFromJson {
    
    NSString *urlAddress = @"https://s3.amazonaws.com/s3.helloheart.home.assignment/bloodTestConfig.json";
    
    NSURL *url = [NSURL URLWithString:urlAddress];
    
    [[NSURLSession.sharedSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSError *err;
        
        NSDictionary *jsonDictionery = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
        
        if(err) {
            NSLog(@"faild to serlize the json with ERROR: %@", err);
            return;
        }
        
        NSMutableArray *bloodtestsJSON = [jsonDictionery objectForKey:@"bloodTestConfig"];
        
        NSLog(@"%@", bloodtestsJSON);
    
        for(int i=0; i< bloodtestsJSON.count; i++){
            BloodTestConfig *bloodTest = BloodTestConfig.new;
            bloodTest.name = [[bloodtestsJSON objectAtIndex: i]objectForKey:@"name"];
            bloodTest.threshold = [[bloodtestsJSON objectAtIndex: i]objectForKey:@"threshold"];
            
            
            [_bloodTestsArray addObject: bloodTest];
        }
        
        NSLog(@"finished parsing the blood test array");
        
    }]resume];
}


- (IBAction)submitResultsButtonPressed:(UIButton *)sender {
    
    NSString *testName = self.testNameTextField.text;
    NSString *testResult = self.testResultTextField.text;
    
    [self checkInputFromUser:testName withResult:testResult];
    
}

-(void) checkInputFromUser:(NSString*)testName withResult:(NSString*)testResult {
    
    NSString *sadSmeiley = @"sad smiely 512.png";
    NSString *happySmeiley = @"happy smiely 512.png";
    NSString *confusedSmeiley = @"confused smiely 512.png";
    
    if ([testName containsString:@"HDL"] || [testName containsString:@"hdl"] || [testName containsString:@"Hdl"]) {
        
        if (testResult.intValue > 40) {
            self.outputLabelForUser.text = [NSString stringWithFormat:@"HDL Colesterol: %@, too high", testResult];
            _smielyImageForUser.image = [UIImage imageNamed:sadSmeiley];
        } else {
            self.outputLabelForUser.text = [NSString stringWithFormat:@"HDL Colesterol: %@, it's good", testResult];
            _smielyImageForUser.image = [UIImage imageNamed:happySmeiley];
        }
        
    } else if([testName containsString:@"LDL"] || [testName containsString:@"ldl"] || [testName containsString:@"Ldl"]) {
        
        if (testResult.intValue > 100) {
            self.outputLabelForUser.text = [NSString stringWithFormat:@"LDL Colesterol: %@, too high", testResult];
            _smielyImageForUser.image = [UIImage imageNamed:sadSmeiley];
        } else {
            self.outputLabelForUser.text = [NSString stringWithFormat:@"LDL Colesterol: %@, it's good", testResult];
            _smielyImageForUser.image = [UIImage imageNamed:happySmeiley];
        }
        
    } else if([testName containsString:@"A1C"] || [testName containsString:@"a1c"] || [testName containsString:@"A1c"]) {
        
        if (testResult.intValue > 4) {
            self.outputLabelForUser.text = [NSString stringWithFormat:@"A1C: %@, too high", testResult];
            _smielyImageForUser.image = [UIImage imageNamed:sadSmeiley];
        } else {
            self.outputLabelForUser.text = [NSString stringWithFormat:@"A1C: %@, it's good", testResult];
            _smielyImageForUser.image = [UIImage imageNamed:happySmeiley];
        }
    } else {
        self.outputLabelForUser.text = [NSString stringWithFormat:@"Unknown"];
        _smielyImageForUser.image = [UIImage imageNamed:confusedSmeiley];
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    NSInteger newLength = [textField.text length] + [string length] - range.length;
    NSInteger match = 1;
    NSString *pattern1 = @"[A-Z0-9a-z(),-:/\n]";
    NSString *pattern2 = @"[0-9.\n]";
    NSError *error;
    
    if([string length]==0){
        return YES;
    }
    
    if (textField.tag == 1) {
        
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern1 options:0 error:&error];
        
        if (![string canBeConvertedToEncoding:NSASCIIStringEncoding]){
            match = 0;
        } else if ([string length]>0) {
            match = [regex numberOfMatchesInString:string options:0 range:NSMakeRange(0, 1)];
        }
        
        if (match != 1) {
            return NO;
        }
        
        return (newLength > 15) ? NO : YES;
        
    } else {
        
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern2 options:0 error:&error];
        
        if (![string canBeConvertedToEncoding:NSASCIIStringEncoding]){
            match = 0;
        } else if ([string length]>0) {
            match = [regex numberOfMatchesInString:string options:0 range:NSMakeRange(0, 1)];
        }
        
        if (match != 1) {
            return NO;
        }
 
        return (newLength > 5) ? NO : YES;
    }
    return NO;
}

@end

