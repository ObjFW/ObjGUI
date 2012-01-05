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
// OGApplication.m
//==================================================================================================================================
#import <ObjFW/OFApplication.h> //this seems to be needed for "OF_APPLICATION_DELEGATE"
#import "OGWidget.h"
#import "OGApplication.h"
//==================================================================================================================================
void win32_init(int *argc, char ***argv);
void win32_main();
LRESULT CALLBACK win32_OGWndProc(HWND hwnd, UINT msg, WPARAM wparam, LPARAM lparam);
//==================================================================================================================================
@interface WndMsgReceiver
- (int)MessageReceived : (HWND)hwnd : (UINT)msg : (WPARAM)wparam : (LPARAM)lparam;
@end
//==================================================================================================================================
OF_APPLICATION_DELEGATE(OGApplication)
extern Class og_application_delegate(void);
//==================================================================================================================================
@implementation OGApplication
//----------------------------------------------------------------------------------------------------------------------------------
+ (void)quit
{
  PostQuitMessage(0);
}
//----------------------------------------------------------------------------------------------------------------------------------
- (void)applicationDidFinishLaunching
{
  OFAutoreleasePool *pool;
  int *argc;
  char ***argv;

  delegate = [[og_application_delegate() alloc] init];

  [[OFApplication sharedApplication] getArgumentCount: &argc
            andArgumentValues: &argv];
  win32_init(argc, argv);

  pool = [OFAutoreleasePool new];
  [delegate applicationDidFinishLaunching];
  [pool release];

  win32_main();
}
//----------------------------------------------------------------------------------------------------------------------------------
- (void)applicationWillTerminate
{
  [delegate applicationWillTerminate];
}
//----------------------------------------------------------------------------------------------------------------------------------
@end
//==================================================================================================================================
void win32_init(int *argc, char ***argv)
{
  //register a single window class; we'll customize later, as needed
  char *clsName = "OGWidgetClass";
  HINSTANCE hInst = (HINSTANCE)GetModuleHandle(NULL);
  WNDCLASSEX wcx;
  wcx.cbSize        = sizeof(wcx);
  wcx.style         = CS_VREDRAW | CS_HREDRAW;
  wcx.lpfnWndProc   = (WNDPROC)win32_OGWndProc;
  wcx.cbClsExtra    = 0;
  wcx.cbWndExtra    = 0;
  wcx.hInstance     = hInst;
  wcx.hIcon         = LoadIcon(NULL, IDI_APPLICATION);
  wcx.hCursor       = LoadCursor(NULL, IDC_ARROW);
  wcx.hbrBackground = (HBRUSH)(COLOR_WINDOW+1);
  wcx.lpszMenuName  = NULL;
  wcx.lpszClassName = clsName;
  wcx.hIconSm       = NULL;

  RegisterClassEx(&wcx);
  //TODO: although this doesn't ever really fail, we should probably Throw an Exception here...
  //if(!RegisterClassEx(&wcx)) @throw ...;
}
//==================================================================================================================================
void win32_main()
{
  MSG msg; int msgCode;
  while((msgCode = GetMessage(&msg, NULL, 0, 0)) != 0)
  {
    if(msgCode == -1)
      return;
    else
    {
      TranslateMessage(&msg);
      DispatchMessage(&msg);
    }
  }
}
//==================================================================================================================================
LRESULT CALLBACK win32_OGWndProc(HWND hwnd, UINT msg, WPARAM wparam, LPARAM lparam)
{
  void *ptr = (void *)GetWindowLong(hwnd, GWL_USERDATA);
  if(ptr == NULL) return DefWindowProc(hwnd, msg, wparam, lparam);
  return [(id)ptr MessageReceived : hwnd : msg : wparam : lparam];
}
//==================================================================================================================================
