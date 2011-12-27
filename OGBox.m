#import "OGBox.h"

@implementation OGBox
+ box
{
	return [[[self alloc] init] autorelease];
}

- init
{
	self = [super init];

	@try {
		if (isa == [OGBox class])
			@throw [OFNotImplementedException
			    exceptionWithClass: isa
				      selector: _cmd];
	} @catch (id e) {
		[self release];
		@throw e;
	}

	return self;
}

- (void)appendChild: (OGWidget*)child
	     expand: (BOOL)expand
	       fill: (BOOL)fill
	    padding: (float)padding
{
	gtk_box_pack_start(GTK_BOX(widget), child->widget, expand, fill,
	    padding);
}

- (void)prependChild: (OGWidget*)child
	      expand: (BOOL)expand
		fill: (BOOL)fill
	     padding: (float)padding
{
	gtk_box_pack_end(GTK_BOX(widget), child->widget, expand, fill, padding);
}
@end
