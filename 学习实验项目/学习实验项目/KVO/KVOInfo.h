//
//  KVOInfo.h
//  学习实验项目
//
//  Created by 子霄🐼 on 2020/11/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^KVOBlock)(NSString *keyPath, id object, NSDictionary *change, void * context);

typedef NS_OPTIONS(NSUInteger, ZXKeyValueObservingOptions) {
    ZXKeyValueObservingOptionNew = 0x01,
    ZXKeyValueObservingOptionOld = 0x02,
};

@interface KVOInfo : NSObject
@property (nonatomic, weak) NSObject  *observer;
@property (nonatomic, copy) NSString    *keyPath;
@property (nonatomic, assign) NSKeyValueObservingOptions options;
@property (nonatomic, assign) void *context;
@property (nonatomic, copy) KVOBlock block;


-(instancetype)initObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(nullable void *)context block:(KVOBlock)block;
@end

NS_ASSUME_NONNULL_END
