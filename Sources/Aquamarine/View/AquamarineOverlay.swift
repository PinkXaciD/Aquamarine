//
//  File.swift
//  
//
//  Created by PinkXaciD on R 6/09/06.
//

import SwiftUI

struct AquamarineOverlay: View {
    @ObservedObject
    var store: AQNotificationStore
    
    var body: some View {
        VStack(spacing: 10) {
            ForEach(store.notifications.reversed()) { notification in
                AQNotificationView(data: notification, store: store)
            }
        }
    }
}
