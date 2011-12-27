#include <gtk/gtk.h>

#import <ObjFW/ObjFW.h>

@interface OGWidget: OFObject
{
@public
	GtkWidget *widget;
}

- (void)show;
- (void)hide;
@end

extern void og_destroy(GtkWidget*, OGWidget*);
