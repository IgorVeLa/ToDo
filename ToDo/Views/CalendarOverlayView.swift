//
//  CalendarOverlayView.swift
//  ToDo
//
//  Created by Igor L on 06/06/2024.
//

import Foundation
import SwiftUI

struct CalendarOverlayView: View {
    @Binding var showDueDate: Bool
    @Binding var selectedDate: Date?
    @Binding var selectedDateDisplay: Date
    var cancelDueDate: () -> Void
    var onDateChange: () -> Void
    
    var body: some View {
        if showDueDate {
            CancelButton(cancelMethod: cancelDueDate)
        }
        
        Text((showDueDate ? selectedDate?.formatted(.dateTime.day().month().year()) : "")!)
        Image(systemName: "calendar")
            .overlay {
                DateOverlay(selectedDateDisplay: $selectedDateDisplay)
            }
            .onChange(of: selectedDateDisplay) {
                onDateChange()
            }
        
        Text((showDueDate ? selectedDate?.formatted(.dateTime.hour().minute()) : "")!)
        Image(systemName: "clock")
            .overlay {
                TimeOverlay(selectedDateDisplay: $selectedDateDisplay)
            }
            .onChange(of: selectedDateDisplay) {
                onDateChange()
            }
    }
}

struct DateOverlay: View {
    @Binding var selectedDateDisplay: Date
    
    var body: some View {
        DatePicker(
            "",
            selection: $selectedDateDisplay,
            in: Date.now...,
            displayedComponents: [.date]
        )
        .blendMode(.destinationOver)
    }
}

struct TimeOverlay: View {
    @Binding var selectedDateDisplay: Date
    
    var body: some View {
        DatePicker(
            "",
            selection: $selectedDateDisplay,
            in: Date.now...,
            displayedComponents: [.hourAndMinute]
        )
        .blendMode(.destinationOver)
    }
}

struct CancelButton: View {
    var cancelMethod: ()  -> Void
    
    var body: some View {
        Button("\(Image(systemName: "xmark.circle"))") {
            cancelMethod()
        }
        .buttonStyle(BorderlessButtonStyle())
    }
}
