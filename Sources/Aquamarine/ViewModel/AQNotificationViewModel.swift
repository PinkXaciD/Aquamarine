//
//  File.swift
//  
//
//  Created by PinkXaciD on R 6/09/06.
//

import SwiftUI
import Combine

internal final class AQNotificationViewModel: ObservableObject {
    let id: UUID
    let store: AQNotificationStore
    
    var timerSubscription: AnyCancellable? = nil
    
    init(id: UUID, haptic: UINotificationFeedbackGenerator.FeedbackType?, store: AQNotificationStore) {
        self.id = id
        self.store = store
        self.timerSubscription = Timer.publish(every: store.duration, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                if let id = self?.id {
                    self?.store.removeNotification(forID: id)
                }
            }
        
        if let haptic {
            UINotificationFeedbackGenerator().notificationOccurred(haptic)
        }
    }
    
    deinit {
        timerSubscription?.cancel()
    }
}
