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

@property (assign) id <OGComboBoxDelegate> delegate;
@property (assign) id <OGComboBoxDataSource> dataSource;

+ comboBox;
@end
