

#import "ANTemperaturePickView.h"
#import "ANConstants.h"

@interface ANTemperaturePickView ()

@property(nonatomic, weak) UILabel *unitLabel;

@end

@implementation ANTemperaturePickView

- (void)awakeFromNib {
  [super awakeFromNib];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
  return CGRectGetHeight(self.frame) / 2;
}

- (UIView *)pickerView:(UIPickerView *)pickerView
            viewForRow:(NSInteger)row
          forComponent:(NSInteger)component
           reusingView:(UIView *)view {
  UILabel *label = (UILabel *)view;
  if (!label) {
    CGFloat fontSize = CGRectGetHeight(self.frame) / 2;
    label = [[UILabel alloc] init];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:fontSize weight:0.1f];
  }
  label.text = [self pickerView:pickerView titleForRow:row forComponent:component];
  return label;
}

- (void)drawRect:(CGRect)rect {
  CGRect labelFrame = rect;
  labelFrame.origin.y = CGRectGetHeight(self.frame) / 4 - 18;
  UILabel *label = [[UILabel alloc] init];
  label.frame = labelFrame;
  label.backgroundColor = [UIColor clearColor];
  label.textAlignment = NSTextAlignmentRight;
  label.textColor = [UIColor whiteColor];
  label.font = [UIFont systemFontOfSize:19];
  if (IsEmpty(self.unit)) {
    label.text = @"℃";
  } else {
    label.text = self.unit;
  }
  [self addSubview:label];
  self.unitLabel = label;
}

- (void)setUnit:(NSString *)unit {
  _unit = unit;
  self.unitLabel.text = unit;
}

- (void)saveCurrentUnit {
  if (IsEmpty(self.unit)) {
    self.unit = PICKER_CELSIUS_UNIT;
  }
  [[NSUserDefaults standardUserDefaults] setObject:self.unit forKey:SELECTED_UNIT];
}

- (NSString *)currentSavedUnit {
  return [[NSUserDefaults standardUserDefaults] stringForKey:SELECTED_UNIT];
}

@end
