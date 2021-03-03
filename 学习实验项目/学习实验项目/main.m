//
//  main.m
//  学习实验项目
//
//  Created by 子霄🐼 on 2020/10/19.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Person.h"

int main(int argc, char * argv[]) {
  NSString * appDelegateClassName;
  @autoreleasepool {
      // Setup code that might create autoreleased objects goes here.
      appDelegateClassName = NSStringFromClass([AppDelegate class]);
    [Person walk];
  }
  return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
