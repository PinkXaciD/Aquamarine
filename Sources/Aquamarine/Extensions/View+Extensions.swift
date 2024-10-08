//
//  File.swift
//  
//
//  Created by PinkXaciD on R 6/09/06.
//

import SwiftUI

extension View {
    /// Adds a notification overlay on top of the View
    /// - Parameter store: `AQNotificationStore` to monitor
    /// - Returns: A view with a notification overlay
    ///
    /// - Important: Due to a strong reference to the notification store that is passed, the notification store will persist until the `View` to which it is connected no longer exists.
    public func aquamarineNotifications(store: AQNotificationStore = .standard) -> some View {
        return self
            .overlay(alignment: .top) {
                AquamarineOverlay(store: store)
            }
    }
}
