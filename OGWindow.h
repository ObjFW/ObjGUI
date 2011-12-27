#import "OGWidget.h"

@class OGWindow;

@protocol OGWindowDelegate <OFObject>
@optional
- (BOOL)windowWillClose: (OGWindow*)window;
@end

@interface OGWindow: OGWidget
{
	id <OGWindowDelegate> delegate;
}

@property (assign) id <OGWindowDelegate> delegate;
@property (copy) OFString *title;
@property (assign) of_point_t position;
@property (assign) of_dimension_t dimension;

+ window;
- (void)addChild: (OGWidget*)widget;
@end
