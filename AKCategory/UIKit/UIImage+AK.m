//
//  UIImage+AK.m
//
//  Created by ak on 14-9-27.
//
//

#import "UIImage+AK.h"
#import "UIColor+AK.h"

@implementation UIImage (AK)

+ (UIImage*)imageWithRectSize:(CGSize)size fillColor:(UIColor*)fillColor
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //    UIEdgeInsets insets = UIEdgeInsetsMake(1, 1, 1, 1);
    //    rect = UIEdgeInsetsInsetRect(rect, insets);
    
    CGContextSetFillColorWithColor(context, [fillColor CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
+ (UIImage*)imageWithEllipseSize:(CGSize)size strokeColor:(UIColor*)strokeColor fillColor:(UIColor*)fillColor
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIEdgeInsets insets = UIEdgeInsetsMake(1, 1, 1, 1);
    rect = UIEdgeInsetsInsetRect(rect, insets);
    
    CGContextSetStrokeColorWithColor(context, [strokeColor CGColor]);
    CGContextSetFillColorWithColor(context, [fillColor CGColor]);
    
    CGContextFillEllipseInRect(context, rect);
    CGContextStrokeEllipseInRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage*)imageWithEllipseSize:(CGSize)size fillColor:(UIColor*)fillColor
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [fillColor CGColor]);
    
    CGContextFillEllipseInRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage*)imageWithStarSize:(CGFloat)size strokeColor:(UIColor*)strokeColor fillColor:(UIColor*)fillColor
{
    CGRect rect = CGRectMake(0, 0, size, size);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    BOOL hasStrokeColor = [strokeColor alpha] != 0;
    BOOL hasFillColor = [fillColor alpha] != 0;
    
    if (!hasStrokeColor || hasFillColor) {
        if (hasStrokeColor)
        {
            CGFloat xCenter = size / 2;
            CGFloat yCenter = size / 2;
            CGFloat r = size / 2;
            float flip = -1.0;
            
            CGContextSetFillColorWithColor(context, [strokeColor CGColor]);
            
            CGContextSetLineWidth(context, 1);
            
            {
                double theta = 2.0 * M_PI * (2.0 / 5.0); // 144 degrees
                
                CGContextMoveToPoint(context, xCenter, r * flip + yCenter);
                
                for (NSInteger k = 1; k < 5; ++k)
                {
                    float x = r * sin(k * theta);
                    float y = r * cos(k * theta);
                    CGContextAddLineToPoint(context, x + xCenter, y * flip + yCenter);
                }
            }
            
            CGContextClosePath(context);
            CGContextFillPath(context);
        }
        
        if (hasFillColor)
        {
            CGFloat strokeLineWidth = hasStrokeColor ? 2 : 0;
            CGFloat smallSize = size - 2 * strokeLineWidth;
            CGFloat xCenter = strokeLineWidth + smallSize / 2;
            CGFloat yCenter = strokeLineWidth + smallSize / 2;
            CGFloat r = smallSize / 2;
            float flip = -1.0;
            
            CGContextSetFillColorWithColor(context, [fillColor CGColor]);
            
            CGContextSetLineWidth(context, 1);
            
            {
                double theta = 2.0 * M_PI * (2.0 / 5.0); // 144 degrees
                
                CGContextMoveToPoint(context, xCenter, r * flip + yCenter);
                
                for (NSInteger k = 1; k < 5; ++k)
                {
                    float x = r * sin(k * theta);
                    float y = r * cos(k * theta);
                    CGContextAddLineToPoint(context, x + xCenter, y * flip + yCenter);
                }
            }
            
            CGContextClosePath(context);
            CGContextFillPath(context);
        }
    } else {
        {
            CGFloat strokeLineWidth = hasStrokeColor ? 2 : 0;
            CGFloat smallSize = size - 2 * strokeLineWidth;
            CGFloat xCenter = strokeLineWidth + smallSize / 2;
            CGFloat yCenter = strokeLineWidth + smallSize / 2;
            CGFloat r = smallSize / 2;
            float flip = -1.0;
            
            CGContextSetLineWidth(context, 1);
            
            {
                double theta = 2.0 * M_PI * (2.0 / 5.0); // 144 degrees
                
                CGContextMoveToPoint(context, xCenter, r * flip + yCenter);
                
                for (NSInteger k = 1; k < 5; ++k)
                {
                    float x = r * sin(k * theta);
                    float y = r * cos(k * theta);
                    CGContextAddLineToPoint(context, x + xCenter, y * flip + yCenter);
                }
            }
            
            NSParameterAssert(hasStrokeColor && !hasFillColor);
            CGContextEOClip(context);
            
        }
        
        if (hasStrokeColor)
        {
            
            CGFloat xCenter = size / 2;
            CGFloat yCenter = size / 2;
            CGFloat r = size / 2;
            float flip = -1.0;
            
            CGContextSetFillColorWithColor(context, [strokeColor CGColor]);
            
            CGContextSetLineWidth(context, 1);
            
            {
                double theta = 2.0 * M_PI * (2.0 / 5.0); // 144 degrees
                
                CGContextMoveToPoint(context, xCenter, r * flip + yCenter);
                
                for (NSInteger k = 1; k < 5; ++k)
                {
                    float x = r * sin(k * theta);
                    float y = r * cos(k * theta);
                    CGContextAddLineToPoint(context, x + xCenter, y * flip + yCenter);
                }
            }
            
            CGContextClosePath(context);
            CGContextFillPath(context);
        }
        
    }
    
    
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
} 

