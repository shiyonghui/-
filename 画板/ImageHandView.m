//
//  ImageHandView.m
//  画板
//
//  Created by 施永辉 on 16/5/30.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "ImageHandView.h"

@interface ImageHandView ()<UIGestureRecognizerDelegate>

@property (nonatomic,weak)UIImageView * imageV;
@end
@implementation ImageHandView


//防止事件往上传递
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    return self.imageV;
}
- (UIImageView *)imageV
{
    if (_imageV == nil) {
        UIImageView * imageV = [[UIImageView alloc]initWithFrame:self.bounds];
        imageV.userInteractionEnabled = YES;
        _imageV = imageV;
        //添加手势
        [self setUpGestureRecognizer];
        
        [self addSubview:imageV];
        
        
        
    }
    return _imageV;
}
#pragma mark 设置手势
- (void)setUpGestureRecognizer
{
    //平移
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    [_imageV addGestureRecognizer:pan];
    //旋转
    UIRotationGestureRecognizer * rotation = [[UIRotationGestureRecognizer alloc]initWithTarget:self action:@selector(rotation:)];
    rotation.delegate = self;
    [_imageV addGestureRecognizer:rotation];
    //缩放
    UIPinchGestureRecognizer * pinch = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinch:)];
    pinch.delegate = self;
    [_imageV addGestureRecognizer:pinch];
    //长按
    UILongPressGestureRecognizer * longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
    [_imageV addGestureRecognizer:longPress];
}
- (void)pan:(UIPanGestureRecognizer *)pan
{
    //获取手指的偏移量
   CGPoint transP = [pan translationInView:self.imageV];
    //设置UIImageView的形变
    self.imageV.transform = CGAffineTransformTranslate(self.imageV.transform, transP.x, transP.y);
    //复位 ： 只要想要相对于上一次就必须复位
    [pan setTranslation:CGPointZero inView:self.imageV];
}
- (void)rotation:(UIRotationGestureRecognizer *)rotation
{
    self.imageV.transform = CGAffineTransformRotate(self.imageV.transform,rotation.rotation);
    rotation.rotation = 0;
    
}
- (void)pinch:(UIPinchGestureRecognizer *)pinch
{
    self.imageV.transform = CGAffineTransformScale(self.imageV.transform,pinch.scale, pinch.scale);
    pinch.scale = 1;
}
- (void)longPress:(UILongPressGestureRecognizer *)longPress
{
    if(longPress.state == UIGestureRecognizerStateBegan)
    {
        //图片处理完毕
        
        //高亮效果
        [UIView animateWithDuration:0.25 animations:^{
            self.imageV.alpha = 0;
        }completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.25 animations:^{
                self.imageV.alpha = 1;
                
            }completion:^(BOOL finished) {
                //高亮完成的时候
                
                //把处理的图片生成一张新的图片，截屏
                
                //开启位图上下文
                UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);
                //获取位图上下文
                CGContextRef ctx = UIGraphicsGetCurrentContext();
                //把控件的图片渲染到上下文
                [self.layer renderInContext:ctx];
                //获取图片
                UIImage * image  =UIGraphicsGetImageFromCurrentImageContext();
                
                //关闭上下文
                UIGraphicsEndImageContext();
                //调用Block
                if (_handleCompletionBlock) {
                    _handleCompletionBlock(image);
                }
                //移除父控件
                [self removeFromSuperview];
            }];
        }];
    }
}
- (void)setImage:(UIImage *)image
{
    _image = image;
    //展示UIimageView
    self.imageV.image = image;
    
}
#pragma mark  手势代理方法
//是否支持多个手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(nonnull UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
@end
