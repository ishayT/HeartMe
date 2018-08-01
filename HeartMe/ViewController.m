//
//  ViewController.m
//  HeartMe
//
//  Created by Ishay on 7/31/18.
//  Copyright © 2018 Ishay. All rights reserved.
//

#import "ViewController.h"
#import "BloodTestConfig.h"

@interface ViewController (){
    
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
    NSLog(@"fetching data...");
    
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
        
        //        NSMutableArray * bloodTestArray = [[NSMutableArray alloc]init];
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

-(Boolean) checkInputFromUser:(NSString*)testName withResult:(NSString*)testResult {
    
    NSRange  searchedRange = NSMakeRange(0, [testName length]);
    //    'A-Z', 'a-z', '0-9' and '(),-:/
    //    @"(?:www\\.)?((?!-)[a-zA-Z0-9-]{2,63}(?<!-))\\.?((?:[a-zA-Z0-9]{2,})?(?:\\.[a-zA-Z0-9]{2,})?)"
    NSString *pattern = @"(?:www\\.)?((?!-)[a-zA-Z0-9-]{2,63}(?<!-))\\.?((?:[a-zA-Z0-9]{2,})?(?:\\.[a-zA-Z0-9]{2,})?)";
    NSError  *error = nil;
    
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern: pattern options:0 error:&error];
    NSArray* matches = [regex matchesInString:testName options:0 range: searchedRange];
    for (NSTextCheckingResult* match in matches) {
        NSString* matchText = [testName substringWithRange:[match range]];
        NSLog(@"match: %@", matchText);
        NSRange group1 = [match rangeAtIndex:1];
        NSRange group2 = [match rangeAtIndex:2];
        NSLog(@"group1: %@", [testName substringWithRange:group1]);
        NSLog(@"group2: %@", [testName substringWithRange:group2]);
    }
    
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
    
    
    return true;
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    /*  limit to only numeric characters  */
    NSCharacterSet *myCharSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    for (int i = 0; i < [string length]; i++) {
        unichar c = [string characterAtIndex:i];
        if ([myCharSet characterIsMember:c]) {
            return YES;
        }
    }
    return NO;
}


@end

