#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>

@interface VoidstrapMenu : UIView
@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, strong) UIScrollView *menu;
@end

@implementation VoidstrapMenu

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Essential: Allow the view to catch taps for the button/menu
        self.userInteractionEnabled = YES; 
        self.backgroundColor = [UIColor clearColor];
        [self setupUI];
    }
    return self;
}

// Logic to write FastFlags to Roblox Library
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
    l.font = [UIFont fontWithName:@"Courier-Bold" size:12];
    [self.menu addSubview:l];

    UISwitch *sw = [[UISwitch alloc] initWithFrame:CGRectMake(185, y, 0, 0)];
    sw.onTintColor = [UIColor systemPurpleColor];
    sw.transform = CGAffineTransformMakeScale(0.75, 0.75);
    [sw addTarget:self action:s forControlEvents:UIControlEventValueChanged];
    [self.menu addSubview:sw];
}

- (void)setupUI {
    // 1. The Circle Button (𝔳)
    self.btn = [[UIButton alloc] initWithFrame:CGRectMake(50, 100, 55, 55)];
    self.btn.backgroundColor = [UIColor colorWithRed:0.3 green:0.0 blue:0.6 alpha:0.9];
    self.btn.layer.cornerRadius = 27.5;
    self.btn.layer.borderWidth = 1.5;
    self.btn.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.btn setTitle:@"𝔳" forState:UIControlStateNormal];
    self.btn.titleLabel.font = [UIFont systemFontOfSize:26 weight:UIFontWeightBold];
    
    // Use both TouchUpInside and a dedicated action
    [self.btn addTarget:self action:@selector(toggleMenu) forControlEvents:UIControlEventTouchUpInside];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.btn addGestureRecognizer:pan];
    [self addSubview:self.btn];

    // 2. The Menu Panel
    self.menu = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 260, 380)];
    self.menu.center = CGPointMake(UIScreen.mainScreen.bounds.size.width/2, UIScreen.mainScreen.bounds.size.height/2);
    self.menu.backgroundColor = [UIColor colorWithRed:0.02 green:0.02 blue:0.04 alpha:0.98];
    self.menu.layer.cornerRadius = 20;
    self.menu.layer.borderColor = [UIColor systemPurpleColor].CGColor;
    self.menu.layer.borderWidth = 2;
    self.menu.alpha = 0; // Starts hidden
    self.menu.hidden = YES;
    self.menu.contentSize = CGSizeMake(260, 500);

    UILabel *h = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, 260, 30)];
    h.text = @"VOIDSTRAP MOBILE";
    h.textAlignment = NSTextAlignmentCenter;
    h.textColor = [UIColor systemPurpleColor];
    h.font = [UIFont fontWithName:@"Courier-Bold" size:18];
    [self.menu addSubview:h];

    // --- 9 LAG REDUCTION SETTINGS ---
    [self addOpt:@"Unlock 999 FPS" y:60 sel:@selector(f1:)];
    [self addOpt:@"No Textures" y:100 sel:@selector(f2:)];
    [self addOpt:@"Kill Shadows" y:140 sel:@selector(f3:)];
    [self addOpt:@"Potato Quality" y:180 sel:@selector(f4:)];
    [self addOpt:@"Disable Blur" y:220 sel:@selector(f5:)];
    [self addOpt:@"No Grass/Deco" y:260 sel:@selector(f6:)];
    [self addOpt:@"Force Metal" y:300 sel:@selector(f7:)];
    [self addOpt:@"Anti-Aliasing Off" y:340 sel:@selector(f8:)];
    [self addOpt:@"Fast Load" y:380 sel:@selector(f9:)];

    UIButton *save = [UIButton buttonWithType:UIButtonTypeSystem];
    save.frame = CGRectMake(30, 430, 200, 40);
    save.backgroundColor = [UIColor systemPurpleColor];
    [save setTitle:@"SAVE & CLOSE" forState:UIControlStateNormal];
    [save setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    save.layer.cornerRadius = 10;
    [save addTarget:self action:@selector(toggleMenu) forControlEvents:UIControlEventTouchUpInside];
    [self.menu addSubview:save];

    [self addSubview:self.menu];
}

- (void)toggleMenu {
    BOOL isHidden = (self.menu.alpha == 0);
    self.menu.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.menu.alpha = isHidden ? 1.0 : 0.0;
    } completion:^(BOOL finished) {
        if (!isHidden) self.menu.hidden = YES;
    }];
}

- (void)handlePan:(UIPanGestureRecognizer *)p {
    self.btn.center = [p locationInView:self];
}

// 9 FAST FLAGS
- (void)f1:(UISwitch *)s { [self setFlag:@"DFIntTaskSchedulerTargetFps" v:s.isOn ? @999 : @60]; }
- (void)f2:(UISwitch *)s { [self setFlag:@"DFFlagDebugDisableOptimizedTextureTarget" v:s.isOn ? @"True" : @"False"]; }
- (void)f3:(UISwitch *)s { [self setFlag:@"FIntRenderShadowIntensity" v:s.isOn ? @0 : @1]; }
- (void)f4:(UISwitch *)s { [self setFlag:@"FIntDebugForceRenderQuality" v:s.isOn ? @1 : @0]; }
- (void)f5:(UISwitch *)s { [self setFlag:@"FFlagDisablePostProcess" v:s.isOn ? @"True" : @"False"]; }
- (void)f6:(UISwitch *)s { [self setFlag:@"FIntRenderTerrainDecorationPath" v:s.isOn ? @0 : @1]; }
- (void)f7:(UISwitch *)s { [self setFlag:@"FFlagDebugForceMetal" v:s.isOn ? @"True" : @"False"]; }
- (void)f8:(UISwitch *)s { [self setFlag:@"FIntMsaaSampleCount" v:s.isOn ? @0 : @4]; }
- (void)f9:(UISwitch *)s { [self setFlag:@"FIntFFlagBootstrapperReloadPolicy" v:s.isOn ? @0 : @1]; }

// CRITICAL: Pass taps through to the game unless we hit the UI
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *hit = [super hitTest:point withEvent:event];
    if (hit == self) return nil;
    return hit;
}
@end

__attribute__((constructor)) static void init() {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        UIWindow *window = nil;
        for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes) {
            if (scene.activationState == UISceneActivationStateForegroundActive) {
                window = scene.windows.firstObject;
                break;
            }
        }
        if (!window) window = [UIApplication sharedApplication].windows.firstObject;
        
        VoidstrapMenu *v = [[VoidstrapMenu alloc] initWithFrame:window.bounds];
        v.layer.zPosition = 9999;
        [window addSubview:v];
    });
}
