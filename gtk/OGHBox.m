#import "OGHBox.h"

@implementation OGHBox
- init
{
	self = [super init];

	widget = gtk_hbox_new(FALSE, 0);

	g_signal_connect(G_OBJECT(widget), "destroy", G_CALLBACK(og_destroy),
	    self);
	[self retain];

	return self;
}
@end
