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

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *translateBtns;

@property (weak, nonatomic) IBOutlet UITextView *outputTextView;
@property (weak, nonatomic) IBOutlet UITextView *inputTextView;

- (IBAction)translateAction:(id)sender;
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

- (IBAction)translateAction:(id)sender
{
    NSString *inputText = self.inputTextView.text;
    TranslationType type = [(UIButton *)sender tag];
    for (UIButton *btn in self.translateBtns)
    {
        btn.enabled = NO;
    }
    
    [[TranslationManager sharedInstance] translate:inputText type:type completion:^(NSString *output) {
        self.outputTextView.text = output;
        for (UIButton *btn in self.translateBtns)
        {
            btn.enabled = YES;
        }
    }];
}

@end
