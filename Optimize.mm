#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>

@interface VoidstrapMenu : UIView
@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, strong) UIScrollView *menu;
@property (nonatomic, strong) UIView *header;
@property (nonatomic, strong) UILabel *status;
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

// THE AGGRESSIVE SAVE METHOD
- (void)applyFlag:(NSString *)k v:(id)v {
    NSError *error;
    NSFileManager *fm = [NSFileManager defaultManager];
    
    // Attempt to write to both Library and Documents (Roblox varies by version)
    NSArray *paths = @[
        [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject],
        [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
    ];

    for (NSString *basePath in paths) {
        NSString *folder = [basePath stringByAppendingPathComponent:@"ClientSettings"];
        NSString *file = [folder stringByAppendingPathComponent:@"ClientAppSettings.json"];

        if (![fm fileExistsAtPath:folder]) {
            [fm createDirectoryAtPath:folder withIntermediateDirectories:YES attributes:nil error:nil];
        }

        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        if ([fm fileExistsAtPath:file]) {
            NSData *data = [NSData dataWithContentsOfFile:file];
            dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil] ?: [NSMutableDictionary dictionary];
        }

        dict[k] = v;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
        [jsonData writeToFile:file atomically:YES];
    }

    // Visual Feedback
    self.status.text = [NSString stringWithFormat:@"APPLIED: %@", k];
    self.status.textColor = [UIColor greenColor];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        self.status.text = @"READY TO RESTART";
        self.status.textColor = [UIColor systemPurpleColor];
    });
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
    // Floating Button
    self.btn = [[UIButton alloc] initWithFrame:CGRectMake(50, 100, 55, 55)];
    self.btn.backgroundColor = [UIColor colorWithRed:0.2 green:0.0 blue:0.4 alpha:0.9];
    self.btn.layer.cornerRadius = 27.5;
    self.btn.layer.borderWidth = 1.5;
    self.btn.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.btn setTitle:@"𝔳" forState:UIControlStateNormal];
    [self.btn addTarget:self action:@selector(toggle) forControlEvents:UIControlEventTouchUpInside];
    [self.btn addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panB:)]];
    [self addSubview:self.btn];

    // Main Panel
    self.menu = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 275, 450)];
    self.menu.center = self.center;
    self.menu.backgroundColor = [UIColor colorWithWhite:0.02 alpha:0.98];
    self.menu.layer.cornerRadius = 15;
    self.menu.layer.borderColor = [UIColor systemPurpleColor].CGColor;
    self.menu.layer.borderWidth = 2;
    self.menu.alpha = 0;
    self.menu.hidden = YES;
    self.menu.contentSize = CGSizeMake(275, 750);

    // Header
    self.header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 275, 45)];
    self.header.backgroundColor = [UIColor colorWithRed:0.1 green:0.0 blue:0.2 alpha:1.0];
    UILabel *hL = [[UILabel alloc] initWithFrame:self.header.bounds];
    hL.text = @"VOIDSTRAP ENGINE V5";
    hL.textAlignment = NSTextAlignmentCenter; hL.textColor = [UIColor whiteColor];
    hL.font = [UIFont boldSystemFontOfSize:14];
    [self.header addSubview:hL];
    [self.header addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panM:)]];
    [self.menu addSubview:self.header];

    // Status Label
    self.status = [[UILabel alloc] initWithFrame:CGRectMake(0, 410, 275, 30)];
    self.status.text = @"READY"; self.status.textAlignment = NSTextAlignmentCenter;
    self.status.font = [UIFont systemFontOfSize:10]; self.status.textColor = [UIColor systemPurpleColor];
    [self.menu addSubview:self.status];

    // 15 PERFORMANCE SWITCHES
    CGFloat sY = 60;
    [self addOpt:@"FPS Unlock" y:sY sel:@selector(m1:)];
    [self addOpt:@"No Textures" y:sY+35 sel:@selector(m2:)];
    [self addOpt:@"No Shadows" y:sY+70 sel:@selector(m3:)];
    [self addOpt:@"Potato Mode" y:sY+105 sel:@selector(m4:)];
    [self addOpt:@"No Post-Proc" y:sY+140 sel:@selector(m5:)];
    [self addOpt:@"No Deco" y:sY+175 sel:@selector(m6:)];
    [self addOpt:@"Metal API" y:sY+210 sel:@selector(m7:)];
    [self addOpt:@"No Anti-Alias" y:sY+245 sel:@selector(m8:)];
    [self addOpt:@"Fast Logic" y:sY+280 sel:@selector(m9:)];
    [self addOpt:@"Low Res Scale" y:sY+325 sel:@selector(m10:)];
    [self addOpt:@"Physics Kill" y:sY+360 sel:@selector(m11:)];
    [self addOpt:@"Shader Strip" y:sY+395 sel:@selector(m12:)];
    [self addOpt:@"Mesh LOD" y:sY+430 sel:@selector(m13:)];
    [self addOpt:@"Aggressive GC" y:sY+465 sel:@selector(m14:)];
    [self addOpt:@"Stream Boost" y:sY+500 sel:@selector(m15:)];

    [self addSubview:self.menu];
}

