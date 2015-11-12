
#import "ANSelectedViewController.h"
#import "ANPickerView.h"
#import "ANConstants.h"
#import "ANSelectionView.h"
#import "ANSelectionViewCell.h"

#define kTitleLabelTop 25

@interface ANSelectedViewController () <ANPickerViewSelectedRowDelegate>

@property(nonatomic) ANSelectedViewControllerType type;
@property(nonatomic, strong) id selectedValue;
@property(nonatomic, strong) UIView *backView;
@property(nonatomic, weak) UIView *selectionView;

@end

@implementation ANSelectedViewController

- (instancetype)initWithType:(ANSelectedViewControllerType)type andSelectedValue:(id)selectedValue
{
  self = [super init];
  if (self) {
    self.type = type;
    self.definesPresentationContext = YES;
    self.view.backgroundColor = [[UIColor alloc] initWithWhite:0.0 alpha:0.0];
    self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    self.selectedValue = selectedValue;

    [self addGestureRecognizerGoBack];
    [self addBackView];
    [self addSelectionView];
  }
  return self;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [UIView animateWithDuration:0.25 animations:^{
    self.view.backgroundColor = [[UIColor alloc] initWithWhite:0.0 alpha:0.6];
  }];
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [UIView animateWithDuration:0.25f animations:^{
    CGRect frame = self.backView.frame;
    frame.origin.y = CGRectGetHeight(self.view.frame) - CGRectGetHeight(self.backView.frame);
    self.backView.frame = frame;
  }];
}

#pragma mark - go back
- (void)addGestureRecognizerGoBack {
  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goBack)];
  UIView *view = [[UIView alloc] initWithFrame:self.view.frame];
  view.backgroundColor = [UIColor clearColor];
  [view addGestureRecognizer:tap];
  [self.view addSubview:view];
}

