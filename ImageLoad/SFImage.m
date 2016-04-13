
//
//  SFImage.m
//  ImageLoad
//
//  Created by v on 16/4/13.
//  Copyright © 2016年 v. All rights reserved.
//

#import "SFImage.h"
#import <ImageIO/ImageIO.h>
@interface SFImage ()<NSURLSessionDelegate,NSURLSessionTaskDelegate,NSURLSessionDataDelegate>
/**
 *  数据总长度
 */
@property (nonatomic,assign)int64_t countOfBytesHasReceived;
/**
 *  图像源
 */
@property (nonatomic,assign)CGImageSourceRef incrementImgSource;
/**
 *  收到的NSData
 */
@property (nonatomic,strong)NSMutableData *appendData;
@property (nonatomic,strong)NSURLSession *mySession;
@end

@implementation SFImage
- (NSURLSession *)mySession{
    if (!_mySession) {
        /*一般模式（default）：工作模式类似于原来的NSURLConnection，可以使用缓存的Cache，Cookie，鉴权。
         及时模式（ephemeral）：不使用缓存的Cache，Cookie，鉴权。
         后台模式（background）：在后台完成上传下载，创建Configuration对象的时候需要给一个NSString的ID用****/
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _mySession = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    }
    return _mySession;
}
-(void)setImageUrlString:(NSString *)imageUrlString{

        _countOfBytesHasReceived = 0;
        _appendData = [[NSMutableData  alloc]init];
        _incrementImgSource = CGImageSourceCreateIncremental(NULL);
        
        NSURLSessionDataTask *task = [self.mySession dataTaskWithURL:[NSURL URLWithString:imageUrlString]];
        [task resume];
    
}

#pragma mark --  NSURLSessionDataDelegate

-(void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data{
    
    
    NSString *mimeType = dataTask.response.MIMEType;
    NSLog(@"MIME TYPE %@", mimeType);
    
    NSArray *arr = [mimeType componentsSeparatedByString:@"/"];
    if (arr.count < 1 || ![[arr objectAtIndex:0] isEqual:@"image"]) {
        NSLog(@"not a image url");
        [dataTask cancel];
        
    }
//    判断数据是否接受完毕
    bool isFinish = dataTask.countOfBytesReceived == dataTask.countOfBytesExpectedToReceive ? true :false;
    [_appendData appendData:data];
    CGImageSourceUpdateData(_incrementImgSource, (CFDataRef)_appendData, isFinish);
    CGImageRef ref = CGImageSourceCreateImageAtIndex(_incrementImgSource, 0, NULL);
    self.image = [UIImage imageWithCGImage:ref];
 
//        C_TYPE 类型在ARC下也需要释放
        CGImageRelease(ref);
    
}

#pragma mark -- NSURLSessionTaskDelegate
-(void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error{
//    退出会话  防止循环引用
    [self.mySession invalidateAndCancel];
    self.mySession = nil;
    NSLog(@"%@",error.localizedDescription);
}
- (void)dealloc
{
    CFRelease(_incrementImgSource);
    _incrementImgSource  = NULL;
}
@end
