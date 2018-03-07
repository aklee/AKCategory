//
//  UIImage+AK.h
//
//  Created by ak on 14-9-27.
//
//

#import <UIKit/UIKit.h>

@interface UIImage (AK)

/**
 创建色块图片

 @param size 大小
 @param fillColor 填充颜色
 @return 图片
 */
+ (UIImage*)imageWithRectSize:(CGSize)size fillColor:(UIColor*)fillColor;

/**
 *  @brief  创建椭圆图片
 *  @param size         椭圆大小 (宽和高一样时，为圆形)
 *  @param fillColor    填充色
 *  @return 图片对象
 */
+ (UIImage*)imageWithEllipseSize:(CGSize)size fillColor:(UIColor*)fillColor;

/**
 *  @brief  创建椭圆图片
 *  @param size        椭圆大小 (宽和高一样时，为圆形)
 *  @param strokeColor 描边色
 *  @param fillColor   填充色
 *  @return 图片对象
 */
+ (UIImage*)imageWithEllipseSize:(CGSize)size strokeColor:(UIColor*)strokeColor fillColor:(UIColor*)fillColor;

/**
 *  @brief  创建五角星图片
 *  @param size        五角星位于的正方形区域边长
 *  @param strokeColor 描边色
 *  @param fillColor   填充色
 *  @return 图片对象
 */
+ (UIImage*)imageWithStarSize:(CGFloat)size strokeColor:(UIColor*)strokeColor fillColor:(UIColor*)fillColor;


/**
 *  @brief  创建圆角矩形图片 (圆角大小为 4 point) 
 *  @param size         圆角矩形大小 
 *  @return 图片对象
 */
- (UIImage *)imageWithRoundedRectSize:(CGSize)size imgName:(NSString*)imgName;


/**
 *  返回一张自由拉伸的图片
 */
+ (UIImage *)resizedImageWithName:(NSString *)name;

//- (UIImage *)imageWithTintColor:(UIColor *)tintColor;
//- (UIImage *)imageWithGradientTintColor:(UIColor *)tintColor;

@end


@interface UIImageView (AK)

/*
 usage:
 
 [self.headView imageRoundName:@"引导页1-1242x2208"];
 
 [self.headView imageRoundName:@"引导页1" borderWidth:2 borderColor:[UIColor redColor]];
 
 
 */

-(void)imageRoundName:(NSString*)imgName;


//Draw Round image in other thread
//Set image to imgv on main thread
- (void)imageRoundName:(NSString*)imgName borderWidth:(CGFloat)bWidth borderColor:(UIColor*)bColor;
@end
