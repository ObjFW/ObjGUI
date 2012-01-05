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
// OGComboBox.m
//==================================================================================================================================
#import "OGComboBox.h"
//==================================================================================================================================
@interface OGComboBox ()
- (void)OG_changed;
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
  if(HIWORD(wparam) == LBN_SELCHANGE) //selection changed
    [object OG_changed];
}
//==================================================================================================================================
@implementation OGComboBox
//----------------------------------------------------------------------------------------------------------------------------------
@synthesize delegate;
//----------------------------------------------------------------------------------------------------------------------------------
+ comboBox
{
  return [[[self alloc] init] autorelease];
}
//----------------------------------------------------------------------------------------------------------------------------------
- init
{
  self = [super init];

  //see [OGButton init] for reasoning here...
  DestroyWindow(widget);
  widget = NULL;
  HINSTANCE hInst = (HINSTANCE)GetModuleHandle(NULL);
  widget = CreateWindow("LISTBOX", "", LBS_NOINTEGRALHEIGHT,
                          0, 0, 32, 32,
                          NULL, NULL, hInst, NULL);
  SetWindowLong(widget, GWL_STYLE, LBS_NOINTEGRALHEIGHT | LBS_NOTIFY | WS_CHILD | WS_VISIBLE | WS_TABSTOP);
  CommandHandlerData *chd = (CommandHandlerData *)malloc(sizeof(CommandHandlerData));
  chd->funct  = CH_Command;
  chd->object = self;
  SetProp(widget, "CommandHandlerData", chd);

  [self retain];
  return self;
}
//----------------------------------------------------------------------------------------------------------------------------------
- initWithParent : (OGWidget *)parent
{
  self = [super init];

  //see [OGButton init] for reasoning here...
  DestroyWindow(widget);
  widget = NULL;
  HINSTANCE hInst = (HINSTANCE)GetModuleHandle(NULL);
  widget = CreateWindow("LISTBOX", "", LBS_NOINTEGRALHEIGHT | LBS_NOTIFY | WS_CHILD | WS_VISIBLE,
                          0, 0, 32, 32,
                          parent->widget, NULL, hInst, NULL);
  CommandHandlerData *chd = (CommandHandlerData *)malloc(sizeof(CommandHandlerData));
  chd->funct  = CH_Command;
  chd->object = self;
  SetProp(widget, "CommandHandlerData", chd);

  [self retain];
  return self;
}
//----------------------------------------------------------------------------------------------------------------------------------
- (id <OGComboBoxDataSource>)dataSource
{
  return dataSource;
}
//----------------------------------------------------------------------------------------------------------------------------------
- (void)setDataSource: (id <OGComboBoxDataSource>)dataSource_
{
  OGComboBoxItem* (*itemAtIndex)(id, SEL, OGComboBox*, size_t);

  dataSource = dataSource_;
  itemAtIndex = (OGComboBoxItem*(*)(id, SEL, OGComboBox*, size_t))
      [dataSource methodForSelector: @selector(comboBox:itemAtIndex:)];

  size_t i, size = [dataSource numberOfItemsInComboBox: self];
  for (i = 0; i < size; i++)
  {
    OGComboBoxItem *item = itemAtIndex(dataSource,
        @selector(comboBox:itemAtIndex:), self, i);

    SendMessage(widget, LB_ADDSTRING, 0, (WPARAM)[item.label UTF8String]);
  }
}
//----------------------------------------------------------------------------------------------------------------------------------
- (void)OG_changed
{
  OFAutoreleasePool *pool = [OFAutoreleasePool new];

  if ([delegate respondsToSelector: @selector(comboBoxWasChanged:)])
    [delegate comboBoxWasChanged: self];

  [pool release];
}
//----------------------------------------------------------------------------------------------------------------------------------
@end
//==================================================================================================================================
