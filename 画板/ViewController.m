//
//  ViewController.m
//  画板
//
//  Created by 施永辉 on 16/5/30.
//  Copyright © 2016年 mac. All rights reserved.
//
#import "DrawView.h"
#import "ViewController.h"
#import "ImageHandView.h"
@interface ViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet DrawView *DrawView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
#pragma mark 清屏
- (IBAction)clear:(id)sender {
    [_DrawView clear];
}
#pragma mark 撤销
- (IBAction)undo:(id)sender {
    [_DrawView undo];
}
#pragma mark 橡皮擦
- (IBAction)eraser:(id)sender {
    _DrawView.pathColor = [UIColor whiteColor];
}
#pragma mark 相册
- (IBAction)pickerPhoto:(id)sender {
    //弹出系统的相册
    UIImagePickerController * picker = [[UIImagePickerController alloc]init];
    //设置选择控制器的来源
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
    
}

#pragma mark    <UIImagePickerControllerDelegate>
//当用户选择一张图片的时候调用
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    //获取选中的照片
    UIImage * image = info[UIImagePickerControllerOriginalImage];
    //创建一个图片处理的View
    ImageHandView * imageHandV = [[ImageHandView alloc]initWithFrame:self.DrawView.bounds];
    
    imageHandV.handleCompletionBlock = ^(UIImage * image){
        self.DrawView.image = image;
    };
    
    [self.DrawView addSubview:imageHandV];
    //做图片处理
    imageHandV.image = image;
    //把选中的照片画到画板上
//    _DrawView.image = image;
    //dismiss
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark 保存
- (IBAction)save:(id)sender {
    
    //截屏
    //开启上下文
    UIGraphicsBeginImageContextWithOptions(_DrawView.bounds.size, NO, 0);
    //获取上下文
  CGContextRef ctx = UIGraphicsGetCurrentContext();
    //渲染图层
    [_DrawView.layer renderInContext:ctx];
    //获取上下文中的图片
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    //关闭上下文
    UIGraphicsEndPDFContext();
    //保存画板内容放入相册
    //image: 写入的图片
    //completionTarget图片保存的监听者
    //注意： 以后写入相册方法中，想要监听图片有没有保存完成 保存完成的方法不能随意乱写
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contexInfo:), nil);
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contexInfo:(void *)contexInfo
{
    NSLog(@"保存成功");
}

- (IBAction)valueChange:(UISlider *)sender {
    //给画板传递
    _DrawView.lineWidth = sender.value;
}
- (IBAction)colorChange:(UIButton *)sender {
    //给画板传递颜色
    _DrawView.pathColor = sender.backgroundColor;
}

@end
