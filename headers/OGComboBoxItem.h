#import <ObjFW/OFString.h>

@interface OGComboBoxItem: OFObject
{
	OFString *label;
}

@property (copy) OFString *label;

+ comboBoxItemWithLabel: (OFString*)label;
- initWithLabel: (OFString*)label;
@end
