//
//  RCTableAdapter.m
//  RCFloorContainer
//
//  Created by sebarina on 2023/9/4.
//

#import "RCTableAdapter.h"
#import "RCTableSectionViewModel.h"
#import "RCBaseComponentModel.h"

@interface RCTableAdapter ()
@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic,strong) NSMutableSet *registedViewClasses;
@end

@implementation RCTableAdapter

- (instancetype)initWithTableView:(UITableView *)tableView
{
    self = [super init];
    if (self) {
        self.tableView = tableView;
    }
    return self;
}

- (void)setDataSource:(NSArray<RCTableSectionViewModel *> *)dataSource
{
    for (RCTableSectionViewModel *sectionModel in dataSource) {
        if (sectionModel.headerModel) {
            [self registerComponent:sectionModel.headerModel isCell:NO];
        }
        for (RCBaseComponentModel *model in sectionModel.cellModels) {
            [self registerComponent:model isCell:YES];
        }
        if (sectionModel.footerModel) {
            [self registerComponent:sectionModel.footerModel isCell:NO];
        }
    }
    _dataSource = dataSource;
}


- (void)registerComponent:(RCBaseComponentModel*)model isCell:(BOOL)isCell
{
    NSString *identifier = [model reusedIdentifier];
    if (identifier.length <= 0) {
        return;
    }
    if ([self.registedViewClasses containsObject:identifier]) {
        return;
    }
    if (isCell) {
        [self.tableView registerClass:[model mappedViewClass] forCellReuseIdentifier:identifier];
    } else {
        [self.tableView registerClass:[model mappedViewClass] forHeaderFooterViewReuseIdentifier:identifier];
    }
    [self.registedViewClasses addObject:identifier];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section < self.dataSource.count) {
        return self.dataSource[section].cellModels.count;
    } else {
        return 0;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section < self.dataSource.count) {
        NSArray<RCBaseComponentModel*> *cellModels = self.dataSource[indexPath.section].cellModels;
        if (indexPath.row < cellModels.count) {
            RCBaseComponentModel *cellModel = cellModels[indexPath.row];
            __weak typeof(tableView) weakTableView = tableView;
            cellModel.updateUIAction = ^{
                [weakTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            };
            NSString *identifier = [cellModel reusedIdentifier];
            
            UITableViewCell<RCComponentViewProtocol> *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
            if (!cell) {
                Class cellClass = [cellModel mappedViewClass];
                if (cellClass) {
                    cell = [[cellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                }
            }
            if ([cell respondsToSelector:@selector(bindModel:)]) {
                [cell bindModel:cellModel];
            }
            return cell;
        }
    }
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section < self.dataSource.count) {
        RCBaseComponentModel *model = self.dataSource[section].headerModel;
        if (model) {
            return [self headerFooterViewWithModel:model tableView:tableView];
        }
        
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section < self.dataSource.count) {
        RCBaseComponentModel *model = self.dataSource[section].footerModel;
        if (model) {
            return [self headerFooterViewWithModel:model tableView:tableView];
        }
        
    }
    return nil;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section < self.dataSource.count) {
        RCTableSectionViewModel *sectionModel = self.dataSource[indexPath.section];
        if (indexPath.row < sectionModel.cellModels.count) {
            RCBaseComponentModel *cellModel = sectionModel.cellModels[indexPath.row];
            cellModel.indexPath = indexPath;
            return [cellModel heightForView:tableView.frame.size.width];
        }
    }
    return 0;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section < self.dataSource.count) {
        RCBaseComponentModel *model = self.dataSource[section].headerModel;
        if (model) {
            return [model heightForView:tableView.frame.size.width];
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section < self.dataSource.count) {
        RCBaseComponentModel *model = self.dataSource[section].footerModel;
        if (model) {
            return [model heightForView:tableView.frame.size.width];
        }
    }
    return 0;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [self.delegate scrollViewDidScroll:scrollView];
    }
}

- (UIView*)headerFooterViewWithModel:(RCBaseComponentModel*)model tableView:(UITableView*)tableView
{
    NSString *identifier = [model reusedIdentifier];
    UITableViewHeaderFooterView<RCComponentViewProtocol> *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    if (!view) {
        Class viewClass = [model mappedViewClass];
        if (viewClass) {
            view = [[viewClass alloc] initWithReuseIdentifier:identifier];
        }
    }
    if ([view respondsToSelector:@selector(bindModel:)]) {
        [view bindModel:model];
    }
    return view;
}



@end
