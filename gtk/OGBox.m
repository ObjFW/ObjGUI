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
