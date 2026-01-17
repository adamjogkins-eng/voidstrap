#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>

@interface VoidstrapMenu : UIView
@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, strong) UIScrollView *menu;
@property (nonatomic, strong) UIView *header;
@end

@implementation VoidstrapMenu

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor clearColor];
        [self setupUI];
    }
    return self;
}

- (void)setFlag:(NSString *)k v:(id)v {
    NSString *p = [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"ClientSettings"];
    NSString *f = [p stringByAppendingPathComponent:@"ClientAppSettings.json"];
    [[NSFileManager defaultManager] createDirectoryAtPath:p withIntermediateDirectories:YES attributes:nil error:nil];

    NSMutableDictionary *d = [NSMutableDictionary dictionary];
    if ([[NSFileManager defaultManager] fileExistsAtPath:f]) {
        NSData *data = [NSData dataWithContentsOfFile:f];
        if (data) d = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil] ?: [NSMutableDictionary dictionary];
    }
    d[k] = v;
    [[NSJSONSerialization dataWithJSONObject:d options:NSJSONWritingPrettyPrinted error:nil] writeToFile:f atomically:YES];
}

- (void)addOpt:(NSString *)txt y:(CGFloat)y sel:(SEL)s {
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(20, y, 160, 30)];
    l.text = [txt uppercaseString];
    l.textColor = [UIColor whiteColor];
    l.font = [UIFont fontWithName:@"Courier-Bold" size:11];
    [self.menu addSubview:l];

    UISwitch *sw = [[UISwitch alloc] initWithFrame:CGRectMake(190, y, 0, 0)];
    sw.onTintColor = [UIColor systemPurpleColor];
    sw.transform = CGAffineTransformMakeScale(0.7, 0.7);
    [sw addTarget:self action:s forControlEvents:UIControlEventValueChanged];
    [self.menu addSubview:sw];
}

- (void)setupUI {
    // 1. Floating 'v' Button
    self.btn = [[UIButton alloc] initWithFrame:CGRectMake(50, 100, 55, 55)];
    self.btn.backgroundColor = [UIColor colorWithRed:0.2 green:0.0 blue:0.5 alpha:0.9];
    self.btn.layer.cornerRadius = 27.5;
    self.btn.layer.borderWidth = 1.5;
    self.btn.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.btn setTitle:@"𝔳" forState:UIControlStateNormal];
    self.btn.titleLabel.font = [UIFont systemFontOfSize:26 weight:UIFontWeightBold];
    [self.btn addTarget:self action:@selector(toggleMenu) forControlEvents:UIControlEventTouchUpInside];
    [self.btn addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleBtnPan:)]];
    [self addSubview:self.btn];

    // 2. Draggable Main Panel
    self.menu = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 270, 420)];
    self.menu.center = CGPointMake(UIScreen.mainScreen.bounds.size.width/2, UIScreen.mainScreen.bounds.size.height/2);
    self.menu.backgroundColor = [UIColor colorWithRed:0.01 green:0.01 blue:0.03 alpha:0.98];
    self.menu.layer.cornerRadius = 12;
    self.menu.layer.borderColor = [UIColor systemPurpleColor].CGColor;
    self.menu.layer.borderWidth = 2;
    self.menu.alpha = 0;
    self.menu.hidden = YES;
    self.menu.contentSize = CGSizeMake(270, 700);

    // Header (The drag handle)
    self.header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 270, 45)];
    self.header.backgroundColor = [UIColor colorWithRed:0.1 green:0.0 blue:0.2 alpha:1.0];
    UILabel *hLabel = [[UILabel alloc] initWithFrame:self.header.bounds];
    hLabel.text = @"VOIDSTRAP ADMIN V3";
    hLabel.textAlignment = NSTextAlignmentCenter;
    hLabel.textColor = [UIColor whiteColor];
    hLabel.font = [UIFont fontWithName:@"Courier-Bold" size:16];
    [self.header addSubview:hLabel];
    
    UIPanGestureRecognizer *menuPan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleMenuPan:)];
    [self.header addGestureRecognizer:menuPan];
    [self.menu addSubview:self.header];

    // --- 9 LAG REDUCTION (Existing) ---
    CGFloat startY = 60;
    [self addOpt:@"FPS Unlock" y:startY sel:@selector(f1:)];
    [self addOpt:@"No Textures" y:startY+35 sel:@selector(f2:)];
    [self addOpt:@"No Shadows" y:startY+70 sel:@selector(f3:)];
    [self addOpt:@"Potato Mode" y:startY+105 sel:@selector(f4:)];
    [self addOpt:@"No Blur" y:startY+140 sel:@selector(f5:)];
    [self addOpt:@"No Deco" y:startY+175 sel:@selector(f6:)];
    [self addOpt:@"Metal API" y:startY+210 sel:@selector(f7:)];
    [self addOpt:@"No AA" y:startY+245 sel:@selector(f8:)];
    [self addOpt:@"Fast Load" y:startY+280 sel:@selector(f9:)];

    // --- 6 NEW ADMIN FEATURES ---
    startY = 385;
    UILabel *adminLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, startY-30, 270, 20)];
    adminLabel.text = @"--- ADMIN UTILS ---";
    adminLabel.textAlignment = NSTextAlignmentCenter; adminLabel.textColor = [UIColor systemPurpleColor];
    adminLabel.font = [UIFont boldSystemFontOfSize:12];
    [self.menu addSubview:adminLabel];

    [self addOpt:@"FullBright (ESP)" y:startY sel:@selector(a1:)];
    [self addOpt:@"Extreme FOV" y:startY+35 sel:@selector(a2:)];
    [self addOpt:@"High JumpPower" y:startY+70 sel:@selector(a3:)];
    [self addOpt:@"Instant Respawn" y:startY+105 sel:@selector(a4:)];
    [self addOpt:@"Unlimited Zoom" y:startY+140 sel:@selector(a5:)];
    [self addOpt:@"Force Voxel" y:startY+175 sel:@selector(a6:)];

    [self addSubview:self.menu];
}

