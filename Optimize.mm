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
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(20, y, 170, 30)];
    l.text = [txt uppercaseString];
    l.textColor = [UIColor whiteColor];
    l.font = [UIFont fontWithName:@"Courier-Bold" size:11];
    [self.menu addSubview:l];

    UISwitch *sw = [[UISwitch alloc] initWithFrame:CGRectMake(195, y, 0, 0)];
    sw.onTintColor = [UIColor systemPurpleColor];
    sw.transform = CGAffineTransformMakeScale(0.65, 0.65);
    [sw addTarget:self action:s forControlEvents:UIControlEventValueChanged];
    [self.menu addSubview:sw];
}

- (void)setupUI {
    self.btn = [[UIButton alloc] initWithFrame:CGRectMake(50, 100, 55, 55)];
    self.btn.backgroundColor = [UIColor colorWithRed:0.2 green:0.0 blue:0.4 alpha:0.9];
    self.btn.layer.cornerRadius = 27.5;
    self.btn.layer.borderWidth = 1.5;
    self.btn.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.btn setTitle:@"𝔳" forState:UIControlStateNormal];
    self.btn.titleLabel.font = [UIFont systemFontOfSize:26 weight:UIFontWeightBold];
    [self.btn addTarget:self action:@selector(toggleMenu) forControlEvents:UIControlEventTouchUpInside];
    [self.btn addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleBtnPan:)]];
    [self addSubview:self.btn];

    self.menu = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 275, 450)];
    self.menu.center = CGPointMake(UIScreen.mainScreen.bounds.size.width/2, UIScreen.mainScreen.bounds.size.height/2);
    self.menu.backgroundColor = [UIColor colorWithRed:0.01 green:0.01 blue:0.02 alpha:0.98];
    self.menu.layer.cornerRadius = 15;
    self.menu.layer.borderColor = [UIColor systemPurpleColor].CGColor;
    self.menu.layer.borderWidth = 2;
    self.menu.alpha = 0;
    self.menu.hidden = YES;
    self.menu.contentSize = CGSizeMake(275, 750);

    self.header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 275, 45)];
    self.header.backgroundColor = [UIColor colorWithRed:0.1 green:0.0 blue:0.2 alpha:1.0];
    UILabel *hLabel = [[UILabel alloc] initWithFrame:self.header.bounds];
    hLabel.text = @"VOIDSTRAP OPTIMIZER V4";
    hLabel.textAlignment = NSTextAlignmentCenter;
    hLabel.textColor = [UIColor whiteColor];
    hLabel.font = [UIFont fontWithName:@"Courier-Bold" size:14];
    [self.header addSubview:hLabel];
    [self.header addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleMenuPan:)]];
    [self.menu addSubview:self.header];

    // --- Original 9 Performance ---
    CGFloat startY = 60;
    [self addOpt:@"FPS Unlock (999)" y:startY sel:@selector(f1:)];
    [self addOpt:@"Disable Textures" y:startY+35 sel:@selector(f2:)];
    [self addOpt:@"Disable Shadows" y:startY+70 sel:@selector(f3:)];
    [self addOpt:@"Low Render Level" y:startY+105 sel:@selector(f4:)];
    [self addOpt:@"Disable Post-Proc" y:startY+140 sel:@selector(f5:)];
    [self addOpt:@"Disable Deco" y:startY+175 sel:@selector(f6:)];
    [self addOpt:@"Force Metal API" y:startY+210 sel:@selector(f7:)];
    [self addOpt:@"No Anti-Aliasing" y:startY+245 sel:@selector(f8:)];
    [self addOpt:@"Fast Load Logic" y:startY+280 sel:@selector(f9:)];

    // --- 6 NEW Advanced Optimization ---
    startY = 385;
    UILabel *advLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, startY-30, 275, 20)];
    advLabel.text = @"--- ADVANCED BOOST ---";
    advLabel.textAlignment = NSTextAlignmentCenter; advLabel.textColor = [UIColor systemPurpleColor];
    advLabel.font = [UIFont boldSystemFontOfSize:11];
    [self.menu addSubview:advLabel];

    [self addOpt:@"Low Res Scale" y:startY sel:@selector(b1:)];
    [self addOpt:@"Kill Part Physics" y:startY+35 sel:@selector(b2:)];
    [self addOpt:@"Disable Shaders" y:startY+70 sel:@selector(b3:)];
    [self addOpt:@"Min Mesh Detail" y:startY+105 sel:@selector(b4:)];
    [self addOpt:@"Aggressive GC" y:startY+140 sel:@selector(b5:)];
    [self addOpt:@"Pre-Load Stream" y:startY+175 sel:@selector(b6:)];

    [self addSubview:self.menu];
}

