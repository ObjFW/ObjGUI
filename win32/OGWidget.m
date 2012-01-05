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
// OGWidget.m
//==================================================================================================================================
#include <windows.h>
#import "OGWidget.h"
//==================================================================================================================================
void og_destroy(HWND widget, OGWidget *object)
{
  if(widget != NULL)
    DestroyWindow(widget);
  [object release];
}
//==================================================================================================================================
@implementation OGWidget
//----------------------------------------------------------------------------------------------------------------------------------
- init
{
  self = [super init];

  widget = NULL;
  HINSTANCE hInst = (HINSTANCE)GetModuleHandle(NULL);
  widget = CreateWindowEx(WS_EX_LEFT, "OGWidgetClass", "OGWidget", WS_OVERLAPPEDWINDOW,
                          0, 0, 1, 1, NULL, NULL, hInst, NULL);
  SetWindowLong(widget, GWL_USERDATA, (int)self);

  @try {
    if (isa == [OGWidget class])
      @throw [OFNotImplementedException
          exceptionWithClass: isa
              selector: @selector(init)];
  } @catch (id e) {
    [self release];
    @throw e;
  }

  return self;
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
- (int)MessageReceived : (HWND)hwnd : (UINT)msg : (WPARAM)wparam : (LPARAM)lparam
{
  return DefWindowProc(hwnd, msg, wparam, lparam);
}
//----------------------------------------------------------------------------------------------------------------------------------
@end
//==================================================================================================================================
