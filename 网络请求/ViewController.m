//
//  ViewController.m
//  网络请求
//
//  Created by 张海禄 on 16/3/23.
//  Copyright © 2016年 张海禄. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "UIKit+AFNetworking.h"



@interface ViewController ()
@property(nonatomic,strong) NSDictionary * weatherdict;
@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    NSString * url = @"http://c.hiphotos.baidu.com/album/w=2048/sign=1d7ca85bac345982c58ae29238cc30ad/f2deb48f8c5494ee7abe33362cf5e0fe99257e04.jpg";
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
      imageView.contentMode=UIViewContentModeCenter;
       //setImageWithURL 为UIKit+AFNetworking里的方法，加载网络图片
    [imageView setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"tupian"]];
    
    [self.view addSubview:imageView];
   
    
    
    // 请求的manager
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    NSString *httpUrl = @"https://api.heweather.com/x3/weather?cityid=CN101021300&key=52b02864d3a141a08c18543045453977";
    NSString *httpurl1=@"http://apis.baidu.com/heweather/weather/free?city=fuzhou";
    //请求报文的头文件需要的apikey
    [session.requestSerializer setValue:@"您自己的api" forHTTPHeaderField:@"apikey"];
    [session GET:httpurl1 parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject){
        //  转成JSON字符串便于查询
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        //NSDictionary *jsondic=[NSJSONSerialization JSONObjectWithData:responseObject  options:NSJSONReadingMutableContainers  error:nil];
        NSString *result = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        //转成字典
        NSArray *array=[responseObject objectForKey:@"HeWeather data service 3.0"];
       _weatherdict=[array objectAtIndex:0];
        NSArray *keys=[_weatherdict allKeys];

        NSString *status=[_weatherdict objectForKey:@"status"];
        if([status isEqualToString:@"ok"]){
            //空气质量指数
            NSDictionary *aqi=[_weatherdict objectForKey:@"aqi"];
            NSDictionary *cityofaqi=[aqi objectForKey:@"city"];
            
            NSDictionary *basic=[_weatherdict objectForKey:@"basic"];
            NSArray *daily_forecast=[_weatherdict objectForKey:@"daily_forecast"];
            NSArray *hourly_forecast=[_weatherdict objectForKey:@"hourly_forecast"];
            NSDictionary *now=[_weatherdict objectForKey:@"now"];
            NSDictionary *suggestion=[_weatherdict objectForKey:@"suggestion"];
          // NSLog(@"JSON:%@",cityofaqi[@"qlty"]);
        }else{
        
            NSLog(@"错误代码：%@",status);
        
        }
        
        
        
        
        
        
        //将url中中文部分转成编码
        //        NSString *string=@"http://北京.com";
        //        NSString *string2=[string stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        //        NSLog(@"%@",string2);
        
        
    } failure:^(NSURLSessionTask *task, NSError *error) {
        
        NSLog(@"Error: %@", error);
    }];
    
    [self downLoad];
}



//下载方法

- (void)downLoad {
    
    //1.创建管理者对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //2.确定请求的URL地址
    NSURL *url = [NSURL URLWithString:@"http://c.hiphotos.baidu.com/album/w=2048/sign=1d7ca85bac345982c58ae29238cc30ad/f2deb48f8c5494ee7abe33362cf5e0fe99257e04.jpg"];
    
    //3.创建请求对象
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //下载任务
    NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        //打印下下载进度
        NSLog(@"%lf",1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        //下载地址
        NSLog(@"默认下载地址:%@",targetPath);
        
        //设置下载路径，通过沙盒获取缓存地址，最后返回NSURL对象
        NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
         NSLog(@"下载文件%@",filePath);
        return [NSURL URLWithString:filePath];
       

        
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        //下载完成调用的方法
        NSLog(@"下载完成：");
       NSLog(@"%@--%@",response,filePath);
        
    }];
    
    //开始启动任务
    [task resume];
   
 
    
    
}





-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
