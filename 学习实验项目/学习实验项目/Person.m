//
//  Person.m
//  学习实验项目
//
//  Created by 子霄🐼 on 2020/12/16.
//

#import "Person.h"
#import <objc/runtime.h>

@implementation Person

+(void) sayObjc {
  NSLog(@"%s",__func__);
}

+ (BOOL)resolveClassMethod:(SEL)sel{
    
    if (sel == @selector(walk)) {
        
        IMP imp = class_getMethodImplementation(objc_getMetaClass("Person"), @selector(sayObjc));
        
         Method method = class_getClassMethod(objc_getMetaClass("Person"), @selector(sayObjc));
        
        const char *types = method_getTypeEncoding(method);
        
        return class_addMethod(objc_getMetaClass("Person"), sel, imp, types);
    }
    return [super resolveClassMethod:sel];
}

@end
