

#import "ANSettingsCollectionViewCell.h"

@interface ANSettingsCollectionViewCell()

@property (weak, nonatomic) IBOutlet UILabel *cellTitle;

@end

@implementation ANSettingsCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setCellTitleWith:(NSString *)title{
  self.cellTitle.text = title;
}

@end
