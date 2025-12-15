import Foundation

// Models list is taken from support.apple.com and https://theapplewiki.com/wiki/Models
// Example of the list with models https://support.apple.com/en-us/102869

func getMacModelName(modelNumber: String) -> String {
    switch modelNumber {
    // MacBook models (2015 and later)
    case "MacBook8,1": return "MacBook (12-inch, 2015)"
    case "MacBook9,1": return "MacBook (12-inch, 2016)"
    case "MacBook10,1": return "MacBook (12-inch, 2017)"

    // MacBook Air models (2013 and later)
    case "MacBookAir6,1": return "MacBook Air (11-inch, 2013)"
    case "MacBookAir6,2": return "MacBook Air (13-inch, 2013)"
    case "MacBookAir7,1": return "MacBook Air (11-inch, 2015)"
    case "MacBookAir7,2": return "MacBook Air (13-inch, 2015-2017)"
    case "MacBookAir8,1": return "MacBook Air (13-inch, 2018)"
    case "MacBookAir8,2": return "MacBook Air (13-inch, 2019)"
    case "MacBookAir9,1": return "MacBook Air (13-inch, 2020)"
    case "MacBookAir10,1": return "MacBook Air (13-inch, 2020)"
    case "Mac14,2": return "MacBook Air (13-inch, 2022)"
    case "Mac14,15": return "MacBook Air (15-inch, 2023)"
    case "Mac15,12": return "MacBook Air (13-inch, 2024)"
    case "Mac15,13": return "MacBook Air (15-inch, 2024)"
    case "Mac16,12": return "MacBook Air (13-inch, 2025)"
    case "Mac16,13": return "MacBook Air (15-inch, 2025)"

    // MacBook Pro models (2012 and later)
    case "MacBookPro10,1": return "MacBook Pro (15-inch, 2012-2013)"
    case "MacBookPro10,2": return "MacBook Pro (13-inch, 2012-2013)"
    case "MacBookPro11,1": return "MacBook Pro (13-inch, 2013-2014)"
    case "MacBookPro11,2", "MacBookPro11,3": return "MacBook Pro (15-inch, 2013-2014)"
    case "MacBookPro11,4", "MacBookPro11,5": return "MacBook Pro (15-inch, 2015)"
    case "MacBookPro12,1": return "MacBook Pro (13-inch, 2015)"
    case "MacBookPro13,1": return "MacBook Pro (13-inch, 2016)"
    case "MacBookPro13,2": return "MacBook Pro (13-inch, 2016)"
    case "MacBookPro13,3": return "MacBook Pro (15-inch, 2016)"
    case "MacBookPro14,1": return "MacBook Pro (13-inch, 2017)"
    case "MacBookPro14,2": return "MacBook Pro (13-inch, 2017)"
    case "MacBookPro14,3": return "MacBook Pro (15-inch, 2017)"
    case "MacBookPro15,1", "MacBookPro15,3": return "MacBook Pro (15-inch, 2018-2019)"
    case "MacBookPro15,2": return "MacBook Pro (13-inch, 2018-2019)"
    case "MacBookPro15,4": return "MacBook Pro (13-inch, 2019)"
    case "MacBookPro16,1", "MacBookPro16,4": return "MacBook Pro (16-inch, 2019)"
    case "MacBookPro16,2": return "MacBook Pro (13-inch, 2019)"
    case "MacBookPro16,3": return "MacBook Pro (13-inch, 2020)"
    case "MacBookPro17,1": return "MacBook Pro (13-inch, 2020)"
    case "MacBookPro18,1": return "MacBook Pro (14-inch, 2021)"
    case "MacBookPro18,2": return "MacBook Pro (16-inch, 2021)"
    case "MacBookPro18,3": return "MacBook Pro (16-inch, 2021)"
    case "Mac14,5", "Mac14,9": return "MacBook Pro (14-inch, 2023)"
    case "Mac14,6", "Mac14,10": return "MacBook Pro (14-inch, 2023)"
    case "Mac14,7": return "MacBook Pro (13-inch, 2022)"
    case "Mac15,3": return "MacBook Pro (14-inch, 2023)"
    case "Mac15,6", "Mac15,8", "Mac15,10": return "MacBook Pro (14-inch, 2023)"
    case "Mac15,7", "Mac15,9", "Mac15,11": return "MacBook Pro (16-inch, 2023)"
    case "Mac16,1", "Mac16,6", "Mac16,8": return "MacBook Pro (14-inch, 2024)"
    case "Mac16,5", "Mac16,7": return "MacBook Pro (16-inch, 2024)"
    case "Mac17,2": return "MacBook Pro (14-inch, 2025)"

    // iMac models (2013 and later)
    case "iMac13,1": return "iMac (21.5-inch, 2013)"
    case "iMac13,2": return "iMac (27-inch, 2013)"
    case "iMac14,1": return "iMac (21.5-inch, 2014)"
    case "iMac14,2": return "iMac (27-inch, 2014)"
    case "iMac14,4": return "iMac (21.5-inch, 2014)"
    case "iMac15,1": return "iMac (27-inch, 2014-2015)"
    case "iMac16,1","iMac16,2": return "iMac (21.5-inch, 2015)"
    case "iMac17,1": return "iMac (27-inch, 2015)"
    case "iMac18,1": return "iMac (21.5-inch, 2017)"
    case "iMac18,2": return "iMac (21.5-inch, 2017)"
    case "iMac18,3": return "iMac (27-inch, 2017)"
    case "iMac19,1": return "iMac (27-inch, 2019)"
    case "iMac19,2": return "iMac (21.5-inch, 2019)"
    case "iMac20,1", "iMac20,2": return "iMac (27-inch, 2020)"
    case "iMac21,1", "iMac21,2": return "iMac (24-inch, 2021)"
    case "Mac15,4", "Mac15,5": return "iMac (24-inch, 2023)"
    case "Mac16,2", "Mac16,3": return "iMac (24-inch, 2024)"

    // Mac mini models (2012 and later)
    case "MacMini6,1", "MacMini6,2": return "Mac mini (2012)"
    case "MacMini7,1": return "Mac mini (2014)"
    case "MacMini8,1": return "Mac mini (2018)"
    case "MacMini9,1": return "Mac mini (2020)"
    case "Mac14,12": return "Mac mini (2023)"
    case "Mac14,3": return "Mac mini (2023)"
    case "Mac16,11", "Mac16,10": return "Mac mini (2024)"

    // Mac Pro models (2013 and later)
    case "MacPro6,1": return "Mac Pro (Late 2013)"
    case "MacPro7,1": return "Mac Pro (2019)"
    case "Mac14,8": return "Mac Pro (2023)"

    // iMac Pro
    case "iMacPro1,1": return "iMac Pro (2017)"

    // Mac Studio (2022 and newer)
    case "Mac13,1", "Mac13,2": return "Mac Studio (2022)"
    case "Mac14,13", "Mac14,14": return "Mac Studio (2023)"
    case "Mac15,14", "Mac16,9": return "Mac Studio (2025)"

    default: return "Unknown Model"
    }
}
