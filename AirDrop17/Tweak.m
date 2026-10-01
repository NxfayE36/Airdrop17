#import <UIKit/UIKit.h>

static UIView *ad17Overlay;
static UIView *ad17Card;
static UILabel *ad17Title;
static UILabel *ad17Subtitle;

static void AD17Remove(void) {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!ad17Overlay) return;
        [UIView animateWithDuration:0.2 animations:^{
            ad17Overlay.alpha = 0;
            ad17Card.transform = CGAffineTransformMakeScale(.92,.92);
        } completion:^(BOOL done){
            [ad17Overlay removeFromSuperview];
            ad17Overlay=nil; ad17Card=nil; ad17Title=nil; ad17Subtitle=nil;
        }];
    });
}

static void AD17Show(void) {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (ad17Overlay) return;
        UIWindow *window=nil;
        for (UIScene *scene in UIApplication.sharedApplication.connectedScenes) {
            if (scene.activationState == UISceneActivationStateUnattached) continue;
            for (UIWindow *w in scene.windows) if (w.isKeyWindow) { window=w; break; }
            if (window) break;
        }
        if (!window) return;
        CGFloat width=MIN(window.bounds.size.width-28,390);
        CGFloat top=window.safeAreaInsets.top+8;
        ad17Overlay=[[UIView alloc] initWithFrame:window.bounds];
        ad17Overlay.backgroundColor=UIColor.clearColor;
        ad17Overlay.userInteractionEnabled=NO;
        ad17Overlay.alpha=0;
        [window addSubview:ad17Overlay];
        ad17Card=[[UIView alloc] initWithFrame:CGRectMake((window.bounds.size.width-width)/2,top,width,104)];
        ad17Card.layer.cornerRadius=30;
        ad17Card.layer.masksToBounds=YES;
        ad17Card.transform=CGAffineTransformMakeScale(.92,.92);
        [ad17Overlay addSubview:ad17Card];
        UIVisualEffectView *glass=[[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemChromeMaterialDark]];
        glass.frame=ad17Card.bounds; glass.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [ad17Card addSubview:glass];
        UIImageSymbolConfiguration *cfg=[UIImageSymbolConfiguration configurationWithPointSize:30 weight:UIImageSymbolWeightMedium];
        UIImageView *icon=[[UIImageView alloc] initWithImage:[UIImage systemImageNamed:@"airplay" withConfiguration:cfg]];
        icon.tintColor=UIColor.whiteColor; icon.frame=CGRectMake(18,20,48,48); icon.contentMode=UIViewContentModeScaleAspectFit;
        [ad17Card addSubview:icon];
        ad17Title=[[UILabel alloc] initWithFrame:CGRectMake(78,18,width-94,30)];
        ad17Title.text=@"AirDrop"; ad17Title.textColor=UIColor.whiteColor; ad17Title.font=[UIFont systemFontOfSize:20 weight:UIFontWeightSemibold];
        [ad17Card addSubview:ad17Title];
        ad17Subtitle=[[UILabel alloc] initWithFrame:CGRectMake(78,50,width-94,25)];
        ad17Subtitle.text=@"Bring devices close together"; ad17Subtitle.textColor=[UIColor colorWithWhite:1 alpha:.7]; ad17Subtitle.font=[UIFont systemFontOfSize:14];
        [ad17Card addSubview:ad17Subtitle];
        for (NSInteger i=0;i<3;i++) {
            UIView *dot=[[UIView alloc] initWithFrame:CGRectMake(width-66+i*11,20,5,5)];
            dot.tag=1700+i; dot.layer.cornerRadius=2.5; dot.backgroundColor=[UIColor colorWithWhite:1 alpha:.8]; [ad17Card addSubview:dot];
        }
        [UIView animateWithDuration:.34 delay:0 usingSpringWithDamping:.78 initialSpringVelocity:.5 options:UIViewAnimationOptionCurveEaseOut animations:^{ ad17Overlay.alpha=1; ad17Card.transform=CGAffineTransformIdentity; } completion:nil];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,(int64_t)(.15*NSEC_PER_SEC)),dispatch_get_main_queue(),^{
            if (!ad17Card) return;
            [UIView animateWithDuration:.7 delay:0 options:UIViewAnimationOptionAutoreverse|UIViewAnimationOptionRepeat animations:^{
                for (NSInteger i=0;i<3;i++){ UIView *d=[ad17Card viewWithTag:1700+i]; d.alpha=.25+.2*i; d.transform=CGAffineTransformMakeScale(1.35,1.35); }
            } completion:nil];
        });
    });
}

%hook UIActivityViewController
- (void)viewDidAppear:(BOOL)animated {
    %orig;
    // Visual-only trigger: when a share sheet appears, the native iOS 16 AirDrop
    // option remains underneath. This avoids replacing Apple's transport layer.
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,(int64_t)(.12*NSEC_PER_SEC)),dispatch_get_main_queue(),^{ AD17Show(); });
}
- (void)viewDidDisappear:(BOOL)animated { %orig; AD17Remove(); }
%end

%ctor { NSLog(@"[AirDrop17] loaded"); }
