import Foundation

public struct SystemUUID {
    
    public static func getSystemUUID() -> String? {
        let dev = IOServiceMatching("IOPlatformExpertDevice")
        
        var platformExpert: io_service_t
        if #available(macOS 12, *) {
            platformExpert = IOServiceGetMatchingService(kIOMainPortDefault, dev)
        } else {
            platformExpert = IOServiceGetMatchingService(kIOMasterPortDefault, dev)
        }
        
        let serialNumberAsCFString = IORegistryEntryCreateCFProperty(platformExpert, kIOPlatformUUIDKey as CFString, kCFAllocatorDefault, 0)
        IOObjectRelease(platformExpert)
        let ser: CFTypeRef? = serialNumberAsCFString?.takeUnretainedValue()
        if let result = ser as? String {
            return result
        }
        return nil
    }
}
