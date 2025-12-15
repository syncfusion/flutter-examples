// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "./include/device_info_plus/FPPDeviceInfoPlusPlugin.h"
#import "./include/device_info_plus/DeviceIdentifiers.h"
#import <mach/mach.h>
#import <sys/utsname.h>

@implementation FPPDeviceInfoPlusPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
  FlutterMethodChannel *channel = [FlutterMethodChannel
      methodChannelWithName:@"dev.fluttercommunity.plus/device_info"
            binaryMessenger:[registrar messenger]];
  FPPDeviceInfoPlusPlugin *instance = [[FPPDeviceInfoPlusPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall *)call
                  result:(FlutterResult)result {
  if ([@"getDeviceInfo" isEqualToString:call.method]) {
    UIDevice *device = [UIDevice currentDevice];
    struct utsname un;
    uname(&un);

    NSNumber *isPhysicalNumber =
        [NSNumber numberWithBool:[self isDevicePhysical]];
    NSProcessInfo *info = [NSProcessInfo processInfo];
    NSNumber *isiOSAppOnMac = [NSNumber numberWithBool:NO];
    if (@available(iOS 14.0, *)) {
      isiOSAppOnMac = [NSNumber numberWithBool:[info isiOSAppOnMac]];
    }
    NSError *error = nil;
    NSDictionary *fsAttributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:&error];
    NSNumber *freeSize = [NSNumber numberWithInt:-1];
    NSNumber *totalSize = [NSNumber numberWithInt:-1];
    if(fsAttributes) {
        freeSize = fsAttributes[NSFileSystemFreeSize];
        totalSize = fsAttributes[NSFileSystemSize];
    }

    NSString *machine;
    NSString *deviceName;
    if ([self isDevicePhysical]) {
      machine = @(un.machine);
    } else {
      machine = [info environment][@"SIMULATOR_MODEL_IDENTIFIER"];
    }
    deviceName = [DeviceIdentifiers userKnownDeviceModel:machine];

    NSNumber *physicalRamSize = @([NSProcessInfo processInfo].physicalMemory / 1048576); // Mb
    NSNumber *availableRamSize = @([self availableMemoryInbMB]);

    result(@{
      @"name" : [device name],
      @"systemName" : [device systemName],
      @"systemVersion" : [device systemVersion],
      @"model" : [device model],
      @"localizedModel" : [device localizedModel],
      @"modelName" : deviceName,
      @"identifierForVendor" : [[device identifierForVendor] UUIDString]
          ?: [NSNull null],
      @"freeDiskSize" : freeSize,
      @"totalDiskSize" : totalSize,
      @"isPhysicalDevice" : isPhysicalNumber,
      @"isiOSAppOnMac" : isiOSAppOnMac,
      @"physicalRamSize" : physicalRamSize,
      @"availableRamSize" : availableRamSize,
      @"utsname" : @{
        @"sysname" : @(un.sysname),
        @"nodename" : @(un.nodename),
        @"release" : @(un.release),
        @"version" : @(un.version),
        @"machine" : machine,
      }
    });
  } else {
    result(FlutterMethodNotImplemented);
  }
}

// Return available memory in megabytes
- (int)availableMemoryInbMB {
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);

    vm_size_t page_size;
    host_page_size(host_port, &page_size);

    vm_statistics_data_t vm_stat;
    if (host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size) != KERN_SUCCESS) {
        // Failed to fetch vm statistics
        return -1;
    }

    natural_t mem_free = vm_stat.free_count * page_size;
    return mem_free / 1048576;
}

// Return value is false if code is run on a simulator
- (BOOL)isDevicePhysical {
  BOOL isPhysicalDevice = NO;
#if TARGET_OS_SIMULATOR
  isPhysicalDevice = NO;
#else
  isPhysicalDevice = YES;
#endif

  return isPhysicalDevice;
}

@end
