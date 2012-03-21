/*
 * Copyright (c) 2011, 2012, Jonathan Schleifer <js@webkeks.org>
 *
 * https://webkeks.org/git/?p=objgui.git
 *
 * Permission to use, copy, modify, and/or distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice is present in all copies.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */

#import "OGWindow.h"

@interface OGWindow ()
- (BOOL)OG_willClose;
@end

static gboolean
willClose(GtkWidget *widget, GdkEvent *event, gpointer data)
{
	return ([(OGWindow*)data OG_willClose] ? FALSE : TRUE);
}

@implementation OGWindow
@synthesize delegate;

+ window
{
	return [[[self alloc] init] autorelease];
}

- init
{
	self = [super init];

	widget = gtk_window_new(GTK_WINDOW_TOPLEVEL);
	g_signal_connect(G_OBJECT(widget), "delete-event",
	    G_CALLBACK(willClose), self);

	g_signal_connect(G_OBJECT(widget), "destroy", G_CALLBACK(og_destroy),
	    self);
	[self retain];

	return self;
}

- (OFString*)title
{
	return [OFString stringWithUTF8String:
	    gtk_window_get_title(GTK_WINDOW(widget))];
}

- (void)setTitle: (OFString*)title
{
	gtk_window_set_title(GTK_WINDOW(widget), [title UTF8String]);
}

- (of_point_t)position
{
	gint x, y;

	gtk_window_get_position(GTK_WINDOW(widget), &x, &y);

	return of_point(x, y);
}

- (void)setPosition: (of_point_t)position
{
	gtk_window_move(GTK_WINDOW(widget), position.x, position.y);
}

- (of_dimension_t)dimension
{
	gint width, height;

	gtk_window_get_size(GTK_WINDOW(widget), &width, &height);

	return of_dimension(width, height);
}

- (void)setDimension: (of_dimension_t)dimension
{
	gtk_window_resize(GTK_WINDOW(widget),
	    dimension.width, dimension.height);
}

- (void)addChild: (OGWidget*)child
{
	gtk_container_add(GTK_CONTAINER(widget), child->widget);
}

- (void)show
{
	gtk_widget_show_all(widget);
}

- (BOOL)OG_willClose
{
	OFAutoreleasePool *pool = [OFAutoreleasePool new];

	if ([delegate respondsToSelector: @selector(windowWillClose:)])
		return [delegate windowWillClose: self];

	[pool release];

	return YES;
}
@end
