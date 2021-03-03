//
//  TwoViewController.m
//  学习实验项目
//
//  Created by 子霄🐼 on 2020/11/26.
//

#import "TwoViewController.h"


@interface TwoViewController ()
@property(nonatomic, strong) NSArray * vcList;
@end

@implementation TwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  self.vcList = [NSArray arrayWithObject:@"KVOViewController"];
  
  [self addButton:@"KVO" withTag:0];
}

-(void)addButton:(NSString *)title withTag:(NSInteger)tag {
  long placeholder = 100 + (50 * tag);
  UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
  btn.frame = CGRectMake(30, placeholder, self.view.bounds.size.width - 60, 40);
  btn.backgroundColor = [UIColor whiteColor];
  [btn setTitle:title forState:(UIControlStateNormal)];
  btn.titleLabel.tintColor = UIColor.blackColor;
  btn.tag = tag;
  [btn addTarget:self action:@selector(click:) forControlEvents:(UIControlEventTouchUpInside)];
  [self.view addSubview:btn];
}

-(void)click:(UIButton *)btn {
  Class cls = NSClassFromString(self.vcList[btn.tag]);
  UIViewController * vc = (UIViewController *)[cls new];
  vc.view.backgroundColor = UIColor.whiteColor;
  [self.navigationController pushViewController:vc animated:YES];
}

@end
