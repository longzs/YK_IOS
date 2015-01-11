//
//  MD5Util.h
//  
//
//  Created  on 11-8-18.
//  Copyright 2011 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h> 

/**
 *  MD5加密
 */
@interface MD5Util : NSObject {

}
/**
 *  对一个字符串进行MD5加密
 *
 *  @param str 原字符串
 *
 *  @return MD5后的字符串
 */
+ (NSString *) md5Encrypt:(NSString *)str;
/**
 *  对一个文件内容进行MD5加密
 *
 *  @param file 文件路径
 *
 *  @return MD5后的字符串
 */
+ (NSString *) md5ForFileContent:(NSString *)file;
/**
 *  对NSData的内容进行MD5加密
 *
 *  @param data 原数据
 *
 *  @return MD5后的字符串
 */
+ (NSString *) md5ForData:(NSData *)data;

@end
