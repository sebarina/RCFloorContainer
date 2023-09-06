//
//  RCBaseComponentModel.m
//  RCFloorContainer
//
//  Created by sebarina on 2023/9/4.
//

#import "RCBaseComponentModel.h"

@implementation RCBaseComponentModel

- (Class<RCComponentViewProtocol>)mappedViewClass
{
    NSString *className = NSStringFromClass(self.class);
    if ([className hasSuffix:@"Model"]) {
        NSString *cellClassName = [className stringByReplacingOccurrencesOfString:@"Model" withString:@"Cell"];
        Class cellClass = NSClassFromString(cellClassName);
        if (cellClass && [cellClass conformsToProtocol:@protocol(RCComponentViewProtocol)]) {
            return cellClass;
        }
        
        NSString *viewClassName = [className stringByReplacingOccurrencesOfString:@"Model" withString:@"View"];
        Class viewClass = NSClassFromString(viewClassName);
        if (viewClass && [viewClass conformsToProtocol:@protocol(RCComponentViewProtocol)]) {
            return viewClass;
        }
    }
    return nil;
}

- (CGFloat)heightForView:(CGFloat)containerWidth
{
    return UITableViewAutomaticDimension;
}

- (NSString *)reusedIdentifier
{
    return NSStringFromClass(self.class);
}

- (void)reloadView
{
    if (self.updateUIAction) {
        self.updateUIAction();
    }
}

@end
