The solution involves using blocks or weak references to prevent accessing deallocated objects.

Using Blocks:

```objectivec
@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *string = [NSString stringWithString:@"Hello"];
    MyClass *myObject = [[MyClass alloc] init];
    myObject.myString = string;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{ 
        [myObject myMethod:myObject.myString];
    });
    //myObject is released, the block holds a strong reference till execution
}
@end
```

Using Weak References:

```objectivec
@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *string = [NSString stringWithString:@"Hello"];
    MyClass *myObject = [[MyClass alloc] init];
    myObject.myString = string;
    __weak MyClass *weakMyObject = myObject; 
    [self performSelector:@selector(callMethodWithWeakObject:) withObject:weakMyObject afterDelay:2.0];
    //myObject is released, callMethodWithWeakObject handles nil properly 
}

- (void)callMethodWithWeakObject:(MyClass *)obj {
    if (obj) {
        [obj myMethod:obj.myString]; 
    }
}
@end
```
Both methods prevent crashes by ensuring the object is still valid before the selector is invoked.