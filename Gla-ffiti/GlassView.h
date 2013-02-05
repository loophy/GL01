
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

@interface GlassView : UIView
{
	CGContextRef m_contextRef;
	void* m_data;
}

@property (nonatomic, assign) CGContextRef m_contextRef;

@end
