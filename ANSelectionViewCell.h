

#import <UIKit/UIKit.h>

@interface ANSelectionViewCell : UICollectionViewCell

@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *imageName;
@property(nonatomic, copy) NSString *selectedImageName;
@property(nonatomic) BOOL buttonSelected;
@property(nonatomic, strong) UIColor *titleColor;
@property(nonatomic, strong) UIColor *selectedTitleColor;

@end
