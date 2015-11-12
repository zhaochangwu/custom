
#import <UIKit/UIKit.h>

#define kWeekArray                               \
  @[                                             \
    NSLocalizedString(@"Su", @"Sunday Abbr"),    \
    NSLocalizedString(@"Mo", @"Monday Abbr"),    \
    NSLocalizedString(@"Tu", @"Tuesday Abbr"),   \
    NSLocalizedString(@"We", @"Wednesday Abbr"), \
    NSLocalizedString(@"Th", @"Thursday Abbr"),  \
    NSLocalizedString(@"Fr", @"Friday Abbr"),    \
    NSLocalizedString(@"Sa", @"Saturday Abbr")   \
  ]

#define kProfilePower NSLocalizedString(@"Power", @"ProfilePower")
#define kProfileEco NSLocalizedString(@"Eco", @"ProfileEco")
#define kProfileSleep NSLocalizedString(@"Sleep", @"ProfileSleep")
#define kProfileCustom NSLocalizedString(@"Custom", @"ProfileCustom")

#define kProfileImagePower @"icon_default-Power"
#define kProfileImageEco @"icon_default-Eco"
#define kProfileImageSleep @"icon_default-Sleep"
#define kProfileImageCustom @"icon_default-Custom"

#define kProfileSelectedImagePower @"icon_selected-Power"
#define kProfileSelectedImageEco @"icon_selected-Eco"
#define kProfileSelectedImageSleep @"icon_selected-Sleep"
#define kProfileSelectedImageCustom @"icon_selected-Custom"

#define kProfilesTitlesWithoutCustom @[kProfilePower, kProfileEco, kProfileSleep]
#define kProfilesIconsWithoutCustom @[kProfileImagePower, kProfileImageEco, kProfileImageSleep]
#define kProfilesSelelctedIconsWithoutCustom \
  @[kProfileSelectedImagePower, kProfileSelectedImageEco, kProfileSelectedImageSleep]

typedef NS_ENUM(NSInteger, ANSelectedViewControllerType) {
  ANSelectedViewControllerTypeNone = -1,
  ANSelectedViewControllerTypeWeeklyRepeat,//(NSMutableArray<NSNumber *> *selectedValue
  ANSelectedViewControllerTypeTemperature,
  ANSelectedViewControllerTypeProfiles     //(NSMutableArray<NSNumber *> *selectedValue
};

typedef void(^goBackBlock)(id selectedValue);// NSArray:WeeklyRepeat; NSNumber:Temperature; NSString:Profiles

@interface ANSelectedViewController : UIViewController

@property(nonatomic, copy) goBackBlock goBackAction;

- (instancetype)initWithType:(ANSelectedViewControllerType)type andSelectedValue:(id)selectedValue;

@end