- (void)goBack {
  if (self.type == ANSelectedViewControllerTypeWeeklyRepeat || self.type == ANSelectedViewControllerTypeProfiles) {
    self.selectedValue = [(ANSelectionView *)(self.selectionView) finalSelectedItems];
  }
  if (self.goBackAction) {
    self.goBackAction(self.selectedValue);
  }
  [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - creat UI
- (void)addBackView {
  self.backView = [[UIView alloc] init];
  self.backView.backgroundColor = [UIColor whiteColor];
  CGRect frame = self.view.frame;
  frame.size.height = (CGRectGetHeight(self.view.frame) - 64) / 3;
  frame.origin.y = CGRectGetHeight(self.view.frame);
  self.backView.frame = frame;
  [self.view addSubview:self.backView];
}

- (void)addSelectionView {
  switch (self.type) {
    case ANSelectedViewControllerTypeNone:
      break;
    case ANSelectedViewControllerTypeWeeklyRepeat:
      [self weeklyRepeatView];
      break;
    case ANSelectedViewControllerTypeTemperature:
      [self temperatureView];
      break;
    case ANSelectedViewControllerTypeProfiles:
      [self profilesView];
      break;
    default:
      break;
  }
}

- (void)weeklyRepeatView {
  UILabel *titleLabel = [self createTitleLabelWithTitle:NSLocalizedString(@"Repeat", @"Repeat")];

  CGFloat itemWidth = 40;
  CGRect frame = self.backView.frame;
  frame.origin.x = 15;
  frame.origin.y = CGRectGetMaxY(titleLabel.frame) + 8 + kTitleLabelTop;
  frame.size.width = CGRectGetWidth(frame) - 15 * 2;
  frame.size.height = CGRectGetHeight(frame) - CGRectGetMinY(frame) - 33;

  UICollectionViewFlowLayout *flowLayout = [ANSelectionView createLayoutWith:CGSizeMake(itemWidth, itemWidth)
                                                                       frame:frame
                                                     andHorizontalItemNumber:5
                                                          verticalItemNumber:2];

  ANSelectionView *selectionView = [[ANSelectionView alloc] initWithFrame:frame
                                                     collectionViewLayout:flowLayout
                                                               itemTitles:kWeekArray];
  selectionView.selectItemAction = ^(UICollectionViewCell *cell, NSIndexPath *indexPath) {
    ANSelectionViewCell *weekCell = (ANSelectionViewCell *)cell;
    weekCell.buttonSelected = !weekCell.buttonSelected;
  };
  NSMutableArray *selectedItems = [NSMutableArray array];
  [self.selectedValue enumerateObjectsUsingBlock:^(NSNumber *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
    NSNumber *selectedIndex = [NSNumber numberWithInt:(obj.intValue - 1)];
    [selectedItems addObject:selectedIndex];
  }];
  selectionView.selectedItems = selectedItems;

  [self.backView addSubview:selectionView];
  self.selectionView = selectionView;
}

- (void)temperatureView {
  NSInteger selectedValue = kMinCelsius;
  if ([[self.selectedValue class] isSubclassOfClass:[NSNumber class]]) {
    selectedValue = [self.selectedValue integerValue];
  }
  ANPickerView *pickView = [[ANPickerView alloc] initWithMaxValue:kMaxCelsius
                                                         minValue:kMinCelsius
                                                 andSelectedValue:selectedValue];
  CGRect frame = self.backView.frame;
  frame.origin.y = 0;
  pickView.frame = frame;
  [self.backView addSubview:pickView];
  self.selectionView = pickView;
}

- (void)profilesView {
  UILabel *titleLabel = [self createTitleLabelWithTitle:NSLocalizedString(@"Profiles", @"Profiles")];

  CGRect frame = self.backView.frame;
  frame.origin.x = 20;
  frame.origin.y = CGRectGetMaxY(titleLabel.frame) + 8 + kTitleLabelTop;
  frame.size.width = CGRectGetWidth(frame) - 20 * 2;
  frame.size.height = CGRectGetHeight(frame) - CGRectGetMinY(frame) - 33;

  UICollectionViewFlowLayout *flowLayout = [ANSelectionView createLayoutWith:CGSizeMake(80, 81)
                                                                       frame:frame
                                                     andHorizontalItemNumber:3
                                                          verticalItemNumber:1];

  ANSelectionView *selectionView = [[ANSelectionView alloc] initWithFrame:frame
                                                     collectionViewLayout:flowLayout
                                                               itemTitles:kProfilesTitlesWithoutCustom
                                                           itemImageNames:kProfilesSelelctedIconsWithoutCustom
                                                   itemSelectedImageNames:kProfilesIconsWithoutCustom];
  __weak typeof(selectionView) weakSelectionView = selectionView;
  selectionView.selectItemAction = ^(UICollectionViewCell *cell, NSIndexPath *indexPath) {
    [weakSelectionView deselectAllItem];
    weakSelectionView.selectedItems = [@[[NSNumber numberWithInteger:indexPath.row]] mutableCopy];
    [weakSelectionView reloadData];
  };
  //TODO: get profiles
  selectionView.selectedItems = self.selectedValue;
  [self.backView addSubview:selectionView];
  self.selectionView = selectionView;
}

- (UILabel *)createTitleLabelWithTitle:(NSString *)string {
  CGFloat labelHeight = 18;
  UILabel *titleLabel = [[UILabel alloc] init];
  titleLabel.frame = CGRectMake(0, 25, CGRectGetWidth(self.backView.frame), labelHeight);
  titleLabel.text = string;
  titleLabel.textAlignment = NSTextAlignmentCenter;
  titleLabel.font = [UIFont boldSystemFontOfSize:labelHeight];
  [self.backView addSubview:titleLabel];
  return titleLabel;
}

#pragma mark - delegate
- (void)pickerViewDidSelectedRow:(NSInteger)rowValue {
  self.selectedValue = [NSNumber numberWithInteger:rowValue];
}

@end
