//
//  RCTableSectionViewModel.h
//  RCFloorContainer
//
//  Created by sebarina on 2023/9/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class RCBaseComponentModel;

@interface RCTableSectionViewModel : NSObject

@property (nonatomic,strong) RCBaseComponentModel *headerModel;
@property (nonatomic,strong) RCBaseComponentModel *footerModel;
@property (nonatomic,strong) NSArray<RCBaseComponentModel*> *cellModels;

@end

NS_ASSUME_NONNULL_END
