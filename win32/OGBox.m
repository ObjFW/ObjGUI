/*
 * Copyright (c) 2011, 2012, Dillon Aumiller <dillonaumiller@gmail.com>
 * Copyright (c) 2012, Jonathan Schleifer <js@webkeks.org>
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
// OGBox.m
//==================================================================================================================================
#include <malloc.h>
#include <windows.h>

#import <ObjFW/OFNotImplementedException.h>

#import "OGBox.h"

//==================================================================================================================================
@implementation OGBox
//----------------------------------------------------------------------------------------------------------------------------------
+ box
{
  return [[[self alloc] init] autorelease];
}
//----------------------------------------------------------------------------------------------------------------------------------
- init
{
  self = [super init];
  SetWindowLong(widget, GWL_STYLE, WS_CHILD | WS_VISIBLE);
  firstBorn = NULL;

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
//----------------------------------------------------------------------------------------------------------------------------------
- (void)appendChild: (OGWidget*)child
       expand: (BOOL)expand
         fill: (BOOL)fill
      padding: (float)padding
{
}
//----------------------------------------------------------------------------------------------------------------------------------
- (void)prependChild: (OGWidget*)child
        expand: (BOOL)expand
    fill: (BOOL)fill
       padding: (float)padding
{
}
//----------------------------------------------------------------------------------------------------------------------------------
- (void)OG_resizeChildren
{
  @throw [OFNotImplementedException exceptionWithClass: isa
                                              selector: _cmd];
}
//----------------------------------------------------------------------------------------------------------------------------------
- (int)MessageReceived : (HWND)hwnd : (UINT)msg : (WPARAM)wparam : (LPARAM)lparam
{
  HWND parent;

  switch(msg)
  {
    case WM_COMMAND:
      parent = GetParent(hwnd);
      if(parent != NULL)
        return SendMessage(parent, msg, wparam, lparam);
    break;
  }
  return DefWindowProc(hwnd, msg, wparam, lparam);
}
//----------------------------------------------------------------------------------------------------------------------------------
@end
//==================================================================================================================================
