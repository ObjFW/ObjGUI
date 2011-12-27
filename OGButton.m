#import "OGButton.h"

@interface OGButton ()
- (void)OG_clicked;
@end

static void
clicked(GtkWidget *widget, gpointer data)
{
	[(OGButton*)data OG_clicked];
}

@implementation OGButton
@synthesize delegate;

+ button
{
	return [[[self alloc] init] autorelease];
}

- init
{
	self = [super init];

	widget = gtk_button_new();
	g_signal_connect(G_OBJECT(widget), "clicked", G_CALLBACK(clicked),
	    self);

	g_signal_connect(G_OBJECT(widget), "destroy", G_CALLBACK(og_destroy),
	    self);
	[self retain];

	return self;
}

- (OFString*)label
{
	return [OFString stringWithUTF8String:
	    gtk_button_get_label(GTK_BUTTON(widget))];
}

- (void)setLabel: (OFString*)label
{
	gtk_button_set_label(GTK_BUTTON(widget), [label UTF8String]);
}

- (void)OG_clicked
{
	OFAutoreleasePool *pool = [OFAutoreleasePool new];

	if ([delegate respondsToSelector: @selector(buttonWasClicked:)])
	      [delegate buttonWasClicked: self];

	[pool release];
}
@end
