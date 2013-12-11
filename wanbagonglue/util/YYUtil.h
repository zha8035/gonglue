//
//  YYUtil.h
//  mocha
//
//  Created by hony on 13-4-18.
//  Copyright (c) 2013年 yunyao. All rights reserved.
//

#define subjectsFetchSize 5

#import <Foundation/Foundation.h>

@interface YYUtil : NSObject


+(BOOL)isIphone5;
+(BOOL)stringIsEmpty:(NSString *)string;

//将NSDictionary转化为json字符串
+(NSString *)json2String:(NSDictionary *)json;
//将string转化为NSDictionary
+(NSDictionary *)string2Json:(NSString *)stringJson;



+(NSString *)timeFormat:(NSDate *)date;
//json中的date只是string，需要转化成真正的date对象
+(NSDate *)dateFromJsonString:(NSString *)jsonStr;
//作为json中的参数，需要转化为string
+(NSString *)stringDateForJson:(NSDate *)date;

//根据数字得到大写字母，A从0开始
+(NSString *)uppercaseLettersFromIndex:(NSUInteger)index;

//用来计时的工具类，比如某些需要24小时只能执行最多一次，但必须保证返回yes一定要执行
+(BOOL)timeInterval:(NSString *)key withTime:(NSUInteger)seconds;
//每天首次执行
+(BOOL)everyDayFirstExecute:(NSString *)key;

+(NSUInteger)string2UInteger:(id)value;
//校验barcode
+(BOOL)checkBarcode:(NSString *)barcode;
//从sdwebimage disk中取图片
+(UIImage *)imageFromDiskCacheForUrl:(NSString *)url;

//比较版本大小，格式必须都是1.0.0这种
+(int)compareVersion:(NSString *)ver1 withOther:(NSString *)ver2;

//检测是否在wifi条件下
+(BOOL)isWifi;



+(BOOL)isIOS5;

+(BOOL)isIOS6;

+(BOOL)isGreaterThanIOS6;

+(BOOL)isIOS7;

+(CGFloat)adjustStatusBarHeightForiOS7;





//判断是不是数字
+(BOOL)isPureInt:(NSString *)string;

+(void)playMochabillSound;

@end
