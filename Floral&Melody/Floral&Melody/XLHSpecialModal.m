//
//  XLHSpecialModal.m
//  Floral&Melody
//
//  Created by lanou on 16/5/5.
//  Copyright © 2016年 西兰花. All rights reserved.
//

#import "XLHSpecialModal.h"

@implementation XLHSpecialModal

- (NSString *)getType:(NSString *)type
{
    NSString * str = @"[1]";
    str = [str stringByReplacingOccurrencesOfString:@"1" withString:type];
    return str;
}

- (NSString *)getTime:(NSString *)time
{
    NSString * str = [time substringWithRange:NSMakeRange(5, 5)];
    NSInteger month = [[str substringWithRange:NSMakeRange(0, 2)] integerValue];
    NSString * day = [str substringWithRange:NSMakeRange(3, 2)];
    NSString * monthText;
    switch (month) {
        case 1:
            monthText = @"Jan";
            break;
        case 2:
            monthText = @"Feb";
            break;
        case 3:
            monthText = @"Mar";
            break;
        case 4:
            monthText = @"Apr";
            break;
        case 5:
            monthText = @"May";
            break;
        case 6:
            monthText = @"Jun";
            break;
        case 7:
            monthText = @"Jul";
            break;
        case 8:
            monthText = @"Aug";
            break;
        case 9:
            monthText = @"Sep";
            break;
        case 10:
            monthText = @"Oct";
            break;
        case 11:
            monthText = @"Nov";
            break;
        case 12:
            monthText = @"Dec";
            break;
        default:
            break;
    }

    
//    NSString * result = @"- may.04 -";
    
//    result = [result stringByReplacingOccurrencesOfString:@"may" withString:monthText];
//    result = [result stringByReplacingOccurrencesOfString:@"04" withString:day];
    
    NSString * result = [[monthText stringByAppendingString:@" - "] stringByAppendingString:day];
    
    return result;
}
@end