// Draggable Handlers
- (void)handleBtnPan:(UIPanGestureRecognizer *)p { self.btn.center = [p locationInView:self]; }
- (void)handleMenuPan:(UIPanGestureRecognizer *)p {
    CGPoint trans = [p translationInView:self];
    self.menu.center = CGPointMake(self.menu.center.x + trans.x, self.menu.center.y + trans.y);
    [p setTranslation:CGPointZero inView:self];
}

- (void)toggleMenu {
    BOOL show = (self.menu.alpha == 0);
    if (show) self.menu.hidden = NO;
    [UIView animateWithDuration:0.2 animations:^{ self.menu.alpha = show ? 1.0 : 0.0; } completion:^(BOOL f){ if(!show) self.menu.hidden = YES; }];
}

// Original 9
- (void)f1:(UISwitch *)s { [self setFlag:@"DFIntTaskSchedulerTargetFps" v:s.isOn ? @999 : @60]; }
- (void)f2:(UISwitch *)s { [self setFlag:@"DFFlagDebugDisableOptimizedTextureTarget" v:s.isOn ? @"True" : @"False"]; }
- (void)f3:(UISwitch *)s { [self setFlag:@"FIntRenderShadowIntensity" v:s.isOn ? @0 : @1]; }
- (void)f4:(UISwitch *)s { [self setFlag:@"FIntDebugForceRenderQuality" v:s.isOn ? @1 : @0]; }
- (void)f5:(UISwitch *)s { [self setFlag:@"FFlagDisablePostProcess" v:s.isOn ? @"True" : @"False"]; }
- (void)f6:(UISwitch *)s { [self setFlag:@"FIntRenderTerrainDecorationPath" v:s.isOn ? @0 : @1]; }
- (void)f7:(UISwitch *)s { [self setFlag:@"FFlagDebugForceMetal" v:s.isOn ? @"True" : @"False"]; }
- (void)f8:(UISwitch *)s { [self setFlag:@"FIntMsaaSampleCount" v:s.isOn ? @0 : @4]; }
- (void)f9:(UISwitch *)s { [self setFlag:@"FIntFFlagBootstrapperReloadPolicy" v:s.isOn ? @0 : @1]; }

// New 6 Optimization Tools
- (void)b1:(UISwitch *)s { [self setFlag:@"FIntDebugImageSlowerResolution" v:s.isOn ? @1 : @0]; }
- (void)b2:(UISwitch *)s { [self setFlag:@"FFlagDisableNewPhysicsSolver" v:s.isOn ? @"True" : @"False"]; }
- (void)b3:(UISwitch *)s { [self setFlag:@"FFlagDebugForceShadersAllOff" v:s.isOn ? @"True" : @"False"]; }
- (void)b4:(UISwitch *)s { [self setFlag:@"FIntRenderMeshLOD" v:s.isOn ? @0 : @100]; }
- (void)b5:(UISwitch *)s { [self setFlag:@"FIntDebugForceGC" v:s.isOn ? @1 : @0]; }
- (void)b6:(UISwitch *)s { [self setFlag:@"FFlagPreloadAllModels" v:s.isOn ? @"True" : @"False"]; }

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
