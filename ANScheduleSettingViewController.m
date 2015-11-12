

#import "ANScheduleSettingViewController.h"
#import "AylaDevice+ANSchedule.h"
#import "AylaDevice+CustomProperty.h"
#import "ANDeviceManager.h"
#import "ANSelectedViewController.h"
#import <AylaSchedule.h>
#import <AylaScheduleActionSupport.h>

#define kRepeatCell 0
#define kTemperatureCell 1
#define kProfilesCell 2

#define kSegmentedControlIndexSwitchOn 0
#define kSegmentedControlIndexSwitchOff 1

@interface ANScheduleSettingViewController ()

@property(weak, nonatomic) IBOutlet UISegmentedControl *switchControl;
@property(weak, nonatomic) IBOutlet UIDatePicker *timePicker;

@property(weak, nonatomic) IBOutlet UILabel *repeatLabel;
@property(weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property(weak, nonatomic) IBOutlet UILabel *profileLabel;

@end

@implementation ANScheduleSettingViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  [self setDefaultData];
}

- (void)setDefaultData {

  if (self.schedule) {
    NSString *start = self.schedule.startTimeEachDay;
    NSDate *date = [[AylaDevice timeFormatter] dateFromString:start];
    self.timePicker.date = date;

    NSArray *weeklyRepeat = self.schedule.daysOfWeek;
    NSMutableString *weekString = [NSMutableString string];
    [weeklyRepeat enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
      NSUInteger index = [obj unsignedIntegerValue] - 1;
      [weekString appendFormat:@"%@,", [kWeekArray objectAtIndex:index]];
    }];
    self.repeatLabel.text = weekString;

  }

}

#pragma mark - UITableView
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];

  if (indexPath.section == 1) {
    ANSelectedViewControllerType type = ANSelectedViewControllerTypeNone;
    id selectedValue = nil;
    void (^block)(id selectedValue) = nil;
    __weak typeof(self) weakSelf = self;
    switch (indexPath.row) {
      case kRepeatCell: {
        type = ANSelectedViewControllerTypeWeeklyRepeat;
        selectedValue = self.schedule.daysOfWeek;
        block = ^(NSArray *selectedValue) {
          __strong typeof(weakSelf) strongSelf = weakSelf;

          NSMutableArray *daysofWeek = [NSMutableArray array];
          [selectedValue enumerateObjectsUsingBlock:^(NSNumber *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            NSNumber *dayNum = [NSNumber numberWithUnsignedInteger:(obj.unsignedIntegerValue + 1)];
            [daysofWeek addObject:dayNum];
          }];
          strongSelf.schedule.daysOfWeek = daysofWeek; // update the data

          NSMutableString *string = [NSMutableString string];
          [selectedValue enumerateObjectsUsingBlock:^(NSNumber *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            [string appendFormat:@"%@,", [kWeekArray objectAtIndex:obj.unsignedIntegerValue]];
          }];
          strongSelf.repeatLabel.text = string; // update UI
        };
      } break;

      case kTemperatureCell: {
        type = ANSelectedViewControllerTypeTemperature;
        selectedValue = @29;//TODO: get the seletvalue
        block = ^(id selectedValue) {
          __strong typeof(weakSelf) strongSelf = weakSelf;
          strongSelf.temperatureLabel.text = [NSString stringWithFormat:@"%@", selectedValue];
        };
      } break;

      case kProfilesCell: {
        type = ANSelectedViewControllerTypeProfiles;
        selectedValue = [@[@1] mutableCopy];//TODO: get the seletvalue
        block = ^(NSArray *selectedValue) {
          __strong typeof(weakSelf) strongSelf = weakSelf;
          NSInteger index = [(NSNumber *)selectedValue.firstObject integerValue];
          strongSelf.profileLabel.text = [kProfilesTitlesWithoutCustom objectAtIndex:index];
        };
      } break;

      default:
        break;
    }
    ANSelectedViewController *vc =
      [[ANSelectedViewController alloc] initWithType:type andSelectedValue:selectedValue];
    vc.goBackAction = block;

    [self presentViewController:vc animated:NO completion:nil];
  }
}

#pragma mark - navgation item
- (IBAction)save:(UIBarButtonItem *)sender {
  [self updateFireTime];
  [self updateSwitchAction];
//  [self updateTemperatureAction];
//  [self updateProfileAction];
}

- (IBAction)goBack:(UIBarButtonItem *)sender {
  [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - set schedule
- (void)updateFireTime { //time selected ,repeat
  if (!self.schedule) {
    self.schedule = [[AylaSchedule alloc] init];
    self.schedule.direction = @"input";
    self.schedule.startDate = [[AylaDevice dateFormatter] stringFromDate:[NSDate date]];
    self.schedule.endDate = [[AylaDevice dateFormatter] stringFromDate:[NSDate dateWithTimeIntervalSinceNow:60*60*24*7]];
    self.schedule.duration = @14400;
    self.schedule.interval = @86400;
    self.schedule.active = @1;
    //TODO: create schedule
  } else {
    [self updateSchedule];
  }
}

- (void)updateSwitchAction {
  NSString *propertyName = [[ANDeviceManager currentDevice] switchPropertyName];
  NSInteger index = self.switchControl.selectedSegmentIndex;
  NSString *value = [NSString stringWithFormat:@"%i", !index];
  [self updateActionWithPropertyName:propertyName andPropertyValue:value];
}

- (void)updateTemperatureAction {
//  NSString * propertyName = [[ANDeviceManager currentDevice] primaryPropertyName];
//  [self updateActionWithpropertyName:propertyName propertyValue:@1];
}

- (void)updateProfileAction {
//  NSString * propertyName = [[ANDeviceManager currentDevice] secondaryPropertyName];
//  [self updateActionWithpropertyName:propertyName propertyValue:@1];
}

- (void)updateActionWithPropertyName:(NSString *)propertyName andPropertyValue:(NSString *)value {
  AylaScheduleAction *action = self.schedule.scheduleActions[self.switchControl.selectedSegmentIndex];
  action.value = value;
  [action update:nil
    success:^(AylaResponse *response, AylaScheduleAction *scheduleAction) {
      [self updateFireTime];
    }
    failure:^(AylaError *err){

    }];
}

- (void)updateSchedule {
  
  NSString *pickerTime = [[AylaDevice timeFormatter] stringFromDate:self.timePicker.date];
  if (self.switchControl.selectedSegmentIndex == kSegmentedControlIndexSwitchOn) {
    self.schedule.startTimeEachDay = pickerTime;
  } else if (self.switchControl.selectedSegmentIndex == kSegmentedControlIndexSwitchOff) {
    self.schedule.endTimeEachDay = pickerTime;
  }

  [self.schedule update:[ANDeviceManager currentDevice] success:^(AylaResponse *response, AylaSchedule *schedule) {
    [self goBack:nil];
  } failure:^(AylaError *err) {
  }];
}

@end
