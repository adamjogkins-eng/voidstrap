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
    }
    return self;
}

// DIRECT DECRYPTED BUNDLE OVERRIDE
- (void)applyFlag:(NSString *)k v:(id)v {
    NSFileManager *fm = [NSFileManager defaultManager];
    
    // Path 1: The Decrypted App Bundle (Highest Priority)
    NSString *bundlePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"ClientSettings"];
    // Path 2: The Data Sandbox (Backup)
    NSString *libPath = [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"ClientSettings"];

    NSArray *paths = @[bundlePath, libPath];

    for (NSString *path in paths) {
        if (![fm fileExistsAtPath:path]) {
            [fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        NSString *file = [path stringByAppendingPathComponent:@"ClientAppSettings.json"];
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        
        if ([fm fileExistsAtPath:file]) {
            NSData *data = [NSData dataWithContentsOfFile:file];
            dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil] ?: [NSMutableDictionary dictionary];
        }

        dict[k] = v;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
        [jsonData writeToFile:file atomically:YES];
    }
    
    // Haptic Feedback
    UISelectionFeedbackGenerator *gen = [[UISelectionFeedbackGenerator alloc] init];
    [gen selectionChanged];
}

- (void)addOpt:(NSString *)txt y:(CGFloat)y sel:(SEL)s {
    UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(20, y, 170, 30)];
    l.text = [txt uppercaseString];
    l.textColor = [UIColor whiteColor];
    l.font = [UIFont fontWithName:@"Courier-Bold" size:11];
    [self.menu addSubview:l];

    UISwitch *sw = [[UISwitch alloc] initWithFrame:CGRectMake(195, y, 0, 0)];
    sw.onTintColor = [UIColor systemPurpleColor];
    sw.transform = CGAffineTransformMakeScale(0.7, 0.7);
    [sw addTarget:self action:s forControlEvents:UIControlEventValueChanged];
    [self.menu addSubview:sw];
}

- (void)setupUI {
    // Draggable Circle Button
    self.btn = [[UIButton alloc] initWithFrame:CGRectMake(50, 100, 55, 55)];
    self.btn.backgroundColor = [UIColor colorWithRed:0.2 green:0.0 blue:0.4 alpha:0.9];
    self.btn.layer.cornerRadius = 27.5;
    [self.btn setTitle:@"𝔳" forState:UIControlStateNormal];
    [self.btn addTarget:self action:@selector(toggle) forControlEvents:UIControlEventTouchUpInside];
    [self.btn addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panB:)]];
    [self addSubview:self.btn];

    // Draggable Main Panel
    self.menu = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 275, 450)];
    self.menu.center = CGPointMake(UIScreen.mainScreen.bounds.size.width/2, UIScreen.mainScreen.bounds.size.height/2);
    self.menu.backgroundColor = [UIColor colorWithWhite:0.02 alpha:0.98];
    self.menu.layer.cornerRadius = 15;
    self.menu.layer.borderColor = [UIColor systemPurpleColor].CGColor;
    self.menu.layer.borderWidth = 2;
    self.menu.alpha = 0;
    self.menu.hidden = YES;
    self.menu.contentSize = CGSizeMake(275, 750);

    // Header (The Drag Handle)
    self.header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 275, 45)];
    self.header.backgroundColor = [UIColor colorWithRed:0.1 green:0.0 blue:0.2 alpha:1.0];
    UILabel *hL = [[UILabel alloc] initWithFrame:self.header.bounds];
    hL.text = @"VOIDSTRAP BYPASS V6";
    hL.textAlignment = NSTextAlignmentCenter; hL.textColor = [UIColor whiteColor];
    hL.font = [UIFont boldSystemFontOfSize:14];
    [self.header addSubview:hL];
    [self.header addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panM:)]];
    [self.menu addSubview:self.header];

    // 15 PING & PERFORMANCE COMMANDS
    CGFloat sY = 60;
    [self addOpt:@"Zero Ping Mode" y:sY sel:@selector(v1:)];
    [self addOpt:@"Priority Data" y:sY+35 sel:@selector(v2:)];
    [self addOpt:@"Force No Textures" y:sY+70 sel:@selector(v3:)];
    [self addOpt:@"Potato Graphics" y:sY+105 sel:@selector(v4:)];
    [self addOpt:@"Uncap 999 FPS" y:sY+140 sel:@selector(v5:)];
    [self addOpt:@"Kill Shadows" y:sY+175 sel:@selector(v6:)];
    [self addOpt:@"No Post-Process" y:sY+210 sel:@selector(v7:)];
    [self addOpt:@"GPU Metal Turbo" y:sY+245 sel:@selector(v8:)];
    [self addOpt:@"Kill Particles" y:sY+280 sel:@selector(v9:)];
    [self addOpt:@"Aggressive RAM GC" y:sY+315 sel:@selector(v10:)];
    [self addOpt:@"Low Resolution" y:sY+350 sel:@selector(v11:)];
    [self addOpt:@"No Skybox" y:sY+385 sel:@selector(v12:)];
    [self addOpt:@"Fast Content Load" y:sY+420 sel:@selector(v13:)];
    [self addOpt:@"Min Mesh Detail" y:sY+455 sel:@selector(v14:)];
    [self addOpt:@"Bypass Latency" y:sY+490 sel:@selector(v15:)];

    [self addSubview:self.menu];
}

