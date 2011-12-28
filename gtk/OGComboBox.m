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
