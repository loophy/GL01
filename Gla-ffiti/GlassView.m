
#import "GlassView.h"

@implementation GlassView

@synthesize m_contextRef;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		[self setBackgroundColor: [UIColor clearColor]];
        m_data = malloc(CGRectGetWidth(frame) * CGRectGetHeight(frame) * 4);
		
		CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
		m_contextRef = CGBitmapContextCreate(m_data, CGRectGetWidth(frame), CGRectGetHeight(frame), 8, CGRectGetWidth(frame) * 4, colorSpaceRef, kCGImageAlphaPremultipliedLast);
		
		CGContextSetRGBFillColor(m_contextRef, 1.0, 1.0, 1.0, 0.5);
		CGContextFillRect(m_contextRef, frame);
    }
    return self;
}

- (void)dealloc{
	free(m_data);
    [super dealloc];
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
	CGImageRef imageRef = CGBitmapContextCreateImage(m_contextRef);
	CGContextRef currentContext = UIGraphicsGetCurrentContext();
	CGContextDrawImage(currentContext, rect, imageRef);
	CGImageRelease(imageRef);
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
	
    CGPoint p = [[touches anyObject] locationInView: self];
    CGPoint q = [[touches anyObject] previousLocationInView: self];
	
	CGContextSetBlendMode(m_contextRef, kCGBlendModeClear);
	CGContextSetLineWidth(m_contextRef, 9.0f);
    //	CGContextSetRGBStrokeColor(m_contextRef, 1, 1, 1, 0);
	
    CGContextSetLineCap(m_contextRef, kCGLineCapRound);
    CGContextBeginPath(m_contextRef);
	
    CGContextMoveToPoint(m_contextRef, q.x, q.y);
    CGContextAddLineToPoint(m_contextRef, p.x, p.y);
    CGContextStrokePath(m_contextRef);
    [self setNeedsDisplay];
}

@end
