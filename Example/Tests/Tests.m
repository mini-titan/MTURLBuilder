//
//  MTURLBuilderTests.m
//  MTURLBuilderTests
//
//  Created by mini-titan on 02/24/2015.
//  Copyright (c) 2014 mini-titan. All rights reserved.
//

SPEC_BEGIN(MTURLBuilderSpec)

describe(@"MTURLBuilder", ^{
             describe(@".parse", ^{
                          let(url, ^{ return @""; });
                          let(subject, ^{ return [MTURLBuilder parse:url]; });
                          context(@"with nil url", ^{
                                      it(@"", ^{
                                             [[subject.scheme should] beNil];
                                             [[subject.host should] beNil];
                                             [[subject.port should] beNil];
                                             [[subject.path should] beNil];
                                             [[@(subject.queries.count)should] equal:@0];
                                             [[subject.fragment should] beNil];
                                         });
                                  });
                          context(@"with empty url", ^{
                                      it(@"", ^{
                                             [[subject.scheme should] beNil];
                                             [[subject.host should] beNil];
                                             [[subject.port should] beNil];
                                             [[subject.path should] beNil];
                                             [[@(subject.queries.count)should] equal:@0];
                                             [[subject.fragment should] beNil];
                                         });
                                  });
                          context(@"with invalid url", ^{
                                      let(url, ^{ return @"invalid/url?key=value"; });
                                      it(@"", ^{
                                             [[subject.scheme should] beNil];
                                             [[subject.host should] beNil];
                                             [[subject.port should] beNil];
                                             [[subject.path should] equal:@"invalid/url"];
                                             [[@(subject.queries.count)should] equal:@1];
                                             [[subject.queries[0][0] should] equal:@"key"];
                                             [[subject.queries[0][1] should] equal:@"value"];
                                             [[subject.fragment should] beNil];
                                         });
                                  });
                          context(@"with valid url", ^{
                                      let(url, ^{ return @"http://example.com/path1/path2/?query2=val2&query1=val1#fragment1"; });
                                      it(@"", ^{
                                             [[subject.scheme should] equal:@"http"];
                                             [[subject.host should] equal:@"example.com"];
                                             [[subject.port should] beNil];
                                             [[subject.path should] equal:@"/path1/path2"];
                                             [[@(subject.queries.count)should] equal:@2];
                                             [[subject.queries[0][0] should] equal:@"query2"];
                                             [[subject.queries[0][1] should] equal:@"val2"];
                                             [[subject.queries[1][0] should] equal:@"query1"];
                                             [[subject.queries[1][1] should] equal:@"val1"];
                                             [[subject.fragment should] equal:@"fragment1"];
                                         });
                                  });
                          context(@"with valid url and invalid parameters", ^{
                                      let(url, ^{ return @"https://example.com:1234?invalid&empty="; });
                                      it(@"", ^{
                                             [[subject.scheme should] equal:@"https"];
                                             [[subject.host should] equal:@"example.com"];
                                             [[subject.port should] equal:@1234];
                                             [[subject.path should] equal:@""];
                                             [[@(subject.queries.count)should] equal:@1];
                                             [[subject.queries[0][0] should] equal:@"empty"];
                                             [[subject.queries[0][1] should] equal:@""];
                                             [[subject.fragment should] beNil];
                                         });
                                  });
                          context(@"with file url", ^{
                                      let(url, ^{ return @"file:///path/for/file?invalid&empty=#fragment"; });
                                      it(@"", ^{
                                             [[subject.scheme should] equal:@"file"];
                                             [[subject.host should] beNil];
                                             [[subject.port should] beNil];
                                             [[subject.path should] equal:@"/path/for/file"];
                                             [[@(subject.queries.count)should] equal:@1];
                                             [[subject.queries[0][0] should] equal:@"empty"];
                                             [[subject.queries[0][1] should] equal:@""];
                                             [[subject.fragment should] equal:@"fragment"];
                                         });
                                  });
                      });
             describe(@"#build", ^{
                          let(instance, ^{ return [[MTURLBuilder alloc] init]; });
                          let(subject, ^{ return instance.build.absoluteString; });
                          context(@"with empty", ^{
                                      it(@"", ^{
                                             [[subject should] equal:@"http://"];
                                         });
                                  });
                          context(@"with params", ^{
                                      let(subject, ^{
                                              instance.scheme = @"https";
                                              instance.host = @"test";
                                              instance.port = @8080;
                                              instance.path = @"/path";
                                              [instance addQuery:@"value" forKey:@"key"];
                                              instance.fragment = @"fragment";
                                              return instance.build.absoluteString;
                                          });
                                      it(@"", ^{
                                             [[subject should] equal:@"https://test:8080/path?key=value#fragment"];
                                         });
                                  });
                          context(@"with parsed url and params", ^{
                                      let(subject, ^{
                                              MTURLBuilder *builder = [MTURLBuilder parse:@"http://test2.com/path1/path2?a=b"];
                                              [builder addQuery:@"value2" forKey:@"key2"];
                                              builder.fragment = @"fragment";
                                              return builder.build.absoluteString;
                                          });
                                      it(@"", ^{
                                             [[subject should] equal:@"http://test2.com/path1/path2?a=b&key2=value2#fragment"];
                                         });
                                  });
                      });
             describe(@".parseQueries", ^{
                          let(query, ^{ return @""; });
                          let(subject, ^{ return [MTURLBuilder parseQueries:query]; });
                          context(@"with no query", ^{
                                      it(@"is no entry", ^{
                                             [[@(subject.count)should] equal:@0];
                                         });
                                  });
                          context(@"with invalid query", ^{
                                      let(query, ^{ return @"hoge#fuga&piyo&"; });
                                      it(@"is no entry", ^{
                                             [[@(subject.count)should] equal:@0];
                                         });
                                  });
                          context(@"with valid query", ^{
                                      let(query, ^{ return @"first=1st&second=%22%26'%3D%2F%3F&third%22%26'%3D%2F%3F=3rd&empty=&same=same1&same=same2&ignored"; });
                                      it(@"", ^{
                                             [[@(subject.count)should] equal:@6];
                                             [[subject[0][0] should] equal:@"first"];
                                             [[subject[0][1] should] equal:@"1st"];
                                             [[subject[1][0] should] equal:@"second"];
                                             [[subject[1][1] should] equal:@"\"&'=/?"];
                                             [[subject[2][0] should] equal:@"third\"&'=/?"];
                                             [[subject[2][1] should] equal:@"3rd"];
                                             [[subject[3][0] should] equal:@"empty"];
                                             [[subject[3][1] should] equal:@""];
                                             [[subject[4][0] should] equal:@"same"];
                                             [[subject[4][1] should] equal:@"same1"];
                                             [[subject[5][0] should] equal:@"same"];
                                             [[subject[5][1] should] equal:@"same2"];
                                         });
                                  });
                      });

             describe(@".parseUniqueQueries", ^{
                          let(query, ^{ return @"first=1st&second=%22%26'%3D%2F%3F&third%22%26'%3D%2F%3F=3rd&empty=&same=same1&same=same2&ignored"; });
                          let(subject, ^{ return [MTURLBuilder parseUniqueQueries:query]; });
                          context(@"with valid query", ^{
                                      it(@"", ^{
                                             [[@(subject.count)should] equal:@5];
                                             [[subject[@"first"] should] equal:@"1st"];
                                             [[subject[@"second"] should] equal:@"\"&'=/?"];
                                             [[subject[@"third\"&'=/?"] should] equal:@"3rd"];
                                             [[subject[@"empty"] should] equal:@""];
                                             [[subject[@"same"] should] equal:@"same2"];
                                         });
                                  });
                      });
             describe(@".buildQueries", ^{
                          let(queries, ^{ return @[]; });
                          let(subject, ^{ return [MTURLBuilder buildQueries:queries]; });
                          context(@"with invalid queries", ^{
                                      let(queries, ^{ return @[ @[@"first"], @[] ]; });
                                      it(@"", ^{ [[subject should] equal:@""]; });
                                  });
                          context(@"with nil queries", ^{
                                      let(queries, ^{ return (NSArray *)nil; });
                                      it(@"", ^{ [[subject should] equal:@""]; });
                                  });
                          context(@"", ^{
                                      let(queries, ^{
                                              return @[
                                                  @[@"first", @"1st"],
                                                  @[@"second", @"\"&'=/?"],
                                                  @[@"third\"&'=/?", @"3rd"],
                                                  @[@"empty", @""],
                                                  @[@"same", @"same1"],
                                                  @[@"same", @"same2"],
                                                  @[@"num", @(3)],
                                                  @[@"unknown", [NSDate dateWithTimeIntervalSince1970:0]],
                                                  @[@"null", [NSNull null]],
                                              ];
                                          });
                                      it(@"", ^{ [[subject should] equal:@"first=1st&second=%22%26'%3D%2F%3F&third%22%26'%3D%2F%3F=3rd&empty=&same=same1&same=same2&num=3&unknown=1970-01-01%2000%3A00%3A00%20%2B0000&null="]; });
                                  });
                      });
             describe(@".buildQueriesWithDictionary", ^{
                          let(queries, ^{ return @{}; });
                          let(subject, ^{ return [MTURLBuilder buildQueriesWithDictionary:queries]; });
                          context(@"with empty queries", ^{
                                      let(queries, ^{ return @{}; });
                                      it(@"", ^{ [[subject should] equal:@""]; });
                                  });
                          context(@"with nil queries", ^{
                                      let(queries, ^{ return (NSDictionary *)nil; });
                                      it(@"", ^{ [[subject should] equal:@""]; });
                                  });
                          context(@"", ^{
                                      let(queries, ^{ return @{ @"first": @"1st" }; });
                                      it(@"", ^{ [[subject should] equal:@"first=1st"]; });
                                  });
                      });
             describe(@".encodeURIComponent", ^{
                          let(query, ^{ return @""; });
                          let(subject, ^{ return [MTURLBuilder encodeURIComponent:query]; });
                          context(@"with empty query", ^{
                                      it(@"", ^{ [[subject should] equal:@""]; });
                                  });
                          context(@"with nil query", ^{
                                      let(query, ^{ return (NSString *)nil; });
                                      it(@"", ^{ [[subject should] beNil]; });
                                  });
                          context(@"with valid query", ^{
                                      let(query, ^{ return @"\"&'=/?!#%()=-~^|[]{}<>,._123"; });
                                      it(@"", ^{
                                             [[subject should] equal:@"%22%26'%3D%2F%3F!%23%25()%3D-~%5E%7C%5B%5D%7B%7D%3C%3E%2C._123"];
                                         });
                                  });
                      });
             describe(@".decodeURIComponent", ^{
                          let(query, ^{ return @""; });
                          let(subject, ^{ return [MTURLBuilder decodeURIComponent:query]; });
                          context(@"with empty query", ^{
                                      it(@"", ^{ [[subject should] equal:@""]; });
                                  });
                          context(@"with nil query", ^{
                                      let(query, ^{ return (NSString *)nil; });
                                      it(@"", ^{ [[subject should] beNil]; });
                                  });
                          context(@"with valid query", ^{
                                      let(query, ^{ return @"%22%26'%3D%2F%3F!%23%25()%3D-~%5E%7C%5B%5D%7B%7D%3C%3E%2C._123"; });
                                      it(@"", ^{ [[subject should] equal:@"\"&'=/?!#%()=-~^|[]{}<>,._123"]; });
                                  });
                      });

         });

SPEC_END
