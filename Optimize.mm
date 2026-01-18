#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

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
        [self setupUI];
        [self enableDefaultNuclear]; // Enable texture killer on start
    }
    return self;
}

// THE ENGINE OVERRIDE LOGIC
- (void)applyFlag:(NSString *)k v:(id)v {
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *bundlePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"ClientSettings"];
    NSString *libPath = [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"ClientSettings"];

    for (NSString *path in @[bundlePath, libPath]) {
        [fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        NSString *file = [path stringByAppendingPathComponent:@"ClientAppSettings.json"];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        if ([fm fileExistsAtPath:file]) {
            NSData *data = [NSData dataWithContentsOfFile:file];
            dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil] ?: [NSMutableDictionary dictionary];
        }
        dict[k] = v;
        [[NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil] writeToFile:file atomically:YES];
    }
}

// FORCE NUCLEAR TEXTURES ON START
- (void)enableDefaultNuclear {
    [self applyFlag:@"DFFlagDebugDisableOptimizedTextureTarget" v:@"True"];
    [self applyFlag:@"FIntRenderTextureBias" v:@10];
    [self applyFlag:@"FIntRenderTextureCompositor" v:@0];
}

- (void)addOpt:(NSString *)txt y:(CGFloat)y sel:(SEL)s {
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(20, y, 175, 30)];
    l.text = [txt uppercaseString];
    l.textColor = [UIColor whiteColor];
    l.font = [UIFont fontWithName:@"Courier-Bold" size:10];
    [self.menu addSubview:l];

    UISwitch *sw = [[UISwitch alloc] initWithFrame:CGRectMake(200, y, 0, 0)];
    sw.onTintColor = [UIColor systemPurpleColor];
    sw.transform = CGAffineTransformMakeScale(0.65, 0.65);
    [sw addTarget:self action:s forControlEvents:UIControlEventValueChanged];
    [self.menu addSubview:sw];
}

- (void)setupUI {
    self.btn = [[UIButton alloc] initWithFrame:CGRectMake(60, 120, 50, 50)];
    self.btn.backgroundColor = [UIColor colorWithRed:0.4 green:0.0 blue:0.8 alpha:0.9];
    self.btn.layer.cornerRadius = 25;
    [self.btn setTitle:@"𝔳" forState:UIControlStateNormal];
    [self.btn addTarget:self action:@selector(toggle) forControlEvents:UIControlEventTouchUpInside];
    [self.btn addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panB:)]];
    [self addSubview:self.btn];

    self.menu = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 280, 480)];
    self.menu.center = CGPointMake(UIScreen.mainScreen.bounds.size.width/2, UIScreen.mainScreen.bounds.size.height/2);
    self.menu.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.98];
    self.menu.layer.cornerRadius = 15;
    self.menu.layer.borderColor = [UIColor systemPurpleColor].CGColor;
    self.menu.layer.borderWidth = 2;
    self.menu.alpha = 0;
    self.menu.hidden = YES;
    self.menu.contentSize = CGSizeMake(280, 750);

    self.header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 50)];
    self.header.backgroundColor = [UIColor colorWithRed:0.1 green:0.0 blue:0.2 alpha:1.0];
    [self.header addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panM:)]];
    [self.menu addSubview:self.header];
    UILabel *t = [[UILabel alloc] initWithFrame:self.header.bounds];
    t.text = @"VOIDSTRAP TOTAL OPTIMIZE V8";
    t.textAlignment = NSTextAlignmentCenter; t.textColor = [UIColor whiteColor];
    t.font = [UIFont boldSystemFontOfSize:12];
    [self.header addSubview:t];

    // --- 14 CUSTOM TOOLS (Nuclear Textures Always Active) ---
    CGFloat sY = 60;
    [self addOpt:@"Zero Ping Mode" y:sY sel:@selector(c1:)];
    [self addOpt:@"Packet Priority" y:sY+35 sel:@selector(c2:)];
    [self addOpt:@"Solid Colors (Plastic)" y:sY+70 sel:@selector(c3:)];
    [self addOpt:@"FPS Unlocker (999)" y:sY+105 sel:@selector(c4:)];
    [self addOpt:@"Kill All Shadows" y:sY+140 sel:@selector(c5:)];
    [self addOpt:@"Disable Post-FX" y:sY+175 sel:@selector(c6:)];
    [self addOpt:@"Metal API Boost" y:sY+210 sel:@selector(c7:)];
    [self addOpt:@"Aggressive RAM GC" y:sY+245 sel:@selector(c8:)];
    [self addOpt:@"Lower Res Scale" y:sY+280 sel:@selector(c9:)];
    [self addOpt:@"Minimum Mesh LOD" y:sY+315 sel:@selector(c10:)];
    [self addOpt:@"Kill Decals/Grass" y:sY+350 sel:@selector(c11:)];
    [self addOpt:@"Fast Asset Loading" y:sY+385 sel:@selector(c12:)];
    [self addOpt:@"Disable Skybox" y:sY+420 sel:@selector(c13:)];
    [self addOpt:@"Engine Priority (CPU)" y:sY+455 sel:@selector(c14:)];

    [self addSubview:self.menu];
}

