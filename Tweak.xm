#include <notify.h>

@interface NSObject (SBIcon)
@property (nonatomic) NSString *applicationBundleID;
@end


%hook SBIconView
-(void)layoutSubviews{
	%orig;
	UIView *_closeBox = MSHookIvar<UIView *>(self, "_closeBox");
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    tapGesture.numberOfTapsRequired = 2;
    [_closeBox addGestureRecognizer:tapGesture];
    [tapGesture release];
}
%new
- (void)handleTapGesture:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateRecognized) {
    	BOOL changed = NO;
		void* libHide = dlopen("/usr/lib/hide.dylib", RTLD_LAZY);
		UIView *&_icon(MSHookIvar<UIView *>(self, "_icon"));
		if (libHide != NULL) {
			BOOL (*Hider)(NSString*) = (BOOL (*)(NSString*)) dlsym(libHide, "HideIconViaDisplayId");

			if (Hider != NULL) {
				changed = Hider(_icon.applicationBundleID);
			}
			dlclose(libHide);
		}

		if(changed == YES) {
		    notify_post("com.libhide.hiddeniconschanged");
		}
    }
}
%end


%ctor {
		%init
}
