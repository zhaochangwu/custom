

#import "ANSelectionWeekCell.h"
#import "UIColor+ANUtils.h"
#import "UIImage+Additions.h"

@interface ANSelectionWeekCell ()

@property (nonatomic, weak)UIButton *button;

@end

@implementation ANSelectionWeekCell

- (instancetype)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    [self createButtonWithFrame:frame];
  }
  return self;
}

- (void)setButtonSelected:(BOOL)buttonSelected {
  [super setButtonSelected:buttonSelected];
  self.button.selected = buttonSelected;
}


- (BOOL)buttonSelected {
  return self.button.selected;
}

- (void)setTitle:(NSString *)title {
  [super setTitle:title];
  [self.button setTitle:title forState:UIControlStateNormal];
}

- (void)setFrame:(CGRect)frame {
  [super setFrame:frame];
  frame.origin.x = 0;
  frame.origin.y = 0;
  self.button.frame = frame;
}

- (void)createButtonWithFrame:(CGRect)frame {
  UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
  button.userInteractionEnabled = NO;
  frame.origin.x = 0;
  frame.origin.y = 0;
  button.frame = frame;
  button.selected = YES;
  button.adjustsImageWhenHighlighted = NO;
  [button setBackgroundImage:[self defaultBackgroundImage] forState:UIControlStateNormal];
  [button setBackgroundImage:[self selectedBackgroundImage] forState:UIControlStateSelected];
  [button setTitleColor:[self defaultTitleColor] forState:UIControlStateNormal];
  [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
  button.layer.borderColor = [self borderColor].CGColor;
  button.layer.borderWidth = 2.0f;
  button.clipsToBounds = YES;
  button.layer.cornerRadius = CGRectGetHeight(frame)/2;
  [self.contentView addSubview:button];
  self.button = button;
}

- (UIImage *)selectedBackgroundImage {
  return [UIImage navigationBarBackgroundImage];
}

- (UIImage *)defaultBackgroundImage {
  return [UIImage imageWithColor:[UIColor stringToColor:@"#ffffff" alpha:0.9f]];
}

- (UIColor *)defaultTitleColor {
  return [UIColor stringToColor:@"#999999"];
}

- (UIColor *)borderColor {
  return [UIColor stringToColor:@"#dddddd"];
}

@end
