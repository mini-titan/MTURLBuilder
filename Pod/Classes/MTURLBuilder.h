//
//  MTURLBuilder.h
//  Pods
//
//  Created by mini titan on 2015/02/24.
//
//

#import <Foundation/Foundation.h>

@interface MTURLBuilder : NSObject

@property (nonatomic) NSString *scheme;
@property (nonatomic) NSString *host;
@property (nonatomic) NSNumber *port;
@property (nonatomic) NSString *path;
@property (nonatomic, readonly) NSMutableArray *queries;
@property (nonatomic) NSString *fragment;

+ (MTURLBuilder *)parse:(NSString *)urlString;
- (NSURL *)build;
- (void)addQuery:(NSString *)value withKey:(NSString *)key;

+ (NSMutableArray *)parseQueries:(NSString *)queryString;
+ (NSDictionary *)parseUniqueQueries:(NSString *)queryString;
+ (NSString *)buildQueries:(NSArray *)queries;
+ (NSString *)buildQueriesWithDictionary:(NSDictionary *)queries;

+ (NSString *)encodeURIComponent:(NSString *)str;
+ (NSString *)decodeURIComponent:(NSString *)str;

@end