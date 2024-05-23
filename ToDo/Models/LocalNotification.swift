//
//  LocalNotification.swift
//  ToDo
//
//  Created by Igor L on 09/05/2024.
//

import Foundation

struct LocalNotification {
    // initialiser for timer interval trigger
    init(identifier: String, title: String, body: String, timeInterval: Double, repeats: Bool) {
        self.identifier = identifier
        self.scheduleType = .time
        self.title = title
        self.body = body
        self.timeInterval = timeInterval
        self.dateComponents = nil
        self.repeats = repeats
    }
    
    // initialiser for calendar trigger
    init(identifier: String, title: String, body: String, dateComponents: DateComponents, repeats: Bool) {
        self.identifier = identifier
        self.scheduleType = .calendar
        self.title = title
        self.body = body
        self.timeInterval = nil
        self.dateComponents = dateComponents
        self.repeats = repeats
    }
    
    enum ScheduleType {
        case time, calendar
    }
    
    var identifier: String
    var scheduleType: ScheduleType
    var title: String
    var body: String
    var timeInterval: Double?
    var dateComponents: DateComponents?
    var repeats: Bool
}
