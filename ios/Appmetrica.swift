@objc(Appmetrica)
class Appmetrica: NSObject {
    @objc(reportUserProfile:)
    func reportUserProfile(profile:NSDictionary!) -> Void {
        let attrsArray:NSMutableArray! = NSMutableArray.array()

        for key:String! in profile {
            if key.isEqual("name") {
                if attributes[key] == nil {
                    attrsArray.addObject(YMMProfileAttribute.name().withValueReset())
                } else {
                    attrsArray.addObject(YMMProfileAttribute.name().withValue(attributes[key]))
                }
            // } else if key.isEqual("gender") {
            } else if key.isEqual("age") {
                if attributes[key] == nil {
                    attrsArray.addObject(YMMProfileAttribute.birthDate().withValueReset())
                } else {
                    attrsArray.addObject(YMMProfileAttribute.birthDate().withAge(attributes[key].intValue()))
                }
            } else if key.isEqual("birthDate") {
                if attributes[key] == nil {
                    attrsArray.addObject(YMMProfileAttribute.birthDate().withValueReset())
                } else {
                    // number of milliseconds since Unix epoch
                    let date:NSDate! = attributes[key].date()
                    let gregorian:NSCalendar! = NSCalendar(calendarIdentifier:NSCalendarIdentifierGregorian)
                    let dateComponents:NSDateComponents! = gregorian.components((NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay), fromDate:date)
                    attrsArray.addObject(YMMProfileAttribute.birthDate().withDateComponents(dateComponents))
                }
            } else if key.isEqual("notificationsEnabled") {
                if attributes[key] == nil {
                    attrsArray.addObject(YMMProfileAttribute.notificationsEnabled().withValueReset())
                } else {
                    attrsArray.addObject(YMMProfileAttribute.notificationsEnabled().withValue(attributes[key].boolValue()))
                }
            } else {
                // TODO: come up with a syntax solution to reset custom attributes. `null` will break type checking here
                if attributes[key].isEqual(true) || attributes[key].isEqual(false) {
                    attrsArray.addObject(YMMProfileAttribute.customBool(key).withValue(attributes[key].boolValue()))
                } else if (attributes[key] is NSNumber) {
                    attrsArray.addObject(YMMProfileAttribute.customNumber(key).withValue(attributes[key].doubleValue()))
                    // [NSNumber numberWithInt:[attributes[key] intValue]]
                } else if (attributes[key] is NSString) {
                    if attributes[key].hasPrefix("+") || attributes[key].hasPrefix("-") {
                        attrsArray.addObject(YMMProfileAttribute.customCounter(key).withDelta(attributes[key].doubleValue()))
                    } else {
                        attrsArray.addObject(YMMProfileAttribute.customString(key).withValue(attributes[key]))
                    }
                }
            }
         }

        let userProfile:YMMMutableUserProfile! = YMMMutableUserProfile()
        userProfile.applyFromArray(attrsArray)
        YMMYandexMetrica.reportUserProfile(userProfile.copy(), onFailure:{ (error:NSError!) in
            NSLog("Error: %@", error)
        })
    }
}
