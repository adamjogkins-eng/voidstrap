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
        [self setupUI];
    }
    return self;
}

// DIRECT HOOK TO FILESYSTEM
- (void)applyFlag:(NSString *)k v:(id)v {
    NSFileManager *fm = [NSFileManager defaultManager];
    // Modern Roblox on iOS often looks here first in side-loaded apps
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *folder = [docPath stringByAppendingPathComponent:@"ClientSettings"];
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
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    [jsonData writeToFile:file atomically:YES];
    
    // Also write to Library as a backup (some IPA versions prefer this)
    NSString *libPath = [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"ClientSettings/ClientAppSettings.json"];
    [jsonData writeToFile:libPath atomically:YES];
}

- (void)addOpt:(NSString *)txt y:(CGFloat)y sel:(SEL)s {
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(20, y, 175, 30)];
    l.text = [txt uppercaseString];
    l.textColor = [UIColor whiteColor];
    l.font = [UIFont fontWithName:@"AvenirNext-Bold" size:10];
    [self.menu addSubview:l];

    UISwitch *sw = [[UISwitch alloc] initWithFrame:CGRectMake(200, y, 0, 0)];
    sw.onTintColor = [UIColor systemPurpleColor];
    sw.transform = CGAffineTransformMakeScale(0.6, 0.6);
    [sw addTarget:self action:s forControlEvents:UIControlEventValueChanged];
    [self.menu addSubview:sw];
}

- (void)setupUI {
    self.btn = [[UIButton alloc] initWithFrame:CGRectMake(60, 120, 50, 50)];
    self.btn.backgroundColor = [UIColor colorWithRed:0.3 green:0.0 blue:0.6 alpha:0.9];
    self.btn.layer.cornerRadius = 25;
    self.btn.layer.borderWidth = 2;
    self.btn.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.btn setTitle:@"𝔳" forState:UIControlStateNormal];
    [self.btn addTarget:self action:@selector(toggle) forControlEvents:UIControlEventTouchUpInside];
    [self.btn addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panB:)]];
    [self addSubview:self.btn];

    self.menu = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 280, 460)];
    self.menu.center = self.center;
    self.menu.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.95];
    self.menu.layer.cornerRadius = 20;
    self.menu.layer.borderColor = [UIColor systemPurpleColor].CGColor;
    self.menu.layer.borderWidth = 2;
    self.menu.alpha = 0;
    self.menu.hidden = YES;
    self.menu.contentSize = CGSizeMake(280, 750);

    self.header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 280, 50)];
    self.header.backgroundColor = [UIColor systemPurpleColor];
    UILabel *t = [[UILabel alloc] initWithFrame:self.header.bounds];
    t.text = @"VOIDSTRAP KHOINDVN";
    t.textAlignment = NSTextAlignmentCenter; t.textColor = [UIColor whiteColor];
    t.font = [UIFont boldSystemFontOfSize:14];
    [self.header addSubview:t];
    [self.header addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panM:)]];
    [self.menu addSubview:self.header];

    // --- 15 OPTIMIZATION TOOLS ---
    CGFloat sY = 65;
    [self addOpt:@"Zero Ping (Network)" y:sY sel:@selector(c1:)];
    [self addOpt:@"Packet Priority" y:sY+35 sel:@selector(c2:)];
    [self addOpt:@"Strict No Textures" y:sY+70 sel:@selector(c3:)];
    [self addOpt:@"Bypass Post-FX" y:sY+105 sel:@selector(c4:)];
    [self addOpt:@"Engine FPS Unlock" y:sY+140 sel:@selector(c5:)];
    [self addOpt:@"Disable Particles" y:sY+175 sel:@selector(c6:)];
    [self addOpt:@"GPU Acceleration" y:sY+210 sel:@selector(c7:)];
    [self addOpt:@"Memory Purge" y:sY+245 sel:@selector(c8:)];
    [self addOpt:@"Low-Res Render" y:sY+280 sel:@selector(c9:)];
    [self addOpt:@"Kill All Shadows" y:sY+315 sel:@selector(c10:)];
    [self addOpt:@"Skip Asset Load" y:sY+350 sel:@selector(c11:)];
    [self addOpt:@"Minimal Mesh" y:sY+385 sel:@selector(c12:)];
    [self addOpt:@"No Skybox" y:sY+420 sel:@selector(c13:)];
    [self addOpt:@"Aggressive GC" y:sY+455 sel:@selector(c14:)];
    [self addOpt:@"Turbo Network" y:sY+490 sel:@selector(c15:)];

    [self addSubview:self.menu];
}

