//
//  ViewController.m
//  LTVideoTool
//
//  Created by houlin on 2020/7/22.
//  Copyright © 2020 houlin. All rights reserved.
//

#import "ViewController.h"
#import <TZImagePickerController/TZImagePickerController.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *btnOpenPhoto = [UIButton new];
    btnOpenPhoto.frame = CGRectMake(100, 100, 60, 40);
    [btnOpenPhoto setTitle:@"Open" forState:UIControlStateNormal];
    [btnOpenPhoto addTarget:self action:@selector(openPhoto) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btnOpenPhoto];
}

- (void)openPhoto {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:nil];

    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}



@end
