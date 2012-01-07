/*
 * Copyright (c) 2011, 2012, Jonathan Schleifer <js@webkeks.org>
 *
 * https://webkeks.org/hg/objgui/
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

#include <gtk/gtk.h>

#import "OGApplication.h"

OF_APPLICATION_DELEGATE(OGApplication)

extern Class og_application_delegate(void);

@implementation OGApplication
+ (void)quit
{
	gtk_main_quit();
}

- (void)applicationDidFinishLaunching
{
	OFAutoreleasePool *pool;
	int *argc;
	char ***argv;

	delegate = [[og_application_delegate() alloc] init];

	[[OFApplication sharedApplication] getArgumentCount: &argc
					  andArgumentValues: &argv];
	gtk_init(argc, argv);

	pool = [OFAutoreleasePool new];
	[delegate applicationDidFinishLaunching];
	[pool release];

	gtk_main();
}

- (void)applicationWillTerminate
{
	[delegate applicationWillTerminate];
}
@end
