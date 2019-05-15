//
//  ViewController.m
//  CKAudioProgress
//
//  Created by guo on 2019/5/14.
//  Copyright © 2019 guo. All rights reserved.
//

#import "ViewController.h"
#import "CKAudioProgressView.h"

@interface ViewController ()

@property (nonatomic, strong) CKAudioProgressView *normalProgressV;
@property (nonatomic, strong) CKAudioProgressView *timelineProgressV;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CKAudioProgressView *normalP = [[CKAudioProgressView alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 50) type:CKAudioProgressTypeNormal];
    CKAudioProgressView *timelineP = [[CKAudioProgressView alloc] initWithFrame:CGRectMake(0, 200, self.view.bounds.size.width, 50) type:CKAudioProgressTypeTimeline];
    [self.view addSubview:normalP];
    [self.view addSubview:timelineP];
    self.normalProgressV = normalP;
    self.timelineProgressV = timelineP;
    
    [self.normalProgressV changeTimeLabel:0 audioLength:200];
    [self.timelineProgressV changeTimeLabel:0 audioLength:150];
    
    UISlider *slide = [[UISlider alloc] initWithFrame:CGRectMake(10, 350, self.view.frame.size.width-20, 12)];
    [self.view addSubview:slide];
    [slide addTarget:self action:@selector(slideValueChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void)slideValueChanged:(UISlider *)slider {
    
    float value = slider.value;
    [self.normalProgressV changeTimeLabel:value audioLength:200];
    [self.timelineProgressV changeTimeLabel:value audioLength:150];
}

@end
