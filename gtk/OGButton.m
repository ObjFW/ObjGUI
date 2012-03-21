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