// HANDLERS
- (void)v1:(UISwitch *)s { [self applyFlag:@"FIntNetworkMaxPort" v:s.isOn ? @1 : @0]; }
- (void)v2:(UISwitch *)s { [self applyFlag:@"FIntClientNetPriority" v:s.isOn ? @1 : @0]; }
- (void)v3:(UISwitch *)s { [self applyFlag:@"DFFlagDebugDisableOptimizedTextureTarget" v:s.isOn ? @"True" : @"False"]; [self applyFlag:@"FIntRenderTextureCompositor" v:s.isOn ? @0 : @1]; }
- (void)v4:(UISwitch *)s { [self applyFlag:@"FIntDebugForceRenderQuality" v:s.isOn ? @1 : @0]; }
- (void)v5:(UISwitch *)s { [self applyFlag:@"DFIntTaskSchedulerTargetFps" v:s.isOn ? @999 : @60]; }
- (void)v6:(UISwitch *)s { [self applyFlag:@"FIntRenderShadowIntensity" v:s.isOn ? @0 : @1]; }
- (void)v7:(UISwitch *)s { [self applyFlag:@"FFlagDisablePostProcess" v:s.isOn ? @"True" : @"False"]; }
- (void)v8:(UISwitch *)s { [self applyFlag:@"FFlagDebugForceMetal" v:s.isOn ? @"True" : @"False"]; }
- (void)v9:(UISwitch *)s { [self applyFlag:@"FIntParticleMaxCount" v:s.isOn ? @0 : @1000]; }
- (void)v10:(UISwitch *)s { [self applyFlag:@"FIntDebugForceGC" v:s.isOn ? @1 : @0]; }
- (void)v11:(UISwitch *)s { [self applyFlag:@"FIntDebugImageSlowerResolution" v:s.isOn ? @1 : @0]; }
- (void)v12:(UISwitch *)s { [self applyFlag:@"FFlagDebugDisableSkybox" v:s.isOn ? @"True" : @"False"]; }
- (void)v13:(UISwitch *)s { [self applyFlag:@"FFlagPreloadAllModels" v:s.isOn ? @"True" : @"False"]; }
- (void)v14:(UISwitch *)s { [self applyFlag:@"FIntRenderMeshLOD" v:s.isOn ? @0 : @100]; }
- (void)v15:(UISwitch *)s { [self applyFlag:@"FFlagNetworkSendGlobalPacket" v:s.isOn ? @"False" : @"True"]; }

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
