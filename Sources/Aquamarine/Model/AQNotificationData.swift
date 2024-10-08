//
//  File.swift
//  
//
//  Created by PinkXaciD on R 6/09/06.
//

import SwiftUI

/// Notification data
public struct AQNotificationData: Identifiable {
    public let id: UUID = .init()
    let type: AQNotificationType
    let title: String
    let description: String?
    let localizedTitle: LocalizedStringKey?
    let localizedDescription: LocalizedStringKey?
    let icon: Image?
    let action: (() -> Void)?
    
    // Memberwise initializer
    private init(type: AQNotificationType, title: String, description: String?, localizedTitle: LocalizedStringKey?, localizedDescription: LocalizedStringKey?, icon: Image?, action: (() -> Void)?) {
        self.type = type
        self.title = title
        self.description = description
        self.localizedTitle = localizedTitle
        self.localizedDescription = localizedDescription
        self.icon = icon
        self.action = action
    }
}

// MARK: Notificaion type

public extension AQNotificationData {
    /// Notification type, which contains icon tint and haptic feedback.
    struct AQNotificationType: Equatable, Hashable {
        public let color: Color?
        public let haptic: UINotificationFeedbackGenerator.FeedbackType?
        
        /// Notification type that tints the icon red and plays "Error" haptic feedback.
        public static let error: Self = .init(iconColor: .red, haptic: .error)
        
        /// Notification type that tints the icon yellow and plays "Warning" haptic feedback.
        public static let warning: Self = .init(iconColor: .yellow, haptic: .warning)
        
        /// Notification type that tints icon green and plays "Success" haptic feedback.
        public static let success: Self = .init(iconColor: .green, haptic: .success)
        
        /// Notification type that tints icon tint color and has no haptic feedback.
        public static let info: Self = .init(iconColor: nil, haptic: nil)
        
        /// Creates a new notification type
        /// - Parameters:
        ///   - color: Icon tint color. Set to `nil` to use app tint color.
        ///   - haptic: Haptic feedback type. Set to `nil` to turn off haptic feedback.
        public init(iconColor color: Color? = nil, haptic: UINotificationFeedbackGenerator.FeedbackType? = nil) {
            self.color = color
            self.haptic = haptic
        }
    }
}

// MARK: Initializers
public extension AQNotificationData {
    // MARK: Localized initializers
    
    /// Creates a notification with a system image and a title and description generated from a localized string key.
    /// - Parameters:
    ///   - type: Notification type, which contains icon color and haptic feedback.
    ///   - titleKey: A title generated from a localized string.
    ///   - descriptionKey: A description generated from a localized string.
    ///   - action: Action to perform when user taps on the notification.
    init(
        _ type: AQNotificationType,
        _ titleKey: LocalizedStringKey,
        description descriptionKey: LocalizedStringKey? = nil,
        systemImage: String,
        action: (() -> Void)? = nil
    ) {
        self.type = type
        self.localizedTitle = titleKey
        self.localizedDescription = descriptionKey
        self.title = "\(titleKey)"
        self.description = nil
        self.icon = Image(systemName: systemImage)
        self.action = action
    }
    
    /// Creates a notification with an image and a title and description generated from a localized string key.
    /// - Parameters:
    ///   - type: Notification type, which contains icon color and haptic feedback.
    ///   - titleKey: A title generated from a localized string.
    ///   - descriptionKey: A description generated from a localized string.
    ///   - action: Action to perform when user taps on the notification.
    init(
        _ type: AQNotificationType,
        _ titleKey: LocalizedStringKey,
        description descriptionKey: LocalizedStringKey? = nil,
        image: String,
        action: (() -> Void)? = nil
    ) {
        self.type = type
        self.localizedTitle = titleKey
        self.localizedDescription = descriptionKey
        self.title = "\(titleKey)"
        self.description = nil
        self.icon = Image(image)
        self.action = action
    }
    
