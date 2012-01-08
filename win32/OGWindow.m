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
// OGWindow.m
//==================================================================================================================================
#include <windows.h>
#import "OGWidget.h"
#import "OGWindow.h"
//==================================================================================================================================
@interface OGWindow ()
- (BOOL)OG_willClose;
@end
//==================================================================================================================================
typedef void(*CommandHandler)(id,WPARAM);
typedef struct
{
  CommandHandler funct;
  id             object;
} CommandHandlerData;
//==================================================================================================================================
static int CALLBACK Resize_EnumChildren(HWND child, LPARAM lparam)
{
  //it appears this is actually EnumAncestorWindows, and not EnumDirectChildWindows
  //so make sure child.parent == use
  HWND parent = (HWND)lparam;
  if(GetParent(child) != parent) return 1;

  RECT rc;
  GetClientRect(parent, &rc);
  SetWindowPos(child, NULL, 0, 0, rc.right, rc.bottom,
               SWP_NOACTIVATE | SWP_NOOWNERZORDER | SWP_NOZORDER);
  return 1;
}
//==================================================================================================================================
@implementation OGWindow
//----------------------------------------------------------------------------------------------------------------------------------
@synthesize delegate;
//----------------------------------------------------------------------------------------------------------------------------------
+ window
{
  return [[[self alloc] init] autorelease];
}
//----------------------------------------------------------------------------------------------------------------------------------
- init
{
  self = [super init];

  SetWindowLong(widget, GWL_EXSTYLE, WS_EX_OVERLAPPEDWINDOW);
  //"event connections" are handled in MessageReceived

  [self retain];
  return self;
}
//----------------------------------------------------------------------------------------------------------------------------------
- (OFString*)title
{
  int tlen = GetWindowTextLength(widget);
  char *buff = (char *)malloc(tlen + 1);
  GetWindowText(widget, buff, tlen+1);

  OFString *ret = [OFString stringWithUTF8String : buff];
  free(buff);
  return ret;
}
//----------------------------------------------------------------------------------------------------------------------------------
- (void)setTitle: (OFString*)title
{
  SetWindowText(widget, [title UTF8String]);
}
//----------------------------------------------------------------------------------------------------------------------------------
- (of_point_t)position
{
  RECT rc;
  GetWindowRect(widget, &rc);
  return of_point((int)rc.left, (int)rc.top);
}
//----------------------------------------------------------------------------------------------------------------------------------
- (void)setPosition: (of_point_t)position
{
  SetWindowPos(widget, NULL, position.x, position.y, 0, 0,
               SWP_NOACTIVATE | SWP_NOOWNERZORDER | SWP_NOSIZE | SWP_NOZORDER);
}
//----------------------------------------------------------------------------------------------------------------------------------
- (of_dimension_t)dimension
{
  RECT rc;
  GetWindowRect(widget, &rc);
  return of_dimension(rc.right - rc.left, rc.bottom - rc.top);
}
//----------------------------------------------------------------------------------------------------------------------------------
- (void)setDimension: (of_dimension_t)dimension
{
  SetWindowPos(widget, NULL, 0, 0, dimension.width, dimension.height,
               SWP_NOACTIVATE | SWP_NOOWNERZORDER | SWP_NOMOVE | SWP_NOZORDER);
}
//----------------------------------------------------------------------------------------------------------------------------------
- (void)addChild: (OGWidget*)child
{
  SetParent(child->widget, widget);
  //act like GTK; we'll assume a single child, and expand it to our size
  RECT rc;
  GetClientRect(widget, &rc);
  SetWindowPos(child->widget, NULL, 0, 0, rc.right, rc.bottom,
               SWP_NOACTIVATE | SWP_NOOWNERZORDER | SWP_NOZORDER);
}
//----------------------------------------------------------------------------------------------------------------------------------
- (void)show
{
  if(widget != NULL)
    ShowWindow(widget, SW_SHOWNORMAL);
}
//----------------------------------------------------------------------------------------------------------------------------------
- (void)hide
{
  if(widget != NULL)
    ShowWindow(widget, SW_HIDE);
}
//----------------------------------------------------------------------------------------------------------------------------------
- (BOOL)OG_willClose
{
  OFAutoreleasePool *pool = [OFAutoreleasePool new];

  if ([delegate respondsToSelector: @selector(windowWillClose:)])
    return [delegate windowWillClose: self];

  [pool release];
  return YES;
}
//----------------------------------------------------------------------------------------------------------------------------------
- (int)MessageReceived : (HWND)hwnd : (UINT)msg : (WPARAM)wparam : (LPARAM)lparam
{
  HWND ctrlHwnd;

  switch(msg)
  {
    case WM_COMMAND:
      //NOTE: TODO: IMPLEMENT: this may need revised later for Menus and Accelerators
      ctrlHwnd = (HWND)lparam;
      CommandHandlerData *chd = (CommandHandlerData *)GetProp(ctrlHwnd, "CommandHandlerData");
      if(chd        == NULL) return DefWindowProc(hwnd, msg, wparam, lparam);
      if(chd->funct == NULL) return DefWindowProc(hwnd, msg, wparam, lparam);
      chd->funct(chd->object, wparam);
      return 0;
    break;

    case WM_CLOSE:
      if([self OG_willClose] == YES)
        og_destroy(hwnd, self);
      return 0;
    break;

    case WM_SIZE:
      //act like GTK; expand our child(ren) to fit
      EnumChildWindows(widget, Resize_EnumChildren, (LPARAM)widget);
    break;

    case WM_SIZING:
      //act like GTK; expand our child(ren) to fit
      EnumChildWindows(widget, Resize_EnumChildren, (LPARAM)widget);
    break;
  }
  return DefWindowProc(hwnd, msg, wparam, lparam);
}
//----------------------------------------------------------------------------------------------------------------------------------
@end
//==================================================================================================================================
