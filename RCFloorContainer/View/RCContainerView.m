//
//  RCContainerView.m
//  RCFloorContainer
//
//  Created by sebarina on 2023/9/4.
//
#import <Masonry/Masonry.h>
#import "RCContainerView.h"
#import "RCBaseComponentModel.h"
#import "RCFloorContainerModel.h"
#import "RCTableAdapter.h"

@interface RCContainerHeaderFooterView : UIView
@property (nonatomic,strong) NSArray<RCBaseComponentModel*> *childrenModels;
@end

@implementation RCContainerHeaderFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.childrenModels = [@[] mutableCopy];
    }
    return self;
}

- (void)bindChildrenModels:(NSArray<RCBaseComponentModel*>*)models
{
    self.childrenModels = models;
    MASViewAttribute *topAttr = self.mas_top;
    for (RCBaseComponentModel *model in models) {
        Class viewClass = [model mappedViewClass];
        UIView<RCComponentViewProtocol> *view = [[viewClass alloc] init];
        [view bindModel:model];
        [self addSubview:view];
        CGFloat height = [model heightForView:self.frame.size.width];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(self);
            make.top.equalTo(topAttr);
        }];
        if (height != UITableViewAutomaticDimension) {
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(height));
            }];
        }
        topAttr = view.mas_bottom;
        
    }
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(topAttr).priorityHigh();
    }];
}

- (void)reloadView
{
    NSArray *subviews = self.subviews;
    NSUInteger index = 0;
    for (UIView<RCComponentViewProtocol> *sv in subviews) {
        RCBaseComponentModel *model = self.childrenModels[index];
        [sv bindModel:model];
        CGFloat height = [model heightForView:self.frame.size.width];
        if (height != UITableViewAutomaticDimension) {
            [sv mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(@(height));
            }];
        }
        index += 1;
    }
}

@end

@interface RCContainerView ()
@property (nonatomic,strong) RCFloorContainerModel *containerModel;
@property (nonatomic,strong) NSString *bizName;
@property (nonatomic,strong) RCTableAdapter *tableAdapter;
@property (nonatomic,strong) RCContainerHeaderFooterView *headerView;
@property (nonatomic,strong) RCContainerHeaderFooterView *footerView;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) MASConstraint *tableTopConstraint;
@property (nonatomic,strong) MASConstraint *tableBottomConstraint;

@end

@implementation RCContainerView

- (nonnull instancetype)initWithBizName:(nonnull NSString *)bizName frame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.bizName = bizName;
        self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.delegate = self.tableAdapter;
        self.tableView.dataSource = self.tableAdapter;
        [self addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(self);
            self.tableTopConstraint = make.top.equalTo(self);
            self.tableBottomConstraint = make.bottom.equalTo(self);
        }];
    }
    return self;
}

- (void)bindModel:(nonnull RCFloorContainerModel *)containerModel {
    self.containerModel = containerModel;
    __weak typeof(self) weakSelf = self;
    for (RCBaseComponentModel *model in containerModel.headerViewModels) {
        model.updateUIAction = ^{
            typeof(self) strongSelf = weakSelf;
            [strongSelf.headerView reloadView];
        };
    }
    
    for (RCBaseComponentModel *model in containerModel.footerViewModels) {
        model.updateUIAction = ^{
            typeof(self) strongSelf = weakSelf;
            [strongSelf.footerView reloadView];
        };
    }
    self.tableAdapter.dataSource = containerModel.bodyViewModels;
    
    [self reloadAllViews];
}

- (void)refreshView {
    [self.tableView reloadData];
    if (self.containerModel.headerViewModels.count > 0) {
        [self.headerView reloadView];
    }
    if (self.containerModel.footerViewModels.count > 0) {
        [self.footerView reloadView];
    }
}

- (void)reloadAllViews
{
    [self.tableTopConstraint uninstall];
    [self.tableBottomConstraint uninstall];
    [self reloadHeaderView];
    [self reloadFooterView];
    [self.tableView reloadData];
}

- (void)reloadHeaderView
{
    [self.headerView removeFromSuperview];
    if (self.containerModel.headerViewModels.count > 0) {
        [self addSubview:self.headerView];
        [self.headerView bindChildrenModels:self.containerModel.headerViewModels];
        [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.top.equalTo(self);
        }];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            self.tableTopConstraint = make.top.equalTo(self.headerView.mas_bottom);
        }];
    } else {
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            self.tableTopConstraint = make.top.equalTo(self);
        }];
    }
}

- (void)reloadFooterView
{
    [self.footerView removeFromSuperview];
    if (self.containerModel.footerViewModels.count > 0) {
        [self addSubview:self.footerView];
        [self.footerView bindChildrenModels:self.containerModel.footerViewModels];
        [self.footerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.bottom.equalTo(self);
        }];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            self.tableBottomConstraint = make.bottom.equalTo(self.footerView.mas_top);
        }];
    } else {
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            self.tableBottomConstraint = make.bottom.equalTo(self);
        }];
    }
}


- (RCTableAdapter *)tableAdapter
{
    if (!_tableAdapter) {
        _tableAdapter = [[RCTableAdapter alloc] initWithTableView:self.tableView];
    }
    return _tableAdapter;
}

- (RCContainerHeaderFooterView *)headerView
{
    if (!_headerView) {
        _headerView = [[RCContainerHeaderFooterView alloc] init];
    }
    return _headerView;
}

- (RCContainerHeaderFooterView *)footerView
{
    if (!_footerView) {
        _footerView = [[RCContainerHeaderFooterView alloc] init];
    }
    return _footerView;
}



@end
