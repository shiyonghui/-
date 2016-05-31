//
//  DrawView.h
//  画板
//
//  Created by 施永辉 on 16/5/30.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawView : UIView

@property (nonatomic,assign)NSInteger lineWidth;

@property (nonatomic,strong)UIColor * pathColor;

@property (nonatomic,strong)UIImage * image;
//清屏
- (void)clear;
//撤销
- (void)undo;
@end
