//
//  SFImageVIew.m
//  ImageLoad
//
//  Created by v on 16/4/13.
//  Copyright © 2016年 v. All rights reserved.
//
#import "SFImageVIew.h"
#import <ImageIO/ImageIO.h>
#import <CoreFoundation/CoreFoundation.h>

@interface SFImageVIew ()<NSURLConnectionDelegate>


@end

@implementation SFImageVIew
{
    NSURLRequest    *_request;
    NSURLConnection *_conn;
    
    CGImageSourceRef _incrementallyImgSource;
    
    NSMutableData   *_recieveData;
    long long       _expectedLeght;
    bool            _isLoadFinished;
}

- (void)setImageUrlString:(NSString *)imageUrlString
{
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:imageUrlString]];
    NSURLConnection *connect = [[NSURLConnection alloc]initWithRequest:request delegate:self];;
    
        _incrementallyImgSource = CGImageSourceCreateIncremental(NULL);
        _recieveData = [[NSMutableData alloc] init];
        _isLoadFinished = false;
   
}

- (void)dealloc
{
   
    CFRelease(_incrementallyImgSource);
    _incrementallyImgSource = NULL;
 
}

#pragma mark NSURLConnectionDataDelegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    _expectedLeght = response.expectedContentLength;

    
    NSString *mimeType = response.MIMEType;
   
    
    NSArray *arr = [mimeType componentsSeparatedByString:@"/"];
    if (arr.count < 1 || ![[arr objectAtIndex:0] isEqual:@"image"]) {
        NSLog(@"not a image url");
        [connection cancel];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Connection %@ error, error info: %@", connection, error);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"Connection Loading Finished!!!");
    if (!_isLoadFinished) {
        CGImageSourceUpdateData(_incrementallyImgSource, (CFDataRef)_recieveData, _isLoadFinished);
        CGImageRef imageRef = CGImageSourceCreateImageAtIndex(_incrementallyImgSource, 0, NULL);
        self.image = [UIImage imageWithCGImage:imageRef];
        CGImageRelease(imageRef);
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_recieveData appendData:data];
    
    _isLoadFinished = false;
    if (_expectedLeght == _recieveData.length) {
        _isLoadFinished = true;
    }
    
    CGImageSourceUpdateData(_incrementallyImgSource, (CFDataRef)_recieveData, _isLoadFinished);
    CGImageRef imageRef = CGImageSourceCreateImageAtIndex(_incrementallyImgSource, 0, NULL);
    self.image = [UIImage imageWithCGImage:imageRef];
    
    CGImageRelease(imageRef);
}

@end


