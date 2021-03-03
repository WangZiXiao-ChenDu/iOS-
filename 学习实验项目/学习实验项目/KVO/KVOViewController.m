//
//  KVOViewController.m
//  学习实验项目
//
//  Created by 子霄🐼 on 2020/11/26.
//

#import "KVOViewController.h"
#import "ZXPerson.h"
#import <objc/runtime.h>
#import "NSObject+ZXKVO.h"

@interface KVOViewController ()
@property(nonatomic, strong) ZXPerson * person;
@end

@implementation KVOViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
  [self customKVO];
}


// 系统kvo
-(void)systemKVO {
  self.person = [ZXPerson new];
  NSLog(@"添加观察前isa指向--- %s", object_getClassName(self.person));
  [self printClassAllMethod:[ZXPerson class]];
  [self printClasses:[ZXPerson class]];
  [self.person addObserver:self forKeyPath:@"nickName" options:(NSKeyValueObservingOptionNew) context:NULL];
  NSLog(@"添加观察后isa指向--- %s", object_getClassName(self.person));
  [self printClassAllMethod:[ZXPerson class]];
  [self printClasses:[ZXPerson class]];
  
  NSLog(@"----------KVO动态子类的方法列表------------");
  [self printClassAllMethod:NSClassFromString(@"NSKVONotifying_ZXPerson")];
}

-(void)customKVO {
  self.person = [ZXPerson new];
  [self.person zx_addObserver:self forKeyPath:@"nickName" options:(NSKeyValueObservingOptionNew) context:NULL block:^(NSString * _Nonnull keyPath, id  _Nonnull object, NSDictionary * _Nonnull change, void * _Nonnull context) {
    NSLog(@"block-----%@", change);
  }];
  
  NSLog(@"添加观察后isa指向--- %s", object_getClassName(self.person));
  [self printClassAllMethod:[ZXPerson class]];
  [self printClasses:[ZXPerson class]];
  
  NSLog(@"----------KVO动态子类的方法列表------------");
  [self printClassAllMethod:NSClassFromString(@"ZXKVONotifying_ZXPerson")];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  self.person.nickName = @"wzx";
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
  NSLog(@"变化后---%@", change);
}

- (void)dealloc
{
  [self.person zx_removeObserver: self forKeyPath:@"nickName"];
}

#pragma 遍历方法
-(void)printClassAllMethod:(Class)cls {
  unsigned int count = 0;
  Method *methodList = class_copyMethodList(cls, &count);
  for (int i = 0; i<count; i++) {
    Method method = methodList[i];
    SEL sel = method_getName(method);
    IMP imp = class_getMethodImplementation(cls, sel);
    NSLog(@"%@-%p", NSStringFromSelector(sel), imp);
  }
}

-(void)printClasses: (Class)cls {
  
  int count = objc_getClassList(NULL, 0);
  NSMutableArray * arr = [NSMutableArray arrayWithObject:cls];
  Class *classes = (Class*)malloc(sizeof(Class)*count);
  objc_getClassList(classes, count);
  for (int i = 0; i<count; i++) {
    if (cls == class_getSuperclass(classes[i])) {
      [arr addObject:classes[i]];
    }
  }
  free(classes);
  NSLog(@"classes = %@", arr);
}


@end
