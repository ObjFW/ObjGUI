#import "OGApplication.h"

OF_APPLICATION_DELEGATE(OGApplication)

extern Class og_application_delegate(void);

@implementation OGApplication
+ (void)quit
{
	gtk_main_quit();
}

- (void)applicationDidFinishLaunching
{
	OFAutoreleasePool *pool;
	int *argc;
	char ***argv;

	delegate = [[og_application_delegate() alloc] init];

	[[OFApplication sharedApplication] getArgumentCount: &argc
					  andArgumentValues: &argv];
	gtk_init(argc, argv);

	pool = [OFAutoreleasePool new];
	[delegate applicationDidFinishLaunching];
	[pool release];

	gtk_main();
}

- (void)applicationWillTerminate
{
	[delegate applicationWillTerminate];
}
@end
