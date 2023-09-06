//
//  RCTableAdapter.h
//  RCFloorContainer
//
//  Created by sebarina on 2023/9/4.
//

#import <Foundation/Foundation.h>
#import "RCTableAdapterProtocol.h"

NS_ASSUME_NONNULL_BEGIN
@class RCTableSectionViewModel;
@interface RCTableAdapter : NSObject <RCTableAdapterProtocol>

@property (nonatomic,strong) NSArray<RCTableSectionViewModel *> *dataSource;
@property (nonatomic,weak) id<UIScrollViewDelegate> delegate;

- (instancetype)initWithTableView:(UITableView*)tableView;
@end

NS_ASSUME_NONNULL_END
