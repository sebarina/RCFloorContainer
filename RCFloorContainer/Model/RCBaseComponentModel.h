//
//  RCBaseComponentModel.h
//  RCFloorContainer
//
//  Created by sebarina on 2023/9/4.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class RCBaseComponentModel;

@protocol RCComponentViewProtocol <NSObject>

@required
- (void)bindModel:(RCBaseComponentModel*)model;

@end

typedef enum : NSUInteger {
    RCComponentStatusNormal = 0,
    RCComponentStatusDisable = 1
} RCComponentStatus;

@interface RCBaseComponentModel : NSObject
@property (nonatomic,assign) RCComponentStatus status;
@property (nonatomic,strong) NSIndexPath *indexPath;
@property (nonatomic,copy) dispatch_block_t selectedAction;
@property (nonatomic,copy) dispatch_block_t updateUIAction;

- (void)reloadView;
- (Class<RCComponentViewProtocol>)mappedViewClass;
- (CGFloat)heightForView:(CGFloat)containerWidth;
- (NSString*)reusedIdentifier;


@end

NS_ASSUME_NONNULL_END
