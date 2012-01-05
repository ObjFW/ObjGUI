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

#import "OGApplication.h"
#import "OGWindow.h"
#import "OGButton.h"
#import "OGHBox.h"
#import "OGVBox.h"
#import "OGComboBox.h"

//i know it's ugly, but it's just for testing...
#include <malloc.h>
@interface TestSource : OFObject <OGComboBoxDataSource>
{
  OGComboBoxItem **items;
}
@end
@implementation TestSource
- init
{
  self = [super init];

  items = (OGComboBoxItem **)malloc(sizeof(OGComboBoxItem *) << 2);
  items[0] = [OGComboBoxItem comboBoxItemWithLabel : @"Test Combo Item 0"];
  items[1] = [OGComboBoxItem comboBoxItemWithLabel : @"Test Combo Item 1"];
  items[2] = [OGComboBoxItem comboBoxItemWithLabel : @"Test Combo Item 2"];
  items[3] = [OGComboBoxItem comboBoxItemWithLabel : @"Test Combo Item 3"];

  [self retain];
  return self;
}
- (size_t)numberOfItemsInComboBox: (OGComboBox*)comboBox
{
  return 4;
}
- (OGComboBoxItem*)comboBox: (OGComboBox*)comboBox itemAtIndex: (size_t)index
{
  return items[index];
}
@end


@interface Test: OFObject <OGApplicationDelegate, OGWindowDelegate, OGButtonDelegate, OGComboBoxDelegate>
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

  OGHBox *hboxPre = [OGHBox box];
  [vbox appendChild: hboxPre
             expand: YES
               fill: YES
            padding: 0];

  OGButton *b = [OGButton button];
  b.label = @"Klick mich!";
  b.delegate = self;
  [hboxPre appendChild: b
       expand: YES
         fill: YES
      padding: 0];

  OGComboBox *cb = [[OGComboBox alloc] initWithParent : hboxPre];
  cb.dataSource  = [[TestSource alloc] init];
  cb.delegate    = self;
  [hboxPre appendChild: cb
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
  MessageBox(NULL, "Hallo!", "OGButton says:", MB_OK);
}

- (void)comboBoxWasChanged: (OGComboBox*)comboBox
{
  MessageBox(NULL, "Selected Item Changed", "OGComboBox says:", MB_OK);
}
@end
