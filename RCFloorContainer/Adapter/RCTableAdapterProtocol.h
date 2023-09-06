//
//  RCTableAdapterProtocol.h
//  RCFloorContainer
//
//  Created by sebarina on 2023/9/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class RCTableSectionViewModel;

@protocol RCTableAdapterProtocol <UITableViewDataSource,UITableViewDelegate>

@required
- (void)setDataSource:(NSArray<RCTableSectionViewModel*>*)dataSource;
- (NSArray<RCTableSectionViewModel*>*)dataSource;

@optional
- (void)setDelegate:(id<UIScrollViewDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END
