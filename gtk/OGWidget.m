#include "OGWidget.h"

void og_destroy(GtkWidget *widget, OGWidget *object)
{
	[object release];
}

@implementation OGWidget
- init
{
	self = [super init];

	@try {
		if (isa == [OGWidget class])
			@throw [OFNotImplementedException
			    exceptionWithClass: isa
				      selector: @selector(init)];
	} @catch (id e) {
		[self release];
		@throw e;
	}

	return self;
}

- (void)show
{
	gtk_widget_show_all(widget);
}

- (void)hide
{
	gtk_widget_hide(widget);
}
@end
