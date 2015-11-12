

#import "ANSelectionDefaultCell.h"
#import "ANTitleButton.h"
#import "UIColor+ANUtils.h"

@interface ANSelectionDefaultCell ()

@property (nonatomic, weak)ANTitleButton *button;

@end

@implementation ANSelectionDefaultCell

- (instancetype)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    [self createUI];
  }
  return self;
}

- (void)createUI {
  ANTitleButton *button = [ANTitleButton buttonWithType:UIButtonTypeCustom];
  button.frame = self.bounds;
  button.adjustsImageWhenHighlighted = NO;
  button.userInteractionEnabled = NO;
  button.titleLabel.font = [UIFont systemFontOfSize:18];
  [button setTitleColor:[UIColor defaultGrayColor] forState:UIControlStateNormal];
  [button setTitleColor:[UIColor defaultBlockColor] forState:UIControlStateSelected];
//  button.layer.borderWidth = 2.0f;
//  button.layer.borderColor = [UIColor naviColor].CGColor;
  [self.contentView addSubview:button];
  self.button = button;
}

- (void)setTitle:(NSString *)title {
  [super setTitle:title];
  [self.button setTitle:title forState:UIControlStateNormal];
}

- (void)setImageName:(NSString *)imageName {
  [super setImageName:imageName];
  [self.button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

- (void)setSelectedImageName:(NSString *)selectedImageName {
  [super setSelectedImageName:selectedImageName];
  [self.button setImage:[UIImage imageNamed:selectedImageName] forState:UIControlStateSelected];
}

- (void)setButtonSelected:(BOOL)buttonSelected {
  [super buttonSelected];
  self.button.selected = buttonSelected;
}

- (BOOL)buttonSelected {
  return self.button.selected;
}

@end
