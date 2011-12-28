#import "OGComboBoxItem.h"

@implementation OGComboBoxItem
@synthesize label;

+ comboBoxItemWithLabel: (OFString*)label
{
	return [[[self alloc] initWithLabel: label] autorelease];
}

- initWithLabel: (OFString*)label_
{
	self = [super init];

	@try {
		label = [label_ copy];
	} @catch (id e) {
		[self release];
		@throw e;
	}

	return self;
}

- (void)dealloc
{
	[label release];

	[super dealloc];
}
@end
