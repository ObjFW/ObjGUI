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
