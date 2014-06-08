//
//  TranslationController.m
//  MyTravel
//
//  Created by liunan on 14-6-7.
//  Copyright (c) 2014年 liunan. All rights reserved.
//

#import "TranslationController.h"
#import "TranslationManager.h"

@interface TranslationController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *cn2jaBtn;
@property (weak, nonatomic) IBOutlet UIButton *cn2enBtn;

@property (weak, nonatomic) IBOutlet UITextView *outputTextView;
@property (weak, nonatomic) IBOutlet UITextView *inputTextView;

- (IBAction)onTouchCn2JaBtn:(id)sender;
- (IBAction)onTouchCn2EnBtn:(id)sender;
@end

@implementation TranslationController

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
    self.outputTextView.editable = NO;
    self.inputTextView.delegate = self;
    
    UITapGestureRecognizer *tapGestureRecoginzer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    [self.view addGestureRecognizer:tapGestureRecoginzer];
}

- (void)onTap:(UIGestureRecognizer *)tapGestureRecognizer
{
    [self.inputTextView resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (range.location != NSNotFound) {
        if ([text isEqualToString:@"\n"]) {
            [self.inputTextView resignFirstResponder];
            return NO;
        }
    }
    return YES;
}

- (IBAction)onTouchCn2EnBtn:(id)sender
{
    NSString *inputText = self.inputTextView.text;
    [self.inputTextView resignFirstResponder];
    self.cn2enBtn.enabled = NO;
    self.cn2jaBtn.enabled = NO;
    
    [[TranslationManager sharedInstance] translateCn2En:inputText completion:^(NSString *output) {
        self.outputTextView.text = output;
        self.cn2enBtn.enabled = YES;
        self.cn2jaBtn.enabled = YES;
    }];
}

- (IBAction)onTouchCn2JaBtn:(id)sender
{
    NSString *inputText = self.inputTextView.text;
    [self.inputTextView resignFirstResponder];
    self.cn2enBtn.enabled = NO;
    self.cn2jaBtn.enabled = NO;
    
    [[TranslationManager sharedInstance] translateCn2Ja:inputText completion:^(NSString *output) {
        self.outputTextView.text = output;
        self.cn2enBtn.enabled = YES;
        self.cn2jaBtn.enabled = YES;
    }];
}

@end