// LOGIC FOR THE 14 TOOLS
- (void)c1:(UISwitch *)s { [self applyFlag:@"FIntNetworkMaxPort" v:s.isOn ? @1 : @0]; }
- (void)c2:(UISwitch *)s { [self applyFlag:@"FIntClientNetPriority" v:s.isOn ? @1 : @0]; [self applyFlag:@"FFlagNetworkSendGlobalPacket" v:s.isOn ? @"False" : @"True"]; }
- (void)c3:(UISwitch *)s { [self applyFlag:@"FIntDebugForceRenderQuality" v:s.isOn ? @1 : @0]; }
- (void)c4:(UISwitch *)s { [self applyFlag:@"DFIntTaskSchedulerTargetFps" v:s.isOn ? @999 : @60]; }
- (void)c5:(UISwitch *)s { [self applyFlag:@"FIntRenderShadowIntensity" v:s.isOn ? @0 : @1]; }
- (void)c6:(UISwitch *)s { [self applyFlag:@"FFlagDisablePostProcess" v:s.isOn ? @"True" : @"False"]; }
- (void)c7:(UISwitch *)s { [self applyFlag:@"FFlagDebugForceMetal" v:s.isOn ? @"True" : @"False"]; }
- (void)c8:(UISwitch *)s { [self applyFlag:@"FIntDebugForceGC" v:s.isOn ? @1 : @0]; }
- (void)c9:(UISwitch *)s { [self applyFlag:@"FIntDebugImageSlowerResolution" v:s.isOn ? @1 : @0]; }
- (void)c10:(UISwitch *)s { [self applyFlag:@"FIntRenderMeshLOD" v:s.isOn ? @0 : @100]; }
- (void)c11:(UISwitch *)s { [self applyFlag:@"FFlagDebugDisableDecals" v:s.isOn ? @"True" : @"False"]; [self applyFlag:@"FIntRenderTerrainDecorationPath" v:s.isOn ? @0 : @1]; }
- (void)c12:(UISwitch *)s { [self applyFlag:@"FFlagPreloadAllModels" v:s.isOn ? @"True" : @"False"]; }
- (void)c13:(UISwitch *)s { [self applyFlag:@"FFlagDebugDisableSkybox" v:s.isOn ? @"True" : @"False"]; }
- (void)c14:(UISwitch *)s { [self applyFlag:@"FIntMainLoopPriority" v:s.isOn ? @2 : @0]; }

- (void)toggle { BOOL s = (self.menu.alpha == 0); if(s) self.menu.hidden = NO; [UIView animateWithDuration:0.2 animations:^{ self.menu.alpha = s ? 1:0; } completion:^(BOOL f){ if(!s) self.menu.hidden=YES; }]; }
- (void)panB:(UIPanGestureRecognizer *)p { self.btn.center = [p locationInView:self]; }
- (void)panM:(UIPanGestureRecognizer *)p { CGPoint t = [p translationInView:self]; self.menu.center = CGPointMake(self.menu.center.x+t.x, self.menu.center.y+t.y); [p setTranslation:CGPointZero inView:nil]; }
- (UIView *)hitTest:(CGPoint)p withEvent:(UIEvent *)e { UIView *h = [super hitTest:p withEvent:e]; return (h==self) ? nil:h; }
@end

__attribute__((constructor)) static void init() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        UIWindow *w = [UIApplication sharedApplication].windows.firstObject;
        VoidstrapMenu *v = [[VoidstrapMenu alloc] initWithFrame:w.bounds];
        v.layer.zPosition = 9999; [w addSubview:v];
    });
}
