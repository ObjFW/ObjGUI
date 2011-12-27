#import "OGVBox.h"

@implementation OGVBox
- init
{
	self = [super init];

	widget = gtk_vbox_new(FALSE, 0);

	g_signal_connect(G_OBJECT(widget), "destroy", G_CALLBACK(og_destroy),
	    self);
	[self retain];

	return self;
}
@end
