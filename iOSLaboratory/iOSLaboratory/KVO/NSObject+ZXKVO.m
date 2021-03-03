//
//  NSObject+ZXKVO.m
//  iOSLaboratory
//
//  Created by 子霄🐼 on 2020/11/26.
//

#import "NSObject+ZXKVO.h"
#import <objc/message.h>
#import "KVOInfo.h"

static NSString *const kZXKVOPrefix = @"ZXKVONotifying_";
static NSString *const kZXKVOAssiociateKey = @"kZXKVO_AssiociateKey";

@implementation NSObject (ZXKVO)
- (void)zx_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(nullable void *)context  block:(KVOBlock)block {
  // 过滤实例参数
  [self judgeSetterMethodFromKeyPath:keyPath];
  Class cls = [self createClass:keyPath];
  object_setClass(self, cls);
  
  
  NSMutableArray * infoArray = objc_getAssociatedObject(self, (__bridge const void * _Nonnull)(kZXKVOAssiociateKey));
  
  if (!infoArray) {
    KVOInfo *info = [[KVOInfo alloc]initObserver:observer forKeyPath:keyPath options:options context:context block:block];
    infoArray = [NSMutableArray arrayWithObject:info];
    objc_setAssociatedObject(self, (__bridge const void * _Nonnull)(kZXKVOAssiociateKey), infoArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
  }
  
}


-(Class)createClass: (NSString *)keyPath {
  NSString * newName = [NSString stringWithFormat:@"%@%@",kZXKVOPrefix, NSStringFromClass([self class])];
  Class newCls = NSClassFromString(newName);
  if (newCls) return newCls;
  newCls = objc_allocateClassPair([self class], newName.UTF8String, 0);
  objc_registerClassPair(newCls);
  
  // 重写class
  SEL sel = NSSelectorFromString(@"class");
  Method method = class_getInstanceMethod([self class], sel);
  const char * type = method_getTypeEncoding(method);
  class_addMethod(newCls, sel, (IMP)zx_class, type);
  
  // 重写setter
  SEL setSel = NSSelectorFromString(setterForGetter(keyPath));
  Method setterM = class_getInstanceMethod([self class], setSel);
  const char * setterType = method_getTypeEncoding(setterM);
  class_addMethod(newCls, setSel, (IMP)zx_setter, setterType);
  
  return  newCls;
}

- (void)zx_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath context:(nullable void *)context API_AVAILABLE(macos(10.7), ios(5.0), watchos(2.0), tvos(9.0)) {
  
}

- (void)zx_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath {
  NSMutableArray * infoArray = objc_getAssociatedObject(self, (__bridge const void * _Nonnull)(kZXKVOAssiociateKey));
  if (infoArray.count <= 0) {
    return;
  }
  
  for (KVOInfo *info in infoArray) {
    if ([info.keyPath isEqualToString:keyPath]) {
      [infoArray removeObject:info];
      objc_setAssociatedObject(self, (__bridge const void * _Nonnull)(kZXKVOAssiociateKey), infoArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
  }
  if (infoArray.count <= 0) {
    object_setClass(self, [self class]);
  }
}

#pragma mark 代码实现区
Class zx_class(id self, SEL _cmd) {
  return class_getSuperclass(object_getClass(self));
}

static void zx_setter(id self,SEL _cmd,id newValue) {
  NSLog(@"%@",newValue);
  NSString * keyPath = getterForSetter(NSStringFromSelector(_cmd));
  [self willChangeValueForKey:keyPath];
  void (*zx_objc_msgSendSuper)(id,SEL, id) = (void *)objc_msgSendSuper;
  struct objc_super zx_objc_super = {
      .receiver = self,
      .super_class = class_getSuperclass(object_getClass(self)),
  };
  
  zx_objc_msgSendSuper((__bridge id)(&zx_objc_super), _cmd,newValue);
  [self didChangeValueForKey:keyPath];
  
  NSMutableArray * infoArray = objc_getAssociatedObject(self, (__bridge const void * _Nonnull)(kZXKVOAssiociateKey));
  SEL obserSEL = @selector(observeValueForKeyPath:ofObject:change:context:);
  for (KVOInfo *info in infoArray) {
    if ([info.keyPath isEqualToString:keyPath]) {
      info.block(info.keyPath, info.observer, @{keyPath: newValue}, info.context);
      objc_msgSend(info.observer, obserSEL,self,info.observer,@{keyPath: newValue},NULL);
    }
  }
  
}


#pragma mark - 验证是否存在setter方法
- (void)judgeSetterMethodFromKeyPath:(NSString *)keyPath{
    Class superClass    = object_getClass(self);
    SEL setterSeletor   = NSSelectorFromString(setterForGetter(keyPath));
    Method setterMethod = class_getInstanceMethod(superClass, setterSeletor);
    if (!setterMethod) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"老铁没有当前%@的setter",keyPath] userInfo:nil];
    }
}

#pragma mark - 从get方法获取set方法的名称 key ===>>> setKey:
static NSString *setterForGetter(NSString *getter){
    
    if (getter.length <= 0) { return nil;}
    
    NSString *firstString = [[getter substringToIndex:1] uppercaseString];
    NSString *leaveString = [getter substringFromIndex:1];
    
    return [NSString stringWithFormat:@"set%@%@:",firstString,leaveString];
}

#pragma mark - 从set方法获取getter方法的名称 set<Key>:===> key
static NSString *getterForSetter(NSString *setter){
    
    if (setter.length <= 0 || ![setter hasPrefix:@"set"] || ![setter hasSuffix:@":"]) { return nil;}
    
    NSRange range = NSMakeRange(3, setter.length-4);
    NSString *getter = [setter substringWithRange:range];
    NSString *firstString = [[getter substringToIndex:1] lowercaseString];
    return  [getter stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:firstString];
}

@end
