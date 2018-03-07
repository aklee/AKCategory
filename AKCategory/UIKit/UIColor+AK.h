//
//  UIColor+AK.m 
//

#import <UIKit/UIKit.h>

@interface UIColor (AK)

//rgba(112,112,112,0.2)
- (NSString *)rgbaString;

///#112233
- (NSString *)sharpString;

///让颜色更亮
- (UIColor *)lighten;

///让颜色更暗
- (UIColor *)darken;

- (CGFloat)alpha;

///取两个颜色的中间
- (UIColor *)mix:(UIColor *) color;




@end
