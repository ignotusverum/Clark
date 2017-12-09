//
//  CountryInput.h
//  consumer
//
//  Created by Vladislav Zagorodnyuk on 1/20/16
//

#import <UIKit/UIKit.h>
#import "CountryPicker.h"

@class CountryInput;

// picker height 180 + "Done" toolbar 44 = 224
#define COUNTRYINPUTHEIGHT 224.0

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

@protocol CountryInputDelegate <NSObject>

@optional
- (void) countryInputWillShow:(CountryInput *)picker;
- (void) countryInputDidShow:(CountryInput *)picker;
- (void) countryInputWillHide:(CountryInput *)picker;
- (void) countryInputDidHide:(CountryInput *)picker;
- (void) countryInputSelectionChanged:(CountryInput *)picker;

@end


@interface CountryInput : UIView <CountryPickerDelegate>

- (void) presentPicker;
- (void) updateStyle:(BOOL)isLight;
- (void) dismissPicker:(BOOL)animated;
- (void) setSelectedCountryCode:(NSString *)countryCode animated:(BOOL)animated;
- (UIImage *) imageForCountryCode:(NSString *)countryCode;

@property BOOL pickerOpen;
@property (nonatomic, strong) NSString * selectedCountryCode;
@property (nonatomic, strong) NSString * selectedCountryName;
@property (nonatomic, strong) IBOutlet UIView * viewForPicker;
@property (nonatomic, strong) IBOutlet id<CountryInputDelegate> delegate;

@end
