//
//  MTURLBuilder.m
//  MTURLBuilder
//
//  Created by mini-titan on 2015/02/24.
//  Copyright (c) 2015 mini-ttian. All rights reserved.
//

#import "MTURLBuilder.h"

@implementation MTURLBuilder

- (instancetype)init
{
    self = [super init];
    if (self) {
        _queries = [[NSMutableArray alloc] init];
    }
    return self;
}

+ (MTURLBuilder *)parse:(NSString *)urlString
{
    MTURLBuilder *urlBuilder = [[MTURLBuilder alloc] init];
    NSURL *nsUrl = [NSURL URLWithString:urlString];

    urlBuilder.scheme = nsUrl.scheme;
    urlBuilder.host = nsUrl.host;
    urlBuilder.port = nsUrl.port;
    urlBuilder.path = nsUrl.path;
    for (NSArray *query in [MTURLBuilder parseQueries : nsUrl.query]) {
        [urlBuilder addQuery:query[1] forKey:query[0]];
    }
    urlBuilder.fragment = nsUrl.fragment;
    return urlBuilder;
}

- (NSURL *)build
{
    NSMutableArray *urlArray = [[NSMutableArray alloc] init];

    if (_scheme) {
        [urlArray addObject:_scheme];
    } else {
        [urlArray addObject:@"http"];
    }
    [urlArray addObject:@"://"];
    if (_host) {
        [urlArray addObject:_host];
    }
    if (_port) {
        [urlArray addObject:@":"];
        [urlArray addObject:_port];
    }
    if (_path) {
        [urlArray addObject:_path];
    }
    if (_queries) {
        NSString *queryString = [MTURLBuilder buildQueries:_queries];
        if (queryString && queryString.length > 0) {
            [urlArray addObject:@"?"];
            [urlArray addObject:queryString];
        }
    }
    if (_fragment) {
        [urlArray addObject:@"#"];
        [urlArray addObject:_fragment];
    }

    return [NSURL URLWithString:[urlArray componentsJoinedByString:@""]];
}

- (void)addQuery:(NSString *)value forKey:(NSString *)key
{
    [_queries addObject:@[key, value]];
}

+ (NSMutableArray *)parseQueries:(NSString *)queryString
{
    NSMutableArray *parsedQueries = [[NSMutableArray alloc] init];

    if (!queryString || queryString.length == 0) {
        return parsedQueries;
    }

    NSArray *pairQueries = [queryString componentsSeparatedByString:@"&"];

    for (NSString *pairQuery in pairQueries) {
        NSArray *keyVal = [self parsePairQuery:pairQuery];
        if (keyVal) {
            [parsedQueries addObject:@[keyVal[0], keyVal[1]]];
        }
    }
    return parsedQueries;
}

+ (NSDictionary *)parseUniqueQueries:(NSString *)queryString
{
    NSMutableDictionary *parsedQueries = [[NSMutableDictionary alloc] init];

    if (!queryString || queryString.length == 0) {
        return parsedQueries;
    }

    NSArray *pairQueries = [queryString componentsSeparatedByString:@"&"];

    for (NSString *pairQuery in pairQueries) {
        NSArray *keyVal = [self parsePairQuery:pairQuery];
        if (keyVal) {
            parsedQueries[keyVal[0]] = keyVal[1];
        }
    }

    return parsedQueries;
}

+ (NSString *)buildQueries:(NSArray *)queries
{
    if (!queries || queries.count == 0) {
        return @"";
    }

    NSMutableArray *queryStrings = [[NSMutableArray alloc] init];

    for (NSArray *pairQuery in queries) {
        NSString *queryString = [self toPairQuery:pairQuery];
        if (queryString != nil) {
            [queryStrings addObject:queryString];
        }
    }

    return [queryStrings componentsJoinedByString:@"&"];
}

+ (NSString *)buildQueriesWithDictionary:(NSDictionary *)queries
{
    NSMutableArray *arrayQueries = [[NSMutableArray alloc] init];

    if (!queries || queries.count == 0) {
        return @"";
    }

    for (NSString *key in queries.allKeys) {
        [arrayQueries addObject:@[key, queries[key]]];
    }
    return [self buildQueries:arrayQueries];
}

+ (NSString *)encodeURIComponent:(NSString *)str
{
    if (!str) {
        return str;
    }

    NSString *escapedString = (NSString *)CFBridgingRelease(
            CFURLCreateStringByAddingPercentEscapes(
                NULL,
                (__bridge CFStringRef)str,
                NULL,
                CFSTR(";:@&=+$,/?%#[]"),
                kCFStringEncodingUTF8
                )
            );

    return escapedString;
}

+ (NSString *)decodeURIComponent:(NSString *)str
{
    if (!str) {
        return str;
    }

    return [str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

// ------------------------------------------------------------------------------
#pragma mark - private methods
// ------------------------------------------------------------------------------

//
+ (NSArray *)parsePairQuery:(NSString *)pairQuery
{
    NSArray *keyVal = [pairQuery componentsSeparatedByString:@"="];

    if (!keyVal || keyVal.count < 2) {
        return nil;
    }
    return @[
        [self decodeURIComponent:keyVal[0]],
        [self decodeURIComponent:keyVal[1]]
    ];
}

+ (NSString *)toPairQuery:(NSArray *)pairQueryArray
{
    if (!pairQueryArray || pairQueryArray.count < 2) {
        return nil;
    }

    NSString *key = [self getStringValue:pairQueryArray[0]];
    NSString *value = [self getStringValue:pairQueryArray[1]];

    return [NSString stringWithFormat:@"%@=%@",
            [MTURLBuilder encodeURIComponent:key],
            [MTURLBuilder encodeURIComponent:value]];
}

+ (NSString *)getStringValue:(id)object
{
    if ([object isKindOfClass:[NSNull class]]) {
        return @"";
    } else {
        return [NSString stringWithFormat:@"%@", object];
    }
}

@end
