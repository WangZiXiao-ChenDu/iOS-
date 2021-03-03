//
//  KVOInfo.m
//  学习实验项目
//
//  Created by 子霄🐼 on 2020/11/26.
//

#import "KVOInfo.h"

@implementation KVOInfo

-(instancetype)initObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(nullable void *)context block:(KVOBlock)block{
  self = [super init];
  if (self) {
    self.observer = observer;
    self.keyPath = keyPath;
    self.options = options;
    self.context = context;
    self.block = block;
  }
  return self;
}

@end
