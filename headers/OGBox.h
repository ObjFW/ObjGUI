#import "OGWidget.h"

@interface OGBox: OGWidget
+ box;

- (void)appendChild: (OGWidget*)child
	     expand: (BOOL)expand
	       fill: (BOOL)fill
	    padding: (float)padding;
- (void)prependChild: (OGWidget*)child
	      expand: (BOOL)expand
		fill: (BOOL)fill
	     padding: (float)padding;
@end
