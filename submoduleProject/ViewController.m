//
//  ViewController.m
//  submoduleProject
//
//  Created by zhaohongbin on 2026/6/22.
//

#import "ViewController.h"
#import "ZHBCommonKit.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor greenColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"Say Hello" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.backgroundColor = [UIColor systemBlueColor];
    button.frame = CGRectMake(100, 100, 120, 44);
    button.layer.cornerRadius = 8;
    [button addTarget:self action:@selector(helloButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)helloButtonTapped {
    [ZHBCommonKit sayHello];
}


@end
