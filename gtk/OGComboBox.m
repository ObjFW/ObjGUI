/*
 * Copyright (c) 2011, 2012, Jonathan Schleifer <js@webkeks.org>
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

#import "OGComboBox.h"

@interface OGComboBox ()
- (void)OG_changed;
@end

static void
changed(GtkWidget *widget, gpointer data)
{
	[(OGComboBox*)data OG_changed];
}

@implementation OGComboBox
@synthesize delegate;

+ comboBox
{
	return [[[self alloc] init] autorelease];
}

- init
{
	self = [super init];

	widget = gtk_combo_box_new();
	GtkCellRenderer *renderer = gtk_cell_renderer_text_new();
	gtk_cell_layout_pack_start(GTK_CELL_LAYOUT(widget), renderer, FALSE);
	gtk_cell_layout_set_attributes(GTK_CELL_LAYOUT(widget), renderer,
	    "text", 0, NULL);
	g_signal_connect(G_OBJECT(widget), "changed", G_CALLBACK(changed),
	    self);

	g_signal_connect(G_OBJECT(widget), "destroy", G_CALLBACK(og_destroy),
	    self);
	[self retain];

	return self;
}

- (id <OGComboBoxDataSource>)dataSource
{
	return dataSource;
}

- (void)setDataSource: (id <OGComboBoxDataSource>)dataSource_
{
	GtkListStore *listStore = gtk_list_store_new(1, G_TYPE_STRING);
	GtkTreeIter iter;
	OGComboBoxItem* (*itemAtIndex)(id, SEL, OGComboBox*, size_t);

	dataSource = dataSource_;
	itemAtIndex = (OGComboBoxItem*(*)(id, SEL, OGComboBox*, size_t))
	    [dataSource methodForSelector: @selector(comboBox:itemAtIndex:)];

	size_t i, size = [dataSource numberOfItemsInComboBox: self];
	for (i = 0; i < size; i++) {
		OGComboBoxItem *item = itemAtIndex(dataSource,
		    @selector(comboBox:itemAtIndex:), self, i);

		gtk_list_store_append(listStore, &iter);
		gtk_list_store_set(listStore, &iter, 0,
		    [item.label UTF8String], -1);
	}

	gtk_combo_box_set_model(GTK_COMBO_BOX(widget),
	    GTK_TREE_MODEL(listStore));
}

- (void)OG_changed
{
	OFAutoreleasePool *pool = [OFAutoreleasePool new];

	if ([delegate respondsToSelector: @selector(comboBoxWasChanged:)])
		[delegate comboBoxWasChanged: self];

	[pool release];
}
@end
