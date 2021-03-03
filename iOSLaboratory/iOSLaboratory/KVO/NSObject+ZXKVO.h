//
//  NSObject+ZXKVO.h
//  iOSLaboratory
//
//  Created by 子霄🐼 on 2020/11/26.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^KVOBlock)(NSString *keyPath, id object, NSDictionary *change, void * context);

@interface NSObject (ZXKVO)

- (void)zx_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(nullable void *)context block:(KVOBlock)block;
- (void)zx_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath context:(nullable void *)context API_AVAILABLE(macos(10.7), ios(5.0), watchos(2.0), tvos(9.0));
- (void)zx_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath;

@end

NS_ASSUME_NONNULL_END
