//
//  LocalNotifManager.swift
//  ToDo
//
//  Created by Igor L on 07/05/2024.
//

import Foundation
import UserNotifications

@Observable
class LocalNotifManager {
    let notififcationCenter = UNUserNotificationCenter.current()
    var isGranted = false
    
    func requestAuthorisation() async throws {
        try await notififcationCenter
            .requestAuthorization(options: [.alert, .sound, .badge])
        
        await getCurrentSettings()
    }
    
    func getCurrentSettings() async {
        let currentSettings = await notififcationCenter.notificationSettings()
        
        isGranted = (currentSettings.authorizationStatus == .authorized)
    }
    
    func schedule(localNotif: LocalNotification) async {
        let content = UNMutableNotificationContent()
        content.title = localNotif.title
        content.body = localNotif.body
        content.sound = .default
        
        if localNotif.scheduleType == .time {
            guard let timeInterval = localNotif.timeInterval else { return }
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval,
                                                            repeats: localNotif.repeats)
            
            let request = UNNotificationRequest(identifier: localNotif.identifier,
                                                content: content,
                                                trigger: trigger)
            try? await notififcationCenter.add(request)
        } else {
            guard let dateComponents = localNotif.dateComponents else { return }
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, 
                                                        repeats: localNotif.repeats)
            
            let request = UNNotificationRequest(identifier: localNotif.identifier,
                                                content: content,
                                                trigger: trigger)
            try? await notififcationCenter.add(request)
        }
    }
}
