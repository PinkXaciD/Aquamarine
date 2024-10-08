//
//  File.swift
//  
//
//  Created by PinkXaciD on R 6/09/06.
//

import SwiftUI

struct AQNotificationView: View {
    let data: AQNotificationData
    
    @StateObject
    private var viewModel: AQNotificationViewModel
    @State
    private var animate: Bool = false
    
    // MARK: iPad optimization
    @Environment(\.horizontalSizeClass)
    private var horizontalSizeClass
    private var notificationWidth: CGFloat {
        if horizontalSizeClass == .compact {
            return .infinity
        }
        
        let currentScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let windowBounds = currentScene?.windows.first(where: { $0.isKeyWindow })?.bounds
        return (windowBounds?.width ?? UIScreen.main.bounds.width) * 0.7
    }
    
    // MARK: For Dynamic Type
    @ScaledMetric
    var height: CGFloat = 80
    
    var maxNotificationViewHeight: CGFloat {
        let currentScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let windowBounds = currentScene?.windows.first(where: { $0.isKeyWindow })?.bounds
        return (windowBounds?.height ?? UIScreen.main.bounds.height) / 7
    }
    
    var realHeight: CGFloat {
        min(height, maxNotificationViewHeight)
    }
    
    @GestureState private var gestureState: CGFloat = 0
    @State private var gestureHeight: CGFloat = 0
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Material.regular)
                .shadow(radius: 5)
            
            HStack(spacing: 0) {
                if let icon = data.icon {
                    Group {
                        if let color = data.type.color {
                            icon
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .scaleEffect(animate ? 1 : 0.1)
                                .foregroundStyle(color)
                        } else {
                            icon
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .scaleEffect(animate ? 1 : 0.1)
                                .foregroundStyle(.tint)
                        }
                    }
                    .padding(.leading)
                    .padding(.vertical)
                    .frame(width: realHeight * 0.8)
                }
                
                text
            }
        }
        .frame(maxWidth: notificationWidth, maxHeight: realHeight)
        .scaleEffect(realHeight / (realHeight - gestureHeight), anchor: .top)
        .padding(.horizontal)
        .onAppear {
            withAnimation(.bouncy) {
                self.animate = true
            }
        }
        .onTapGesture {
            if let action = data.action {
                action()
            }
            
            viewModel.store.removeNotification(forID: data.id)
        }
        .gesture(dragGesture)
        .transition(.opacity.combined(with: .scale).combined(with: .move(edge: .top)))
    }
    
    private var dragGesture: some Gesture {
        DragGesture(minimumDistance: 1)
            .updating($gestureState) { value, state, transaction in
                transaction.animation = .smooth
                
                // Closing notification
                DispatchQueue.main.async {
                    if value.predictedEndTranslation.height < -realHeight {
                        viewModel.store.removeNotification(forID: data.id)
                    }
                    
                    if abs(value.translation.height) < realHeight {
                        if value.translation.height < 0 {
                            withAnimation(.smooth) {
                                gestureHeight = value.translation.height
                            }
                        } else {
                            withAnimation(.smooth) {
                                gestureHeight = value.translation.height / 15
                            }
                        }
                    }
                }
            }
            .onEnded { value in
                DispatchQueue.main.async {
                    withAnimation(.smooth) {
                        gestureHeight = 0
                    }
                }
            }
    }
    
    private var text: some View {
        HStack {
            // Check if localized parameters are available
            if let localizedTitle = data.localizedTitle {
                VStack(alignment: .leading) {
                    Text(localizedTitle)
                        .fontWeight(.bold)
                    
                    if let localizedDescription = data.localizedDescription {
                        Text(localizedDescription)
                            .lineLimit(2)
                    }
                }
                .padding(.vertical, 5)
                .minimumScaleFactor(0.5)
            } else {
                VStack(alignment: .leading) {
                    Text(data.title)
                        .fontWeight(.bold)
                    
                    if let description = data.description {
                        Text(description)
                            .lineLimit(2)
                    }
                }
                .padding(.vertical, 5)
                .minimumScaleFactor(0.5)
            }
            
            Spacer()
        }
        .padding(.horizontal)
    }
    
    init(data: AQNotificationData, store: AQNotificationStore) {
        self.data = data
        self._viewModel = StateObject(wrappedValue: AQNotificationViewModel(id: data.id, haptic: data.type.haptic, store: store))
    }
}

#if DEBUG
#Preview {
    AQNotificationPreview()
}

fileprivate struct AQNotificationPreview: View {
    @StateObject var store = AQNotificationStore()
    let string = "Test"
    
    var body: some View {
        VStack {
            ForEach(0..<10, id: \.self) { _ in
                Text("Some long text blahblahblahblahblah")
                    .foregroundColor(.red)
            }
            
            Spacer()
            
            Button("Show or hide") {
                for delay in [0, 0.2/*, 0.4, 0.6*/] {
                    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                        store.addNotification(.init(.info, "Title", description: "Description", systemImage: "macmini"))
                        store.addNotification(.init(.warning, "Title", description: "Description", systemImage: "exclamationmark"))
                        store.addNotification(.init(.error, "Title", description: "Description", systemImage: "exclamationmark.circle"))
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .aquamarineNotifications(store: store)
    }
}
#endif
