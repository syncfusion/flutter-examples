//
//  DeviceIdentifiers.m
//  device_info_plus
//
//  Created by Volodymyr on 06.11.2024.
//
#import "./include/device_info_plus/DeviceIdentifiers.h"

@implementation DeviceIdentifiers

+ (NSString *)userKnownDeviceModel:(NSString *)identifier {
  if ([identifier isEqualToString:@"iPhone6,1"]) {
    return @"iPhone 5s";
  } else if ([identifier isEqualToString:@"iPhone6,2"]) {
    return @"iPhone 5s";
  } else if ([identifier isEqualToString:@"iPhone7,2"]) {
    return @"iPhone 6";
  } else if ([identifier isEqualToString:@"iPhone7,1"]) {
    return @"iPhone 6 Plus";
  } else if ([identifier isEqualToString:@"iPhone8,1"]) {
    return @"iPhone 6s";
  } else if ([identifier isEqualToString:@"iPhone8,2"]) {
    return @"iPhone 6s Plus";
  } else if ([identifier isEqualToString:@"iPhone9,1"] ||
             [identifier isEqualToString:@"iPhone9,3"]) {
    return @"iPhone 7";
  } else if ([identifier isEqualToString:@"iPhone9,2"] ||
             [identifier isEqualToString:@"iPhone9,4"]) {
    return @"iPhone 7 Plus";
  } else if ([identifier isEqualToString:@"iPhone8,4"]) {
    return @"iPhone SE";
  } else if ([identifier isEqualToString:@"iPhone10,1"] ||
             [identifier isEqualToString:@"iPhone10,4"]) {
    return @"iPhone 8";
  } else if ([identifier isEqualToString:@"iPhone10,2"] ||
             [identifier isEqualToString:@"iPhone10,5"]) {
    return @"iPhone 8 Plus";
  } else if ([identifier isEqualToString:@"iPhone10,3"] ||
             [identifier isEqualToString:@"iPhone10,6"]) {
    return @"iPhone X";
  } else if ([identifier isEqualToString:@"iPhone11,2"]) {
    return @"iPhone XS";
  } else if ([identifier isEqualToString:@"iPhone11,4"] ||
             [identifier isEqualToString:@"iPhone11,6"]) {
    return @"iPhone XS Max";
  } else if ([identifier isEqualToString:@"iPhone11,8"]) {
    return @"iPhone XR";
  } else if ([identifier isEqualToString:@"iPhone12,1"]) {
    return @"iPhone 11";
  } else if ([identifier isEqualToString:@"iPhone12,3"]) {
    return @"iPhone 11 Pro";
  } else if ([identifier isEqualToString:@"iPhone12,5"]) {
    return @"iPhone 11 Pro Max";
  } else if ([identifier isEqualToString:@"iPhone12,8"]) {
    return @"iPhone SE 2";
  } else if ([identifier isEqualToString:@"iPhone13,2"]) {
    return @"iPhone 12";
  } else if ([identifier isEqualToString:@"iPhone13,1"]) {
    return @"iPhone 12 Mini";
  } else if ([identifier isEqualToString:@"iPhone13,3"]) {
    return @"iPhone 12 Pro";
  } else if ([identifier isEqualToString:@"iPhone13,4"]) {
    return @"iPhone 12 Pro Max";
  } else if ([identifier isEqualToString:@"iPhone14,5"]) {
    return @"iPhone 13";
  } else if ([identifier isEqualToString:@"iPhone14,4"]) {
    return @"iPhone 13 Mini";
  } else if ([identifier isEqualToString:@"iPhone14,2"]) {
    return @"iPhone 13 Pro";
  } else if ([identifier isEqualToString:@"iPhone14,3"]) {
    return @"iPhone 13 Pro Max";
  } else if ([identifier isEqualToString:@"iPhone14,6"]) {
    return @"iPhone SE 3";
  } else if ([identifier isEqualToString:@"iPhone14,7"]) {
    return @"iPhone 14";
  } else if ([identifier isEqualToString:@"iPhone14,8"]) {
    return @"iPhone 14 Plus";
  } else if ([identifier isEqualToString:@"iPhone15,2"]) {
    return @"iPhone 14 Pro";
  } else if ([identifier isEqualToString:@"iPhone15,3"]) {
    return @"iPhone 14 Pro Max";
  } else if ([identifier isEqualToString:@"iPhone15,4"]) {
    return @"iPhone 15";
  } else if ([identifier isEqualToString:@"iPhone15,5"]) {
    return @"iPhone 15 Plus";
  } else if ([identifier isEqualToString:@"iPhone16,1"]) {
    return @"iPhone 15 Pro";
  } else if ([identifier isEqualToString:@"iPhone16,2"]) {
    return @"iPhone 15 Pro Max";
  } else if ([identifier isEqualToString:@"iPhone17,3"]) {
    return @"iPhone 16";
  } else if ([identifier isEqualToString:@"iPhone17,4"]) {
    return @"iPhone 16 Plus";
  } else if ([identifier isEqualToString:@"iPhone17,1"]) {
    return @"iPhone 16 Pro";
  } else if ([identifier isEqualToString:@"iPhone17,2"]) {
    return @"iPhone 16 Pro Max";
  } else if ([identifier isEqualToString:@"iPhone17,5"]) {
    return @"iPhone 16e";
  } else if ([identifier isEqualToString:@"iPhone18,3"]) {
    return @"iPhone 17";
  } else if ([identifier isEqualToString:@"iPhone18,1"]) {
    return @"iPhone 17 Pro";
  } else if ([identifier isEqualToString:@"iPhone18,2"]) {
    return @"iPhone 17 Pro Max";
  } else if ([identifier isEqualToString:@"iPhone18,4"]) {
    return @"iPhone Air";
    // iPads
  } else if ([identifier isEqualToString:@"iPad4,1"] ||
             [identifier isEqualToString:@"iPad4,2"] ||
             [identifier isEqualToString:@"iPad4,3"]) {
    return @"iPad Air";
  } else if ([identifier isEqualToString:@"iPad5,3"] ||
             [identifier isEqualToString:@"iPad5,4"]) {
    return @"iPad Air 2";
  } else if ([identifier isEqualToString:@"iPad6,11"] ||
             [identifier isEqualToString:@"iPad6,12"]) {
    return @"iPad 5";
  } else if ([identifier isEqualToString:@"iPad7,5"] ||
             [identifier isEqualToString:@"iPad7,6"]) {
    return @"iPad 6";
  } else if ([identifier isEqualToString:@"iPad11,3"] ||
             [identifier isEqualToString:@"iPad11,4"]) {
    return @"iPad Air 3";
  } else if ([identifier isEqualToString:@"iPad7,11"] ||
             [identifier isEqualToString:@"iPad7,12"]) {
    return @"iPad 7";
  } else if ([identifier isEqualToString:@"iPad11,6"] ||
             [identifier isEqualToString:@"iPad11,7"]) {
    return @"iPad 8";
  } else if ([identifier isEqualToString:@"iPad12,1"] ||
             [identifier isEqualToString:@"iPad12,2"]) {
    return @"iPad 9";
  } else if ([identifier isEqualToString:@"iPad13,18"] ||
             [identifier isEqualToString:@"iPad13,19"]) {
    return @"iPad 10";
  } else if ([identifier isEqualToString:@"iPad13,1"] ||
             [identifier isEqualToString:@"iPad13,2"]) {
    return @"iPad Air 4";
  } else if ([identifier isEqualToString:@"iPad13,16"] ||
             [identifier isEqualToString:@"iPad13,17"]) {
    return @"iPad Air 5";
  } else if ([identifier isEqualToString:@"iPad14,8"] ||
             [identifier isEqualToString:@"iPad14,9"]) {
    return @"iPad Air 11-Inch M2";
  } else if ([identifier isEqualToString:@"iPad14,10"] ||
             [identifier isEqualToString:@"iPad14,11"]) {
    return @"iPad Air 13-Inch M2";
  } else if ([identifier isEqualToString:@"iPad2,5"] ||
             [identifier isEqualToString:@"iPad2,6"] ||
             [identifier isEqualToString:@"iPad2,7"]) {
    return @"iPad Mini";
  } else if ([identifier isEqualToString:@"iPad4,4"] ||
             [identifier isEqualToString:@"iPad4,5"] ||
             [identifier isEqualToString:@"iPad4,6"]) {
    return @"iPad Mini 2";
  } else if ([identifier isEqualToString:@"iPad4,7"] ||
             [identifier isEqualToString:@"iPad4,8"] ||
             [identifier isEqualToString:@"iPad4,9"]) {
    return @"iPad Mini 3";
  } else if ([identifier isEqualToString:@"iPad5,1"] ||
             [identifier isEqualToString:@"iPad5,2"]) {
    return @"iPad Mini 4";
  } else if ([identifier isEqualToString:@"iPad11,1"] ||
             [identifier isEqualToString:@"iPad11,2"]) {
    return @"iPad Mini 5";
  } else if ([identifier isEqualToString:@"iPad14,1"] ||
             [identifier isEqualToString:@"iPad14,2"]) {
    return @"iPad Mini 6";
  } else if ([identifier isEqualToString:@"iPad6,3"] ||
             [identifier isEqualToString:@"iPad6,4"]) {
    return @"iPad Pro 9-Inch";
  } else if ([identifier isEqualToString:@"iPad6,7"] ||
             [identifier isEqualToString:@"iPad6,8"]) {
    return @"iPad Pro 12-Inch";
  } else if ([identifier isEqualToString:@"iPad7,1"] ||
             [identifier isEqualToString:@"iPad7,2"]) {
    return @"iPad Pro 12-Inch 2";
  } else if ([identifier isEqualToString:@"iPad7,3"] ||
             [identifier isEqualToString:@"iPad7,4"]) {
    return @"iPad Pro 10-Inch";
  } else if ([identifier isEqualToString:@"iPad8,1"] ||
             [identifier isEqualToString:@"iPad8,2"] ||
             [identifier isEqualToString:@"iPad8,3"] ||
             [identifier isEqualToString:@"iPad8,4"]) {
    return @"iPad Pro 11-Inch";
  } else if ([identifier isEqualToString:@"iPad8,5"] ||
             [identifier isEqualToString:@"iPad8,6"] ||
             [identifier isEqualToString:@"iPad8,7"] ||
             [identifier isEqualToString:@"iPad8,8"]) {
    return @"iPad Pro 12-Inch 3";
  } else if ([identifier isEqualToString:@"iPad8,9"] ||
             [identifier isEqualToString:@"iPad8,10"]) {
    return @"iPad Pro 11-Inch 2";
  } else if ([identifier isEqualToString:@"iPad8,11"] ||
             [identifier isEqualToString:@"iPad8,12"]) {
    return @"iPad Pro 12-Inch 4";
  } else if ([identifier isEqualToString:@"iPad13,4"] ||
             [identifier isEqualToString:@"iPad13,5"] ||
             [identifier isEqualToString:@"iPad13,6"] ||
             [identifier isEqualToString:@"iPad13,7"]) {
    return @"iPad Pro 11-Inch 3";
  } else if ([identifier isEqualToString:@"iPad13,8"] ||
             [identifier isEqualToString:@"iPad13,9"] ||
             [identifier isEqualToString:@"iPad13,10"] ||
             [identifier isEqualToString:@"iPad13,11"]) {
    return @"iPad Pro 12-Inch 5";
  } else if ([identifier isEqualToString:@"iPad14,3"] ||
             [identifier isEqualToString:@"iPad14,4"]) {
    return @"iPad Pro 11-Inch 4";
  } else if ([identifier isEqualToString:@"iPad14,5"] ||
             [identifier isEqualToString:@"iPad14,6"]) {
    return @"iPad Pro 12-Inch 6";
  } else if ([identifier isEqualToString:@"iPad16,3"] ||
             [identifier isEqualToString:@"iPad16,4"]) {
    return @"iPad Pro 11-Inch (M4)";
  } else if ([identifier isEqualToString:@"iPad16,5"] ||
             [identifier isEqualToString:@"iPad16,6"]) {
    return @"iPad Pro 13-Inch (M4)";
  } else if ([identifier isEqualToString:@"iPad17,1"] ||
             [identifier isEqualToString:@"iPad17,2"]) {
    return @"iPad Pro 11-Inch (M5)";
  } else if ([identifier isEqualToString:@"iPad17,3"] ||
             [identifier isEqualToString:@"iPad17,4"]) {
    return @"iPad Pro 13-Inch (M5)";
  } else {
    return @"Unknown device";
  }
}
@end
