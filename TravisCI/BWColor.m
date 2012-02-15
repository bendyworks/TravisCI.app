//
//  BWColor.m
//  TravisCI
//
//  Created by Bradley Grzesiak on 1/10/12.
//  Refer to MIT-LICENSE file at root of project for copyright info
//

#import "BWColor.h"
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@implementation BWColor

+ (UIColor *)textColor { return [UIColor blackColor]; }
+ (UIColor *)fadedTextColor { return [UIColor darkGrayColor]; }
+ (UIColor *)buildPassedColor { return [UIColor colorWithRed:0.0f green:0.5f blue:0.0f alpha:1.0f]; }
+ (UIColor *)buildFailedColor { return [UIColor colorWithRed:0.75f green:0.0f blue:0.0f alpha:1.0f]; }

+ (NSArray *)gradientColors
{
    UIColor *topColor = [UIColor whiteColor];
    UIColor *bottomColor = [UIColor colorWithRed:0.96f green:0.96f blue:0.96f alpha:1.0f];
    return [NSArray arrayWithObjects:(id)[topColor CGColor], (id)[bottomColor CGColor], nil];
}

+ (UIView *)gradientViewForFrame:(UITableViewCell *)cell
{
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = cell.bounds;
    gradient.colors = [BWColor gradientColors];
    UIView *gradientView = [[UIView alloc] initWithFrame:cell.frame];
    [gradientView.layer addSublayer:gradient];
    return gradientView;
}

@end
