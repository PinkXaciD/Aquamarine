//
//  File.swift
//  
//
//  Created by PinkXaciD on R 6/09/06.
//

import SwiftUI

/// An object that handles operations with notifications
public class AQNotificationStore: ObservableObject {
    @Published
    var notifications: [AQNotificationData]
    
    let duration: Double
    
    /// Creates a new notification store with provided parameters
    /// - Parameter duration: Delay in seconds between notification appearance and disappearance
    public init(closeDelay duration: TimeInterval = 3) {
        self.notifications = []
        self.duration = duration
    }
    
    /// Standard notification store
    public static let standard = AQNotificationStore()
    
    /// Adds a notification to the stack
    /// - Parameter notification: Parameters for notification
    public func addNotification(_ notification: AQNotificationData) {
        withAnimation(.bouncy) {
            self.notifications.append(notification)
        }
    }
    
    /// Removes notification from stack
    /// - Parameter id: ID of notification to be removed
    public func removeNotification(forID id: UUID) {
        if !self.notifications.isEmpty {
            withAnimation(.bouncy) {
                notifications.removeAll(where: { $0.id == id })
            }
        }
    }
    
    /// Removes all notifications from stack
    public func removeAll() {
        if !self.notifications.isEmpty {
            withAnimation(.bouncy) {
                notifications.removeAll()
            }
        }
    }
}
