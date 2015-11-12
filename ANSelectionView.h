

#import <UIKit/UIKit.h>

typedef void(^selectItemActionBlock)(UICollectionViewCell *cell, NSIndexPath *indexPath);

@interface ANSelectionView : UIView

@property(nonatomic, copy) selectItemActionBlock selectItemAction;
@property(nonatomic, strong) NSMutableArray<__kindof NSNumber *> *selectedItems;

- (instancetype)initWithFrame:(CGRect)frame
         collectionViewLayout:(UICollectionViewFlowLayout *)flowLayout
                   itemTitles:(NSArray<__kindof NSString *> *)titles;

- (instancetype)initWithFrame:(CGRect)frame
         collectionViewLayout:(UICollectionViewFlowLayout *)flowLayout
                   itemTitles:(NSArray<__kindof NSString *> *)titles
               itemImageNames:(NSArray<__kindof NSString *> *)images
       itemSelectedImageNames:(NSArray<__kindof NSString *> *)selectedImages;

+ (UICollectionViewFlowLayout *)createLayoutWith:(CGSize)itemSize
                                           frame:(CGRect)frame
                         andHorizontalItemNumber:(int)horizontalItemNumber
                              verticalItemNumber:(int)verticalItemNumber;

- (NSMutableArray<__kindof NSNumber *> *)finalSelectedItems;
- (void)selectAllItems;
- (void)deselectAllItem;

- (void)reloadData;

@end
