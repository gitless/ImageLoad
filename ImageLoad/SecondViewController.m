//
//  SecondViewController.m
//  ImageLoad
//
//  Created by v on 16/4/13.
//  Copyright © 2016年 v. All rights reserved.
//

#import "SecondViewController.h"
#import "SFImageVIew.h"

#define imgUrl @"http://dl.bizhi.sogou.com/images/2013/11/13/407154.jpg?f=download"
@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    利用NSURLSection
    self.view.backgroundColor =[UIColor whiteColor];
    SFImageVIew *sfImageView = [[SFImageVIew alloc]initWithFrame:self.view.bounds];
    sfImageView.contentMode = UIViewContentModeScaleAspectFit;
    sfImageView.imageUrlString = imgUrl;
    [self.view addSubview:sfImageView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
