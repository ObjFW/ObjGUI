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

#import "OGWidget.h"
#import "OGComboBoxItem.h"

@class OGComboBox;

@protocol OGComboBoxDelegate <OFObject>
@optional
- (void)comboBoxWasChanged: (OGComboBox*)comboBox;
@end

@protocol OGComboBoxDataSource <OFObject>
- (size_t)numberOfItemsInComboBox: (OGComboBox*)comboBox;
- (OGComboBoxItem*)comboBox: (OGComboBox*)comboBox
		itemAtIndex: (size_t)index;
@end

@interface OGComboBox: OGWidget
{
	id <OGComboBoxDelegate> delegate;
	id <OGComboBoxDataSource> dataSource;
}

#ifdef OG_W32
//unfortunately, the built-in Win32 ListBox stores a pointer to it's parent (for sending selection changed notifications) during CreateWindow().
//it does not update it after a SetParent()... unless we implement a custom ListBox control i don't see a way around this...
- initWithParent : (OGWidget *)parent;
#endif

@property (assign) id <OGComboBoxDelegate> delegate;
@property (assign) id <OGComboBoxDataSource> dataSource;

+ comboBox;
@end
