//
//  Demo.m
//  学习实验项目
//
//  Created by 子霄🐼 on 2020/11/26.
//

#import "Demo.h"
#import "B.h"

@implementation Demo

NSString * str = @"123";
-(void)blockDemo1 {
  __block int a = 0;
    // 定义前：0x7ffee6dc5088
     NSLog(@"定义前：%p", &a);         //栈区
     void (^foo)(void) = ^{
       a = 2;
       int a = 1;
       str = @"321";
       // block内部: 1 0x7ffee6dc4ffc
         NSLog(@"block内部: %d %p %@", a, &a, str);    //堆区
     };
     // 定义后：0x600003393d98
     NSLog(@"定义后：%p, %@", &a, str);         //堆区
     foo();
  // 定义后1：2 0x600003393d98
  NSLog(@"定义后1：%d %p %@", a, &a, str);
}

-(void)blockDemo2 {
  NSMutableString *a = [NSMutableString stringWithString:@"Tom"];
      NSLog(@"\n 定以前：------------------------------------\n\
            a指向的堆中地址：%p；a在栈中的指针地址：%p", a, &a);               //a在栈区
      void (^foo)(void) = ^{
          a.string = @"Jerry";
          NSLog(@"\n block内部：------------------------------------\n\
           a指向的堆中地址：%p；a在栈中的指针地址：%p", a, &a);               //a在栈区
//          a = [NSMutableString stringWithString:@"William"];
      };
  NSLog(@"\n 定以后1：------------------------------------\n\
        a指向的堆中地址：%p；a在栈中的指针地址：%p", a, &a);
      foo();
  NSLog(@"%@", a);
  NSLog(@"\n 定以后：------------------------------------\n\
        a指向的堆中地址：%p；a在栈中的指针地址：%p", a, &a);
}

-(void)superAndself {
  B *b = [[B alloc] init];
}

@end
