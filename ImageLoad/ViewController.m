//
//  ViewController.m
//  ImageLoad
//
//  Created by v on 16/4/13.
//  Copyright © 2016年 v. All rights reserved.
//

#import "ViewController.h"
#import "SFImage.h"
#import "SecondViewController.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet SFImage *myImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    利用NSURLSession
    _myImageView.imageUrlString= @"http://b.zol-img.com.cn/desk/bizhi/image/1/1920x1200/1348810232493.jpg";
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
