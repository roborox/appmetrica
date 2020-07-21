@objc(Appmetrica)
class Appmetrica: NSObject {
    @objc(reportUserProfile:)
    func reportUserProfile(profile:NSDictionary!) -> Void {
        var attrsArray:[YMMUserProfileUpdate] = []

        for (keyAny, _) in profile {
            let key = keyAny as! String
            if key.isEqual("name") {
                if profile[key] == nil {
                    attrsArray.append(YMMProfileAttribute.name().withValueReset())
                } else {
                    attrsArray.append(YMMProfileAttribute.name().withValue(profile[key] as? String))
                }
                // } else if key.isEqual("gender") {
            } else if key.isEqual("age") {
                if profile[key] == nil {
                    attrsArray.append(YMMProfileAttribute.birthDate().withValueReset())
                } else {
                    attrsArray.append(YMMProfileAttribute.birthDate().withAge(profile[key] as! UInt))
                }
            } else if key.isEqual("birthDate") {
                if profile[key] == nil {
                    attrsArray.append(YMMProfileAttribute.birthDate().withValueReset())
                } else {
                    // number of milliseconds since Unix epoch
                    let date = Date.init(timeIntervalSince1970: profile[key] as! Double)
                    let gregorian = NSCalendar(calendarIdentifier:NSCalendar.Identifier.gregorian)!
                    let dateComponents = gregorian.components([.day, .month, .year], from:date)
                    attrsArray.append(YMMProfileAttribute.birthDate().withDate(dateComponents: dateComponents))
                }
            } else if key.isEqual("notificationsEnabled") {
                if profile[key] == nil {
                    attrsArray.append(YMMProfileAttribute.notificationsEnabled().withValueReset())
                } else {
                    attrsArray.append(YMMProfileAttribute.notificationsEnabled().withValue(profile[key] as! Bool))
                }
            } else {
                // TODO: come up with a syntax solution to reset custom attributes. `null` will break type checking here
                if profile[key] is Bool {
                    attrsArray.append(YMMProfileAttribute.customBool(key).withValue(profile[key] as! Bool))
                } else if (profile[key] is NSNumber) {
                    attrsArray.append(YMMProfileAttribute.customNumber(key).withValue(profile[key] as! Double))
                    // [NSNumber numberWithInt:[attributes[key] intValue]]
                } else if (profile[key] is NSString) {
                    let value = profile[key] as! NSString
                    if value.hasPrefix("+") || value.hasPrefix("-") {
                        attrsArray.append(YMMProfileAttribute.customCounter(key).withDelta(value.doubleValue))
                    } else {
                        attrsArray.append(YMMProfileAttribute.customString(key).withValue(value as String))
                    }
                }
            }
         }

        let userProfile:YMMMutableUserProfile = YMMMutableUserProfile()
        userProfile.apply(from: attrsArray)
        YMMYandexMetrica.report(userProfile, onFailure:{ (error:Error) in })
    }
}
