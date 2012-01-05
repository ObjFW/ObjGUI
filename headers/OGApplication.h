#import <ObjFW/ObjFW.h>

@protocol OGApplicationDelegate <OFObject>
- (void)applicationDidFinishLaunching;
@optional
- (void)applicationWillTerminate;
@end

@interface OGApplication: OFObject <OFApplicationDelegate>
{
	id <OFApplicationDelegate> delegate;
}

+ (void)quit;
@end

#define OG_APPLICATION_DELEGATE(cls)	\
	Class				\
	og_application_delegate() {	\
		return [cls class];	\
	}