    /// Creates a notification with an image and a title and description generated from a localized string key.
    /// - Parameters:
    ///   - type: Notification type, which contains icon color and haptic feedback.
    ///   - titleKey: A title generated from a localized string.
    ///   - descriptionKey: A description generated from a localized string.
    ///   - action: Action to perform when user taps on the notification.
    @available(iOS 17, *)
    init(
        _ type: AQNotificationType,
        _ titleKey: LocalizedStringKey,
        description descriptionKey: LocalizedStringKey? = nil,
        image: ImageResource,
        action: (() -> Void)? = nil
    ) {
        self.type = type
        self.localizedTitle = titleKey
        self.localizedDescription = descriptionKey
        self.title = "\(titleKey)"
        self.description = nil
        self.icon = Image(image)
        self.action = action
    }
    
    /// Creates a notification with a title and description generated from a localized string key.
    /// - Parameters:
    ///   - type: Notification type, which contains icon color and haptic feedback.
    ///   - titleKey: A title generated from a localized string.
    ///   - descriptionKey: A description generated from a localized string.
    ///   - action: Action to perform when user taps on the notification.
    init(
        _ type: AQNotificationType,
        _ titleKey: LocalizedStringKey,
        description descriptionKey: LocalizedStringKey? = nil,
        action: (() -> Void)? = nil
    ) {
        self.type = type
        self.localizedTitle = titleKey
        self.localizedDescription = descriptionKey
        self.title = "\(titleKey)"
        self.description = nil
        self.icon = nil
        self.action = action
    }
    
    // MARK: String initializers
    
    /// Creates a notification with a system image and a title and description generated from a string.
    /// - Parameters:
    ///   - type: Notification type, which contains icon color and haptic feedback.
    ///   - title: A title generated from a string.
    ///   - description: A description generated from a string.
    ///   - action: Action to perform when user taps on the notification.
    init(
        _ type: AQNotificationType,
        _ title: String,
        description: String? = nil,
        systemImage: String,
        action: (() -> Void)? = nil
    ) {
        self.type = type
        self.title = title
        self.description = description
        self.localizedTitle = nil
        self.localizedDescription = nil
        self.icon = Image(systemName: systemImage)
        self.action = action
    }
    
    /// Creates a notification with an image and a title and description generated from a string.
    /// - Parameters:
    ///   - type: Notification type, which contains icon color and haptic feedback.
    ///   - title: A title generated from a string.
    ///   - description: A description generated from a string.
    ///   - action: Action to perform when user taps on the notification.
    init(
        _ type: AQNotificationType,
        _ title: String,
        description: String? = nil,
        image: String,
        action: (() -> Void)? = nil
    ) {
        self.type = type
        self.title = title
        self.description = description
        self.localizedTitle = nil
        self.localizedDescription = nil
        self.icon = Image(image)
        self.action = action
    }
    
    /// Creates a notification with an image and a title and description generated from a string.
    /// - Parameters:
    ///   - type: Notification type, which contains icon color and haptic feedback.
    ///   - title: A title generated from a string.
    ///   - description: A description generated from a string.
    ///   - action: Action to perform when user taps on the notification.
    @available(iOS 17.0, *)
    init(
        _ type: AQNotificationType,
        _ title: String,
        description: String? = nil,
        image: ImageResource,
        action: (() -> Void)? = nil
    ) {
        self.type = type
        self.title = title
        self.description = description
        self.localizedTitle = nil
        self.localizedDescription = nil
        self.icon = Image(image)
        self.action = action
    }
    
    /// Creates a notification with a title and description generated from a string.
    /// - Parameters:
    ///   - type: Notification type, which contains icon color and haptic feedback.
    ///   - title: A title generated from a string.
    ///   - description: A description generated from a string.
    ///   - action: Action to perform when user taps on the notification.
    init(
        _ type: AQNotificationType,
        _ title: String,
        description: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.type = type
        self.title = title
        self.description = description
        self.localizedTitle = nil
        self.localizedDescription = nil
        self.icon = nil
        self.action = action
    }
}
