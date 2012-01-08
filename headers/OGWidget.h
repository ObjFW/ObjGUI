/*
 * Copyright (c) 2011, 2012, Jonathan Schleifer <js@webkeks.org>
 * Copyright (c) 2011, 2012, Dillon Aumiller <dillonaumiller@gmail.com>
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

#if defined(OG_GTK)
# include <gtk/gtk.h>
#elif defined(OG_WIN32)
# include <windows.h>
#endif

#import <ObjFW/ObjFW.h>

@interface OGWidget: OFObject
{
@public
#if defined(OG_GTK)
	GtkWidget *widget;
#elif defined(OG_WIN32)
	HWND widget;
#endif
}
@end

#if defined(OG_GTK)
extern void og_destroy(GtkWidget*, OGWidget*);
#elif defined(OG_WIN32)
extern void og_destroy(HWND widget, OGWidget *object);
#endif
