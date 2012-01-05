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
// OGHBox.m
//==================================================================================================================================
#include <windows.h>
#import "OGHBox.h"
//==================================================================================================================================
@implementation OGHBox
//----------------------------------------------------------------------------------------------------------------------------------
- init
{
  self = [super init];
  [self retain];
  return self;
}
//----------------------------------------------------------------------------------------------------------------------------------
- (void)appendChild: (OGWidget*)child
       expand: (BOOL)expand
         fill: (BOOL)fill
      padding: (float)padding
{
  RECT rc;
  SetParent(child->widget, widget);
  GetWindowRect(child->widget, &rc);
  
  OGBoxChild *newChild   = (OGBoxChild *)malloc(sizeof(OGBoxChild));
  newChild->hwnd         = child->widget;
  newChild->expand       = expand;
  newChild->fill         = fill;
  newChild->padding      = (int)padding;
  newChild->originalSize = (rc.right - rc.left);
  newChild->currentSize  = (float)(newChild->originalSize + (newChild->padding << 1));
  newChild->next         = NULL;
  
  if(firstBorn == NULL)
    firstBorn = newChild;
  else
  {
    OGBoxChild *curr = firstBorn;
    while(curr->next != NULL) curr = curr->next;
    curr->next = newChild;
  }
  
  [self resizeChildren];
}
//----------------------------------------------------------------------------------------------------------------------------------
- (void)prependChild: (OGWidget*)child
        expand: (BOOL)expand
    fill: (BOOL)fill
       padding: (float)padding
{
  RECT rc;
  SetParent(child->widget, widget);
  GetWindowRect(child->widget, &rc);
  
  OGBoxChild *newChild   = (OGBoxChild *)malloc(sizeof(OGBoxChild));
  newChild->hwnd         = child->widget;
  newChild->expand       = expand;
  newChild->fill         = fill;
  newChild->padding      = (int)padding;
  newChild->originalSize = (rc.right - rc.left);
  newChild->currentSize  = (float)(newChild->originalSize + (newChild->padding << 1));
  newChild->next         = firstBorn;
  
  firstBorn = newChild;
  
  [self resizeChildren];
}
//----------------------------------------------------------------------------------------------------------------------------------
- (void)resizeChildren
{
  RECT rc;
  OGBoxChild *curr;
  
  //get our available size
  GetClientRect(widget, &rc);
  int width  = rc.right;
  int height = rc.bottom;
  
  //get total of childrens' widths
  int childOriginal = 0;
  curr = firstBorn;
  while(curr != NULL)
  {
    childOriginal += (curr->originalSize + (curr->padding << 1));
    curr = curr->next;
  }
  
  //how to divide our extra space
  int extra = width - childOriginal;
  float evenShare = 0.0f;
  
  if(extra <= 0)
  {
    curr = firstBorn;
    while(curr != NULL)
    {
      curr->currentSize = curr->originalSize;
      curr = curr->next;
    }
    if(extra < 0)
    {
      //this will generate a WM_SIZE message, and we'll come back to resizeChildren
      SetWindowPos(widget, NULL, 0, 0, childOriginal, height, SWP_NOACTIVATE | SWP_NOOWNERZORDER | SWP_NOZORDER | SWP_NOMOVE);
      return;
    }
  }
  else
  {
    int sharers = 0;
    curr = firstBorn;
    while(curr != NULL)
    {
      if(curr->expand == YES)
        sharers++;
      curr = curr->next;
    }
    if(sharers > 0)
      evenShare = (float)extra / (float)sharers;
    if(evenShare > 0.0f)
    {
      curr = firstBorn;
      while(curr != NULL)
      {
        if(curr->expand == YES)
          if(curr->fill == YES)
            curr->currentSize = (float)curr->originalSize + evenShare;
        curr = curr->next;
      }
    }
  }
  
  //assign new positions/heights
  float x = 0.0f;
  curr = firstBorn;
  while(curr != NULL)
  {
    x += (float)curr->padding;
    SetWindowPos(curr->hwnd, NULL, (int)x, 0, curr->currentSize, height, SWP_NOACTIVATE | SWP_NOOWNERZORDER | SWP_NOZORDER);
    x += (float)curr->currentSize;
    if(curr->fill == NO) if(curr->expand == YES) x += evenShare;
    x += (float)curr->padding;
    curr = curr->next;
  }
}
//----------------------------------------------------------------------------------------------------------------------------------
- (int)MessageReceived : (HWND)hwnd : (UINT)msg : (WPARAM)wparam : (LPARAM)lparam
{
  switch(msg)
  {
    case WM_SIZE:
      [self resizeChildren];
      return DefWindowProc(hwnd, msg, wparam, lparam);
    break;
    
    case WM_SIZING:
      [self resizeChildren];
      return DefWindowProc(hwnd, msg, wparam, lparam);
    break;
  }
  return [(id)super MessageReceived : hwnd : msg : wparam : lparam];
}
//----------------------------------------------------------------------------------------------------------------------------------
@end
//==================================================================================================================================
