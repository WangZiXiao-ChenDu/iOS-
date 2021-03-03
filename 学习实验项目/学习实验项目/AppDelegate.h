//
//  AppDelegate.h
//  学习实验项目
//
//  Created by 子霄🐼 on 2020/10/19.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (readonly, strong) NSPersistentCloudKitContainer *persistentContainer;

- (void)saveContext;


@end

