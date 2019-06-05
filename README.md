# JeroldPKView
PK动画
使用方法：
```
self.pkView = [[PKView alloc]initWithTotalNum:100 votedNum:50 frame:CGRectMake(15, 200, SCREEN_WIDTH-30, 36)];
self.pkView.layer.cornerRadius = 18;
self.pkView.layer.masksToBounds = YES;
[self.view addSubview:self.pkView];
```
