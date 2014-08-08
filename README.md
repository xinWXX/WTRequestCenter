WTRequestCenter
===============

方便缓存的请求库
无需任何import和配置，目前实现了基础需求
如果有其他需要请在issue 上提出，谢谢！


Convenient cache request library
no any import and Configuration,At present, the foundation needs to achieve is Finised
any question please write at issues ,thank you
使用方法 Usage
===============
#### 注意：所有的请求都是缓存的，POST提供非缓存方式的请求，详情请看Wiki
### GET 请求
```objective-c
[WTRequestCenter getWithURL:url
                 parameters:parameters
          completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
              id obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
              NSLog(@"result:%@",obj);
              }
```
              
### POST 请求
```objective-c
[WTRequestCenter postWithURL:url
                  parameters:parameters 
           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                     id obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
              NSLog(@"result:%@",obj);
               }
```

### 缓存图片
```objective-c
    NSURL *url = [NSURL URLWithString:@"http://www.xxx.com/eqdsa.jpg"];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [WTRequestCenter getImageWithURL:url imageComplectionHandler:^(UIImage *image) {
        imageView.image = image;
    }];
```

### 取消所有请求
```objective-c
[WTRequestCenter cancelAllRequest];
```

Requirement  
===============
Only need iOS 5.0 and later,no more!

需要
===============
仅仅需要iOS5 ！ 不需要其他任何import和配置