+ (UIImage *)resizedImageWithName:(NSString *)name
{
    UIImage *image = [self imageNamed:name];
    return [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
}


- (UIImage *)imageWithRoundedRectSize:(CGSize)size  imgName:(NSString*)imgName
{
    
    UIImage * img = [UIImage imageNamed:imgName];
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    
    //// Rounded Rectangle Drawing
    UIBezierPath* roundedRectanglePath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(0, 0, size.width, size.height) cornerRadius: size.width/2];
    
    CGContextBeginPath(context);
    CGContextAddPath(context, roundedRectanglePath.CGPath);
    CGContextClosePath(context);
    CGContextClip(context);
    
    [img drawInRect:rect];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
    
}


- (UIImage *)imageWithTintColor:(UIColor *)tintColor
{
    return [self imageWithTintColor:tintColor blendMode:kCGBlendModeDestinationIn];
}

- (UIImage *)imageWithGradientTintColor:(UIColor *)tintColor
{
    return [self imageWithTintColor:tintColor blendMode:kCGBlendModeOverlay];//akaktodo kCGBlendModeOverlay?
}

- (UIImage *)imageWithTintColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode
{
    //We want to keep alpha, set opaque to NO; Use 0.0f for scale to use the scale factor of the device’s main screen.
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    [tintColor setFill];
    CGRect bounds = CGRectMake(0, 0, self.size.width, self.size.height);
    UIRectFill(bounds);
    
    //Draw the tinted image in context
    [self drawInRect:bounds blendMode:blendMode alpha:1.0f];
    
    if (blendMode != kCGBlendModeDestinationIn) {
        [self drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0f];
    }
    
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return tintedImage;
}
- (UIImage *)resizeImage:(CGRect)bounds {
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], bounds);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return croppedImage;
}
@end


@implementation UIImageView(AK)

-(void)imageRoundName:(NSString*)imgName{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        UIImage * img = [UIImage imageNamed:imgName];
        CGRect rect =self.bounds;
        CGFloat radius=rect.size.width/2;
        
        UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextAddArc(context, radius, radius, radius,0,  M_PI*2, 0);
        
        CGContextClip(context);
        
        [img drawInRect:rect];
        
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.image=image;
        });
    });
}

- (void)imageRoundName:(NSString*)imgName borderWidth:(CGFloat)bWidth borderColor:(UIColor*)bColor{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        UIImage * img = [UIImage imageNamed:imgName];
        CGRect rect =self.bounds;
        CGFloat borderW=bWidth;
        CGFloat radius=rect.size.width/2;
        CGColorRef borderColor =bColor.CGColor;
        
        UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        //        way1:
        
        //same as CGContextSetFillColorWithColor
        //        [[UIColor lightGrayColor] set];
        
        //        CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
        
        //        CGContextFillRect(context, rect);
        
        //        CGContextAddRect(context, CGRectMake(10, 10, 10, 10));
        //        1.draw the border
        CGFloat margin = borderW/2;
        CGContextSetLineWidth(context, borderW);
        CGContextSetStrokeColorWithColor(context, borderColor);
        CGContextAddArc(context, radius, radius, radius-margin,0,  M_PI*2, 0);
        CGContextStrokePath(context);
        
        //        2.clip the image cicle
        CGContextAddArc(context, radius, radius, radius-margin*2,0,  M_PI*2, 0);
        
        CGContextClip(context);
        
        
        ////        way2
        //
        //        //1.draw the border circle
        //        CGContextSetStrokeColorWithColor(context, borderColor);
        //        CGFloat margin= borderW/2;
        //        UIBezierPath* path = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(margin, margin, rect.size.width-margin*2,  rect.size.height-margin*2) cornerRadius: rect.size.width-margin*2];
        //
        //        path.lineWidth=borderW;
        //        [path stroke];
        //
        //        CGContextBeginPath(context);
        //        CGContextAddPath(context, path.CGPath);
        //        CGContextClosePath(context);
        //
        //        //2.draw path clip for image context
        //        margin=margin*2;
        //        UIBezierPath* path2 = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(margin, margin, rect.size.width-margin*2,  rect.size.height-margin*2) cornerRadius: rect.size.width-margin*2];
        //
        //        CGContextBeginPath(context);
        //        CGContextAddPath(context, path2.CGPath);
        //        CGContextClosePath(context);
        //
        //
        //        CGContextClip(context);
        
        
        [img drawInRect:rect];
        
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.image=image;
        });
        
    });
    
    
}

@end
