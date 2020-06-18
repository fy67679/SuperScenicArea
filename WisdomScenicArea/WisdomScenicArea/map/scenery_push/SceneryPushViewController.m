//
//  SceneryPushViewController.m
//  WisdomScenicArea
//
//  Created by chen on 2020/5/28.
//

#import "SceneryPushViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "ScenicDescribeUtil.h"
#import "ScreenUtil.h"
#import <LGBluetooth.h>

//景物推送
@interface SceneryPushViewController ()<CBCentralManagerDelegate>

@property (nonatomic, strong, readwrite) UILabel *lbName;
@property (nonatomic, strong, readwrite) UIImageView *ivPicture;
@property (nonatomic, strong, readwrite) UITextView *tvInfo;

@property (nonatomic, strong) CBCentralManager *bluetoothManager;
@property (nonatomic, strong) CBCharacteristic *characteristic;

@end

@implementation SceneryPushViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    /** 只要一触发这句代码系统会自动检测手机蓝牙状态，你必须实现其代理方法，当然得添加<CBCentralManagerDelegate>*/
    self.bluetoothManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    /** 两个参数为nil, 默认扫描所有的外设，可以设置一些服务，进行过滤搜索*/
//    [self.bluetoothManager scanForPeripheralsWithServices:nil options:nil];

    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], CBCentralManagerScanOptionAllowDuplicatesKey, nil];

    [self.bluetoothManager scanForPeripheralsWithServices:nil options:options];
    
    [[LGCentralManager sharedInstance] scanForPeripheralsByInterval:5
                                                        completion:^(NSArray *peripherals) {
        if(peripherals.count > 0){
            LGPeripheral *peripheral = [peripherals objectAtIndex:0];
            NSLog(@"搜索到蓝牙=%@,RSSI=%d",peripheral.name,peripheral.RSSI);
        }else{
            NSLog(@"未搜索到蓝牙设备");
        }
    }];
}

#pragma mark 初始化view
- (void)initView {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"景物推送";

    [self.view addSubview:({
        _lbName = [[UILabel alloc] initWithFrame:UIRect(151, STATUSBAR_HEIGHT + 44 + 18, 111, 35)];
        _lbName.font = [UIFont systemFontOfSize:UI(20)];
        _lbName.text = @"水晶宫";
        _lbName.textAlignment = NSTextAlignmentCenter;
        _lbName;
    })];

    [self.view addSubview:({
        _ivPicture = [[UIImageView alloc] initWithFrame:UIRect(67, STATUSBAR_HEIGHT + 44 + 63, 280, 230)];
        _ivPicture.image = [UIImage imageNamed:@"sjg"];

        _ivPicture.userInteractionEnabled = true;
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(click_picture)];
        [_ivPicture addGestureRecognizer:tapGesture];

        _ivPicture;
    })];

    [self.view addSubview:({
        _tvInfo = [[UITextView alloc] initWithFrame:CGRectMake(UI(20), UI(STATUSBAR_HEIGHT + 44 + 314), UI(374), self.view.bounds.size.height-UI(STATUSBAR_HEIGHT + 44 + 314)-UI(20))];
        _tvInfo.text = [ScenicDescribeUtil getSJG];
        _tvInfo.font = [UIFont systemFontOfSize:16];
        [_tvInfo setEditable:NO];  //使其不能编辑
        //设置内边距
        _tvInfo.textContainerInset = UIEdgeInsetsMake(UI(5), UI(5), UI(5), UI(5));

        //设置圆角半径为方形边长一半
        [_tvInfo.layer setCornerRadius:UI(10)];
        [_tvInfo.layer setMasksToBounds:YES];

        //设置边框宽度和颜色
        [_tvInfo.layer setBorderWidth:0.5];
        [_tvInfo.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];

        _tvInfo;
    })];
}

#pragma mark 点击事件
- (void)click_picture {
    NSLog(@"点击图片");
}

/* 这里默认扫到MI，主动连接，当然也可以手动触发连接*/
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    
    NSLog(@"扫描连接外设：%@ %@", peripheral.name, RSSI);
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    switch (central.state) {
        case CBManagerStateUnknown: {
            NSLog(@"CBManagerStateUnknown");  //状态未知
            break;
        }
        case CBManagerStateResetting: {
            NSLog(@"CBManagerStateResetting");  //重置
            break;
        }
        case CBManagerStateUnsupported: {
            NSLog(@"CBManagerStateUnsupported");  //不支持
            break;
        }
        case CBManagerStateUnauthorized: {
            NSLog(@"CBManagerStateUnauthorized");  //未授权
            break;
        }
        case CBManagerStatePoweredOff: {
            NSLog(@"CBManagerStatePoweredOff");  //关闭
            break;
        }
        case CBManagerStatePoweredOn: {
            NSLog(@"CBManagerStatePoweredOn");  //开启
            break;
        }
    }
}


@end
