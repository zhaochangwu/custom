
#import "ANTitleButton.h"

@implementation ANTitleButton

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
  }

  return self;
}

- (void)layoutSubviews {
  [super layoutSubviews];

  CGRect imageFrame;
  imageFrame.size.width = CGRectGetWidth(self.frame) / 3 * 2;
  imageFrame.origin.x = CGRectGetWidth(self.frame) / 6;
  imageFrame.origin.y = 0;
  imageFrame.size.height = imageFrame.size.width;
  self.imageView.frame = imageFrame;
  self.imageView.layer.cornerRadius = (imageFrame.size.width) / 2;

  CGRect titleFrame;
  titleFrame.size.height = CGRectGetHeight(self.frame) / 4;
  titleFrame.origin.x = 0;
  titleFrame.origin.y = self.frame.size.height - titleFrame.size.height;
  titleFrame.size.width = self.frame.size.width;
  self.titleLabel.textAlignment = NSTextAlignmentCenter;
  self.titleLabel.frame = titleFrame;
}

@end