// LOGIC (Ping & Performance Focused)
- (void)c1:(UISwitch *)s { [self applyFlag:@"FIntNetworkMaxPort" v:s.isOn ? @1 : @0]; }
- (void)c2:(UISwitch *)s { [self applyFlag:@"FIntClientNetPriority" v:s.isOn ? @1 : @0]; }
- (void)c3:(UISwitch *)s { [self applyFlag:@"DFFlagDebugDisableOptimizedTextureTarget" v:s.isOn ? @"True" : @"False"]; [self applyFlag:@"FIntRenderTextureCompositor" v:s.isOn ? @0 : @1]; }
- (void)c4:(UISwitch *)s { [self applyFlag:@"FFlagDisablePostProcess" v:s.isOn ? @"True" : @"False"]; }
- (void)c5:(UISwitch *)s { [self applyFlag:@"DFIntTaskSchedulerTargetFps" v:s.isOn ? @999 : @60]; }
- (void)c6:(UISwitch *)s { [self applyFlag:@"FIntParticleMaxCount" v:s.isOn ? @0 : @1000]; }
- (void)c7:(UISwitch *)s { [self applyFlag:@"FFlagDebugForceMetal" v:s.isOn ? @"True" : @"False"]; }
- (void)c8:(UISwitch *)s { [self applyFlag:@"FIntDebugForceGC" v:s.isOn ? @1 : @0]; }
- (void)c9:(UISwitch *)s { [self applyFlag:@"FIntDebugImageSlowerResolution" v:s.isOn ? @1 : @0]; }
- (void)c10:(UISwitch *)s { [self applyFlag:@"FIntRenderShadowIntensity" v:s.isOn ? @0 : @1]; }
- (void)c11:(UISwitch *)s { [self applyFlag:@"FFlagPreloadAllModels" v:s.isOn ? @"True" : @"False"]; }
- (void)c12:(UISwitch *)s { [self applyFlag:@"FIntRenderMeshLOD" v:s.isOn ? @0 : @100]; }
- (void)c13:(UISwitch *)s { [self applyFlag:@"FFlagDebugDisableSkybox" v:s.isOn ? @"True" : @"False"]; }
- (void)c14:(UISwitch *)s { [self applyFlag:@"FIntMainLoopPriority" v:s.isOn ? @2 : @0]; }
- (void)c15:(UISwitch *)s { [self applyFlag:@"FFlagNetworkSendGlobalPacket" v:s.isOn ? @"False" : @"True"]; }

- (void)toggle { BOOL s = (self.menu.alpha == 0); if(s) self.menu.hidden = NO; [UIView animateWithDuration:0.2 animations:^{ self.menu.alpha = s ? 1:0; } completion:^(BOOL f){ if(!s) self.menu.hidden=YES; }]; }
- (void)panB:(UIPanGestureRecognizer *)p { self.btn.center = [p locationInView:self]; }
- (void)panM:(UIPanGestureRecognizer *)p { CGPoint t = [p translationInView:self]; self.menu.center = CGPointMake(self.menu.center.x+t.x, self.menu.center.y+t.y); [p setTranslation:CGPointZero inView:self]; }
- (UIView *)hitTest:(CGPoint)p withEvent:(UIEvent *)e { UIView *h = [super hitTest:p withEvent:e]; return (h==self) ? nil:h; }
@end

__attribute__((constructor)) static void init() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        UIWindow *w = nil;
        for (UIWindowScene *s in [UIApplication sharedApplication].connectedScenes) { if (s.activationState == UISceneActivationStateForegroundActive) { w = s.windows.firstObject; break; } }
        if(!w) w = [UIApplication sharedApplication].windows.firstObject;
        VoidstrapMenu *v = [[VoidstrapMenu alloc] initWithFrame:w.bounds];
        v.layer.zPosition = 9999; [w addSubview:v];
    });
}
