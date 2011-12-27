#import "OGWidget.h"

@class OGButton;

@protocol OGButtonDelegate <OFObject>
@optional
- (void)buttonWasClicked: (OGButton*)button;
@end

@interface OGButton: OGWidget
{
	id <OGButtonDelegate> delegate;
}

@property (assign) id <OGButtonDelegate> delegate;
@property (copy) OFString *label;

+ button;
@end
