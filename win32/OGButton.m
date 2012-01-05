/*
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

//==================================================================================================================================
// OGButton.m
//==================================================================================================================================
#define BCM_GETIDEALSIZE 0x1601
#import "OGButton.h"
//==================================================================================================================================
@interface OGButton ()
- (void)OG_clicked;
@end
//==================================================================================================================================
typedef void(*CommandHandler)(id,WPARAM);
typedef struct
{
  CommandHandler funct;
  id             object;
} CommandHandlerData;
//----------------------------------------------------------------------------------------------------------------------------------
static void CH_Command(id object, WPARAM wparam)
{
  [object OG_clicked];
}
//==================================================================================================================================
@implementation OGButton
//----------------------------------------------------------------------------------------------------------------------------------
@synthesize delegate;
//----------------------------------------------------------------------------------------------------------------------------------
+ button
{
  return [[[self alloc] init] autorelease];
}
//----------------------------------------------------------------------------------------------------------------------------------
- init
{
  self = [super init];

  //we're specifying a different class name...
  //so we'll have to discard the default OGWidget HWND...
  DestroyWindow(widget);
  //and create a new one
  widget = NULL;
  HINSTANCE hInst = (HINSTANCE)GetModuleHandle(NULL);
  widget = CreateWindow("button", "", BS_PUSHBUTTON,
                          CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT,
                          NULL, NULL, hInst, NULL);
  SetWindowLong(widget, GWL_STYLE, BS_PUSHBUTTON | WS_CHILD | WS_VISIBLE | WS_TABSTOP);
  //crazy workaround since we don't have control of our WNDPROC for default "button"s
  CommandHandlerData *chd = (CommandHandlerData *)malloc(sizeof(CommandHandlerData));
  chd->funct  = CH_Command;
  chd->object = self;
  //and another workaround because "button" class seems to mess with our GWL_USERDATA storage...
  //SetWindowLong(widget, GWL_USERDATA, (UINT)(chd));
  SetProp(widget, "CommandHandlerData", chd);

  [self retain];
  return self;
}
//----------------------------------------------------------------------------------------------------------------------------------
- (OFString*)label
{
  int tlen = GetWindowTextLength(widget);
  char *buff = (char *)malloc(tlen + 1);
  GetWindowText(widget, buff, tlen+1);

  OFString *ret = [OFString stringWithUTF8String : buff];
  free(buff);
  return ret;
}
//----------------------------------------------------------------------------------------------------------------------------------
- (void)setLabel: (OFString*)label
{
  SIZE sz; sz.cx = sz.cy = 0;
  SetWindowText(widget, [label UTF8String]);
  SendMessage(widget, BCM_GETIDEALSIZE, 0, (LPARAM)(&sz));
  //SetWindowPos(widget, NULL, 0, 0, sz.cx, sz.cy, SWP_NOACTIVATE | SWP_NOOWNERZORDER | SWP_NOZORDER | SWP_NOMOVE);
  SetWindowPos(widget, NULL, 0, 0, 32, 32, SWP_NOACTIVATE | SWP_NOOWNERZORDER | SWP_NOZORDER | SWP_NOMOVE);
}
//----------------------------------------------------------------------------------------------------------------------------------
- (void)OG_clicked
{
  OFAutoreleasePool *pool = [OFAutoreleasePool new];

  if ([delegate respondsToSelector: @selector(buttonWasClicked:)])
        [delegate buttonWasClicked: self];

  [pool release];
}
//----------------------------------------------------------------------------------------------------------------------------------
@end
//==================================================================================================================================
