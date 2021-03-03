//
//  B.m
//  学习实验项目
//
//  Created by 子霄🐼 on 2020/10/29.
//

#import "B.h"

@implementation B

- (instancetype)init
{
  self = [super init];
  if (self) {
    id obj1 = [self class];
        id obj2 = [super class];
        NSLog(@"%@",obj1);
        NSLog(@"%@",obj2);
  }
  return self;
}

- (Class)class {
  NSLog(@"aaaa");
  return [super class];
}

@end
