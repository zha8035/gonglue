//
//  YYUtil.m
//  mocha
//
//  Created by hony on 13-4-18.
//  Copyright (c) 2013年 yunyao. All rights reserved.
//
//比较版本的，不错
#define SYSTEM_VERSION_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#import "YYUtil.h"
#import <CommonCrypto/CommonDigest.h>
#import "Reachability.h"
#import "SDWebImageManager.h"
#import <AVFoundation/AVFoundation.h>

static NSDateFormatter *jsonHttpParamFormatter = nil;
static NSDateFormatter *dayFormatter = nil;
static AVAudioPlayer *mochabillPlayer = nil;

@implementation YYUtil

+(BOOL)isIphone5{
    return [UIScreen mainScreen].scale == 2.f && [UIScreen mainScreen].bounds.size.height == 568.0f;
}

+(BOOL)stringIsEmpty:(NSString *)string{
    if(string == nil || [string isEqualToString:@""]){
        return YES;
    }
    return NO;
}
+(CGFloat)adjustStatusBarHeightForiOS7{
    if([self isIOS7]){
        return 20;
    }
    return 0;
}
+(NSString *)json2String:(NSDictionary *)json{
    NSData *data = [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingPrettyPrinted error:nil];
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return string;
}

+(NSDictionary *)string2Json:(NSString *)stringJson{
    if(stringJson == nil || [stringJson isEqualToString:@""]){
        return nil;
    }
    NSData* data = [stringJson dataUsingEncoding:NSUTF8StringEncoding];
    return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
}


+(NSDate *)generateDay:(NSUInteger)day{
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval newTimeInterval = now - (day * 24 * 60 * 60);
    return [NSDate dateWithTimeIntervalSince1970:newTimeInterval];
}

+(NSString *)timeFormat:(NSDate *)date{
    if(dayFormatter == nil){
        dayFormatter = [[NSDateFormatter alloc] init];
        [dayFormatter setTimeZone:[NSTimeZone localTimeZone]];
        [dayFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dayFormatter setTimeStyle:NSDateFormatterMediumStyle];
        [dayFormatter setDateFormat:@"yyyy.MM.dd"];
    }
	return [dayFormatter stringFromDate:date];
}
+(NSDate *)dateFromJsonString:(NSString *)jsonStr{
    if(jsonHttpParamFormatter == nil){
        jsonHttpParamFormatter = [[NSDateFormatter alloc] init];
        [jsonHttpParamFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    return [jsonHttpParamFormatter dateFromString:jsonStr];
}

+(NSString *)stringDateForJson:(NSDate *)date{
    if(jsonHttpParamFormatter == nil){
        jsonHttpParamFormatter = [[NSDateFormatter alloc] init];
        [jsonHttpParamFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    return [jsonHttpParamFormatter stringFromDate:date];
}

+(NSString *)uppercaseLettersFromIndex:(NSUInteger)index{
    char c = (char)(65+index);
    return [NSString stringWithFormat:@"%c",c];
}



+(BOOL)isEnLetter:(unichar)c{
    return (c >= 65 && c <= 90) || (c >= 97 && c <= 122);
}

+(BOOL)timeInterval:(NSString *)key withTime:(NSUInteger)seconds{
    NSDate *date = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if(date){
        NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:date];
        if(interval < seconds){
            return NO;
        }
    }
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return YES;
}

+(BOOL)everyDayFirstExecute:(NSString *)key{
    NSDate *date = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    if(date){
        NSString *oldDay = [self timeFormat:date];
        NSString *nowDay = [self timeFormat:[NSDate date]];
        if([oldDay isEqualToString:nowDay]){
            return NO;
        }
    }
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return YES;
}


+(NSUInteger)string2UInteger:(id)value{
    int count = [value intValue];
    if(count < 0){
        count = 0;
    }
    return count;
}

+(BOOL)checkBarcode:(NSString *)barcode{
    if([YYUtil stringIsEmpty:barcode]){
        return NO;
    }
    if(barcode.length != 8 && barcode.length != 12 && barcode.length != 13){
        return NO;
    }
    NSString *prefix = [barcode substringToIndex:barcode.length-1];
    NSString *newBarcode = [self generateEANLast:prefix];
    return [barcode isEqualToString:newBarcode];
}

+(NSString *)generateEANLast:(NSString *)prefix{
    int c1 = 0;
    int c2 = 0;
    for (int i = 0; i < prefix.length && (i+1) < prefix.length; i += 2) {
        c1 += ([prefix characterAtIndex:i] - '0');
        c2 += ([prefix characterAtIndex:i + 1] - '0');
    }
     int c = (c1 + c2 * 3) % 10;
     int cc = (10 - c) % 10;
    return [prefix stringByAppendingFormat:@"%d",cc];
}

+(UIImage *)imageFromDiskCacheForUrl:(NSString *)url{
    NSString *key = [[SDWebImageManager sharedManager] cacheKeyForURL:[NSURL URLWithString:url]];
    UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:key];
    return image;
}


+(int)compareVersion:(NSString *)ver1 withOther:(NSString *)ver2{
    if([ver1 isEqualToString:ver2]){
        return 0;
    }
    ver1 = [ver1 stringByReplacingOccurrencesOfString:@"." withString:@""];
    ver2 = [ver2 stringByReplacingOccurrencesOfString:@"." withString:@""];
    
    int iver1 = [ver1 intValue];
    int iver2 = [ver2 intValue];
    
    if(iver1 > iver2){
        return 1;
    }else{
        return -1;
    }
}

+(BOOL)isWifi{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    
    NetworkStatus status = [reachability currentReachabilityStatus];
    
    if (status == ReachableViaWiFi){
        return YES;
    }
    return NO;
}


+(BOOL)isIOS6{
    if([self isIOS5] || [self isIOS7]){
        return NO;
    }
    return YES;
}

+(BOOL)isGreaterThanIOS6{
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6")){
        return YES;
    }
    return NO;
}

+(BOOL)isIOS7{
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7")){
        return YES;
    }
    return NO;
}

+(BOOL)isIOS5{
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6")){
        return NO;
    }
    return YES;
}


//+(NSString *)dateIntelligentFormat:(NSDate *)date{
//     NSUInteger interval = fabs([date timeIntervalSinceNow]);
//    if(interval < 60){
//        return @"刚刚";
//    }else if(interval < 60*60){
//        return [NSString stringWithFormat:@"%d分钟前",interval/60];
//    }else if(interval < 24*60*60){
//        return [NSString stringWithFormat:@"%d小时前",interval/60/60];
//    }else if(interval < 30*24*60*60){
//        return [NSString stringWithFormat:@"%d天前",interval/24/60/60];
//    }else if(interval < 12*30*24*60*60){
//        return [NSString stringWithFormat:@"%d月前",interval/30/24/60/60];
//    }else{
//        return [NSString stringWithFormat:@"%d年前",interval/12/30/24/60/60];
//    }
//}
//判断是不是数字
+(BOOL)isPureInt:(NSString *)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

+(void)playMochabillSound{
    if(mochabillPlayer == nil){
        NSString *path = [[NSBundle mainBundle] pathForResource:@"mochabill" ofType:@"mp3"];
        NSError *error = nil;
        mochabillPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:&error];
        mochabillPlayer.volume = 1;
        if (error) {
            NSLog(@"mochabill.mp3 play error:%@",error);
        }
    }
    [mochabillPlayer play];
}

@end
