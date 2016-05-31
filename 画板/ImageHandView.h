//
//  ImageHandView.h
//  画板
//
//  Created by 施永辉 on 16/5/30.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageHandView : UIView
@property (nonatomic,strong) UIImage * image;
@property (nonatomic,strong) void(^handleCompletionBlock)(UIImage * image);
@end
