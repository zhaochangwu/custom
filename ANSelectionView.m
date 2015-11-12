

#import "ANSelectionView.h"
#import "ANConstants.h"
#import "ANSelectionWeekCell.h"
#import "ANSelectionDefaultCell.h"

static NSString *const reuseIdentifier = @"Cell";

@interface ANSelectionView () <UICollectionViewDataSource, UICollectionViewDelegate>

@property(nonatomic, weak) UICollectionView *collectionView;
@property(nonatomic, strong) NSArray<__kindof NSString *> *data;
@property(nonatomic, strong) NSArray<__kindof NSString *> *itemSelectedImageNames;
@property(nonatomic, strong) NSArray<__kindof NSString *> *itemImageNames;

@end

@implementation ANSelectionView

- (instancetype)initWithFrame:(CGRect)frame
         collectionViewLayout:(UICollectionViewFlowLayout *)flowLayout
                   itemTitles:(NSArray<__kindof NSString *> *)titles
               itemImageNames:(NSArray<__kindof NSString *> *)images
       itemSelectedImageNames:(NSArray<__kindof NSString *> *)selectedImages {
  self = [super initWithFrame:frame];
  if (self) {
    self.itemImageNames = images;
    self.itemSelectedImageNames = selectedImages;
    self.data = titles;
    self.userInteractionEnabled = YES;
    [self createCollectionViewWithFrame:frame andCollectionViewLayout:flowLayout];
    [self updateCollectionViewFrame];

  }
  return self;
}

- (instancetype)initWithFrame:(CGRect)frame
         collectionViewLayout:(UICollectionViewFlowLayout *)flowLayout
                   itemTitles:(NSArray<__kindof NSString *> *)titles {
  return [self initWithFrame:frame
        collectionViewLayout:flowLayout
                  itemTitles:titles
              itemImageNames:nil
      itemSelectedImageNames:nil];
}

- (void)setFrame:(CGRect)frame {
  [super setFrame:frame];
  [self updateCollectionViewFrame];
}

- (void)updateCollectionViewFrame {
  CGRect collectionViewFrame = self.frame;
  collectionViewFrame.origin.x = 0;
  collectionViewFrame.origin.y = 0;
  self.collectionView.frame = collectionViewFrame;
}

- (void)createCollectionViewWithFrame:(CGRect)frame
              andCollectionViewLayout:(UICollectionViewFlowLayout *)flowLayout {
  UICollectionView *collectView =
    [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:flowLayout];
  collectView.backgroundColor = [UIColor clearColor];
  collectView.delegate = self;
  collectView.dataSource = self;
  [self addSubview:collectView];
  self.collectionView = collectView;

  Class cell = [ANSelectionViewCell class];
  if (IsEmpty(self.itemImageNames)) {
    cell = [ANSelectionWeekCell class];
  } else {
    cell = [ANSelectionDefaultCell class];
  }
  [collectView registerClass:cell forCellWithReuseIdentifier:reuseIdentifier];
}

#pragma mark - UICollectionViewDataSource
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
  ANSelectionViewCell *cell =
    [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];

  cell.title = self.data[indexPath.row];
  cell.tag = indexPath.row + 100;

  if (self.itemImageNames && self.itemImageNames.count > indexPath.row) {
    cell.imageName = self.itemImageNames[indexPath.row];
  }

  if (self.itemSelectedImageNames && self.itemSelectedImageNames.count > indexPath.row) {
    cell.selectedImageName = self.itemSelectedImageNames[indexPath.row];
  }

  if (self.selectedItems) {
    [self.selectedItems  enumerateObjectsUsingBlock:^(__kindof NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
      if (indexPath.row == obj.integerValue) {
        cell.buttonSelected = YES;
        *stop = YES;
      } else {
        cell.buttonSelected = NO;
      }
    }];
  }

  return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
  if (IsEmpty(self.data)) {
    return 1;
  }
  return [self.data count];
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (void)collectionView:(UICollectionView *)collectionView
  didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
  UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
  if (self.selectItemAction) {
    self.selectItemAction(cell, indexPath);
  }
  [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

#pragma mark - select related

- (NSMutableArray<NSNumber *> *)finalSelectedItems {
  NSArray *cells = self.collectionView.visibleCells;
  NSMutableArray *selectedItems = [NSMutableArray array];
  [cells enumerateObjectsUsingBlock:^(ANSelectionViewCell *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
    NSLog(@"%d", obj.buttonSelected);
    if (obj.buttonSelected == YES) {
      [selectedItems addObject:[NSNumber numberWithUnsignedInteger:obj.tag - 100]];
    }
  }];
  return [[selectedItems sortedArrayUsingSelector:@selector(compare:)] mutableCopy];
}

- (void)selectAllItems {
  if (self.data) {
    [self deselectAllItem];
    [self.data enumerateObjectsUsingBlock:^(__kindof NSString *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
      [self.selectedItems addObject:[NSNumber numberWithUnsignedInteger:idx]];
    }];
  }
}

- (void)deselectAllItem {
  if (!self.selectedItems) {
    self.selectedItems = [NSMutableArray array];
  } else {
    [self.selectedItems removeAllObjects];
  }
}

+ (UICollectionViewFlowLayout *)createLayoutWith:(CGSize)itemSize
                                           frame:(CGRect)frame
                         andHorizontalItemNumber:(int)horizontalItemNumber
                              verticalItemNumber:(int)verticalItemNumber {
  UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
  flowLayout.itemSize = itemSize;
  if (horizontalItemNumber > 1) {
    flowLayout.minimumInteritemSpacing =
      (CGRectGetWidth(frame) - itemSize.width * horizontalItemNumber) / (horizontalItemNumber - 1);
  }
  if (verticalItemNumber > 1) {
    flowLayout.minimumLineSpacing =
      (CGRectGetHeight(frame) - itemSize.height * verticalItemNumber) / (verticalItemNumber - 1);
  }
  return flowLayout;
}

- (void)reloadData {
  [self.collectionView reloadData];
}

@end