// Handlers
- (void)m1:(UISwitch *)s { [self applyFlag:@"DFIntTaskSchedulerTargetFps" v:s.isOn ? @999 : @60]; }
- (void)m2:(UISwitch *)s { [self applyFlag:@"DFFlagDebugDisableOptimizedTextureTarget" v:s.isOn ? @"True" : @"False"]; }
- (void)m3:(UISwitch *)s { [self applyFlag:@"FIntRenderShadowIntensity" v:s.isOn ? @0 : @1]; }
- (void)m4:(UISwitch *)s { [self applyFlag:@"FIntDebugForceRenderQuality" v:s.isOn ? @1 : @0]; }
- (void)m5:(UISwitch *)s { [self applyFlag:@"FFlagDisablePostProcess" v:s.isOn ? @"True" : @"False"]; }
- (void)m6:(UISwitch *)s { [self applyFlag:@"FIntRenderTerrainDecorationPath" v:s.isOn ? @0 : @1]; }
- (void)m7:(UISwitch *)s { [self applyFlag:@"FFlagDebugForceMetal" v:s.isOn ? @"True" : @"False"]; }
- (void)m8:(UISwitch *)s { [self applyFlag:@"FIntMsaaSampleCount" v:s.isOn ? @0 : @4]; }
- (void)m9:(UISwitch *)s { [self applyFlag:@"FIntFFlagBootstrapperReloadPolicy" v:s.isOn ? @0 : @1]; }
- (void)m10:(UISwitch *)s { [self applyFlag:@"FIntDebugImageSlowerResolution" v:s.isOn ? @1 : @0]; }
- (void)m11:(UISwitch *)s { [self applyFlag:@"FFlagDisableNewPhysicsSolver" v:s.isOn ? @"True" : @"False"]; }
- (void)m12:(UISwitch *)s { [self applyFlag:@"FFlagDebugForceShadersAllOff" v:s.isOn ? @"True" : @"False"]; }
- (void)m13:(UISwitch *)s { [self applyFlag:@"FIntRenderMeshLOD" v:s.isOn ? @0 : @100]; }
- (void)m14:(UISwitch *)s { [self applyFlag:@"FIntDebugForceGC" v:s.isOn ? @1 : @0]; }
- (void)m15:(UISwitch *)s { [self applyFlag:@"FFlagPreloadAllModels" v:s.isOn ? @"True" : @"False"]; }

- (void)toggle { BOOL s = (self.menu.alpha == 0); if(s) self.menu.hidden = NO; [UIView animateWithDuration:0.2 animations:^{ self.menu.alpha = s ? 1:0; } completion:^(BOOL f){ if(!s) self.menu.hidden=YES; }]; }
- (void)panB:(UIPanGestureRecognizer *)p { self.btn.center = [p locationInView:self]; }
- (void)panM:(UIPanGestureRecognizer *)p { CGPoint t = [p translationInView:self]; self.menu.center = CGPointMake(self.menu.center.x+t.x, self.menu.center.y+t.y); [p setTranslation:CGPointZero inView:self]; }
- (UIView *)hitTest:(CGPoint)p withEvent:(UIEvent *)e { UIView *h = [super hitTest:p withEvent:e]; return (h==self) ? nil:h; }
@end

__attribute__((constructor)) static void init() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        UIWindow *w = nil;
        for (UIWindowScene *s in [UIApplication sharedApplication].connectedScenes) {
            if (s.activationState == UISceneActivationStateForegroundActive) { w = s.windows.firstObject; break; }
        }
        if(!w) w = [UIApplication sharedApplication].windows.firstObject;
        VoidstrapMenu *v = [[VoidstrapMenu alloc] initWithFrame:w.bounds];
        v.layer.zPosition = 9999; [w addSubview:v];
    });
}
