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

#import "OGApplication.h"
#import "OGWindow.h"
#import "OGButton.h"
#import "OGHBox.h"
#import "OGVBox.h"

@interface Test: OFObject <OGApplicationDelegate, OGWindowDelegate,
    OGButtonDelegate>
@end

OG_APPLICATION_DELEGATE(Test)

@implementation Test
- (void)applicationDidFinishLaunching
{
	OGWindow *w = [OGWindow window];
	w.title = @"Hallo Welt!";
	w.position = of_point(100, 100);
	w.dimension = of_dimension(600, 400);
	w.delegate = self;

	OGVBox *vbox = [OGVBox box];
	[w addChild: vbox];

	OGButton *b = [OGButton button];
	b.label = @"Klick mich!";
	b.delegate = self;
	[vbox appendChild: b
		   expand: YES
		     fill: YES
		  padding: 0];

	OGHBox *hbox = [OGHBox box];
	[vbox appendChild: hbox
		   expand: NO
		     fill: NO
		  padding: 0];

	OGButton *b1 = [OGButton button];
	b1.label = @"Ich";
	[hbox appendChild: b1
		   expand: YES
		     fill: YES
		  padding: 0];

	OGButton *b2 = [OGButton button];
	b2.label = @"mach";
	[hbox appendChild: b2
		   expand: YES
		     fill: YES
		  padding: 0];

	OGButton *b3 = [OGButton button];
	b3.label = @"nix";
	[hbox appendChild: b3
		   expand: YES
		     fill: YES
		  padding: 0];

	[w show];
}

- (BOOL)windowWillClose: (OGWindow*)window
{
	[OGApplication quit];

	return YES;
}

- (void)buttonWasClicked: (OGButton*)button
{
	of_log(@"Hallo!");
}
@end
