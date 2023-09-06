//
//  RCFloorContainerModel.h
//  RCFloorContainer
//
//  Created by sebarina on 2023/9/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class RCBaseComponentModel;
@class RCTableSectionViewModel;
@interface RCFloorContainerModel : NSObject
@property (nonatomic,strong) NSArray<RCBaseComponentModel*> *headerViewModels;
@property (nonatomic,strong) NSArray<RCTableSectionViewModel*> *bodyViewModels;
@property (nonatomic,strong) NSArray<RCBaseComponentModel*> *footerViewModels;

@property (nonatomic,strong) NSString *navTitle;

@end

NS_ASSUME_NONNULL_END
