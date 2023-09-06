//
//  RCContainerView.h
//  RCFloorContainer
//
//  Created by sebarina on 2023/9/4.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class RCFloorContainerModel;
@interface RCContainerView : UIView
- (instancetype)initWithBizName:(NSString*)bizName frame:(CGRect)frame;
- (void)bindModel:(RCFloorContainerModel*)containerModel;
- (void)refreshView;

@end

NS_ASSUME_NONNULL_END
