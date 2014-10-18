//
//  UIButton+WTImageCache.m
//  WTRequestCenter
//
//  Created by songwt on 14-7-30.
//  Copyright (c) 2014年 song. All rights reserved.
//



#import "UIButton+WTRequestCenter.h"
#import "WTRequestCenter.h"
#import "WTRequestCenterMacro.h"
#import "UIKit+WTRequestCenter.h"
#import <objc/runtime.h>
@implementation UIButton (WTImageCache)

-(WTURLRequestOperation*)wtImageRequestOperation
{
    WTURLRequestOperation *operation = (WTURLRequestOperation*)objc_getAssociatedObject(self, @"a");
    return operation;
}

-(void)setWtImageRequestOperation:(WTURLRequestOperation *)wtImageRequestOperation
{
    objc_setAssociatedObject(self, @"a", wtImageRequestOperation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (void)setImageForState:(UIControlState)state
                 withURL:(NSString *)url
{
    [self setImageForState:state withURL:url placeholderImage:nil];
}
- (void)setImageForState:(UIControlState)state
                 withURL:(NSString *)url
        placeholderImage:(UIImage *)placeholderImage
{
    [self setImage:placeholderImage forState:state];
    
    if (self.wtImageRequestOperation) {
        [self.wtImageRequestOperation cancel];
        self.wtImageRequestOperation = nil;
    }
    
    if (!url) {
        return;
    }
    __weak UIButton *weakSelf = self;
    

    WTURLRequestOperation *operation = [WTRequestCenter testGetWithURL:url parameters:nil option:WTRequestCenterCachePolicyCacheElseWeb finished:^(NSURLResponse *respnse, NSData *data) {
        [[WTRequestCenter sharedQueue] addOperationWithBlock:^{
            UIImage *image = [UIImage imageWithData:data];
            
            if (image) {
                if (!weakSelf) return;
                __strong UIButton *strongSelf = weakSelf;
                
                dispatch_async(dispatch_get_main_queue(), ^{
//                    strongSelf.image = image;
                    [strongSelf setImage:image forState:state];
                    [strongSelf setNeedsDisplay];
                    
                });
                strongSelf.wtImageRequestOperation = nil;
            }
        }];
        
    } failed:^(NSURLResponse *response, NSError *error) {
        NSLog(@"%@",error);
//        if (!weakSelf) return;
//        __strong UIImageView *strongSelf = weakSelf;
//        strongSelf.wtImageRequestOperation = nil;
    }];
    
    self.wtImageRequestOperation = operation;

}

- (void)setBackgroundImage:(UIControlState)state
                   withURL:(NSString *)url
{
    [self setBackgroundImage:state withURL:url placeholderImage:nil];
}

- (void)setBackgroundImage:(UIControlState)state
                 withURL:(NSString *)url
        placeholderImage:(UIImage *)placeholderImage
{
    [self setBackgroundImage:placeholderImage forState:state];
    
    if (!url) {
        return;
    }
    __weak UIButton *weakSelf = self;
    
    
    [WTRequestCenter getCacheWithURL:url parameters:nil finished:^(NSURLResponse *response, NSData *data) {
        if (data) {
            [[WTRequestCenter sharedQueue] addOperationWithBlock:^{
                UIImage *image = [UIImage imageWithData:data];
                if (image) {
                    
                    if (weakSelf) {
                        __strong UIButton *strongSelf = weakSelf;
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [strongSelf setBackgroundImage:image forState:state];
                            [strongSelf setNeedsLayout];
                        });
                    }
                }
            }];
        }
    } failed:^(NSURLResponse *response, NSError *error) {
        
    }];
}


@end