// DRAG LOGIC
- (void)handleBtnPan:(UIPanGestureRecognizer *)p { self.btn.center = [p locationInView:self]; }
- (void)handleMenuPan:(UIPanGestureRecognizer *)p {
    CGPoint translation = [p translationInView:self];
    self.menu.center = CGPointMake(self.menu.center.x + translation.x, self.menu.center.y + translation.y);
    [p setTranslation:CGPointZero inView:self];
}

- (void)toggleMenu {
    BOOL show = (self.menu.alpha == 0);
    if (show) self.menu.hidden = NO;
    [UIView animateWithDuration:0.2 animations:^{ self.menu.alpha = show ? 1.0 : 0.0; } completion:^(BOOL f){ if(!show) self.menu.hidden = YES; }];
}

// FLAG HANDLERS (9 Performance)
- (void)f1:(UISwitch *)s { [self setFlag:@"DFIntTaskSchedulerTargetFps" v:s.isOn ? @999 : @60]; }
- (void)f2:(UISwitch *)s { [self setFlag:@"DFFlagDebugDisableOptimizedTextureTarget" v:s.isOn ? @"True" : @"False"]; }
- (void)f3:(UISwitch *)s { [self setFlag:@"FIntRenderShadowIntensity" v:s.isOn ? @0 : @1]; }
- (void)f4:(UISwitch *)s { [self setFlag:@"FIntDebugForceRenderQuality" v:s.isOn ? @1 : @0]; }
- (void)f5:(UISwitch *)s { [self setFlag:@"FFlagDisablePostProcess" v:s.isOn ? @"True" : @"False"]; }
- (void)f6:(UISwitch *)s { [self setFlag:@"FIntRenderTerrainDecorationPath" v:s.isOn ? @0 : @1]; }
- (void)f7:(UISwitch *)s { [self setFlag:@"FFlagDebugForceMetal" v:s.isOn ? @"True" : @"False"]; }
- (void)f8:(UISwitch *)s { [self setFlag:@"FIntMsaaSampleCount" v:s.isOn ? @0 : @4]; }
- (void)f9:(UISwitch *)s { [self setFlag:@"FIntFFlagBootstrapperReloadPolicy" v:s.isOn ? @0 : @1]; }

// FLAG HANDLERS (6 Admin)
- (void)a1:(UISwitch *)s { [self setFlag:@"FFlagDebugDisplayUntrackedMemory" v:s.isOn ? @"True" : @"False"]; } 
- (void)a2:(UISwitch *)s { [self setFlag:@"FIntCameraMaxFOV" v:s.isOn ? @120 : @70]; }
- (void)a3:(UISwitch *)s { [self setFlag:@"FIntCharacterJumpPowerOption" v:s.isOn ? @100 : @50]; }
- (void)a4:(UISwitch *)s { [self setFlag:@"FIntRespawnTimeForce" v:s.isOn ? @0 : @3]; }
- (void)a5:(UISwitch *)s { [self setFlag:@"FIntCameraMaxZoomDistance" v:s.isOn ? @9999 : @400]; }
- (void)a6:(UISwitch *)s { [self setFlag:@"DFFlagDebugRenderForceVoxel" v:s.isOn ? @"True" : @"False"]; }

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *hit = [super hitTest:point withEvent:event];
    return (hit == self) ? nil : hit;
}
@end

__attribute__((constructor)) static void init() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        UIWindow *window = nil;
        for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes) {
            if (scene.activationState == UISceneActivationStateForegroundActive) {
                window = scene.windows.firstObject; break;
            }
        }
        if (!window) window = [UIApplication sharedApplication].windows.firstObject;
        VoidstrapMenu *v = [[VoidstrapMenu alloc] initWithFrame:window.bounds];
        v.layer.zPosition = 9999; [window addSubview:v];
    });
}
