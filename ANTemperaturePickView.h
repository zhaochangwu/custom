

#import "ANPickerView.h"

@interface ANTemperaturePickView : ANPickerView

@property(nonatomic, copy) NSString *unit;

- (void)saveCurrentUnit;
- (NSString *)currentSavedUnit;

@end
