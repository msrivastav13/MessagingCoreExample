//
//  ContentView.swift
//  MessagingCoreExample
//

import SwiftUI
import SMIClientCore

class ObserveableConversationEntries: ObservableObject {
    @Published var conversationEntries: [ConversationEntry] = []
}

struct ContentView: View {
    @State private var isChatFeedHidden = true
    @State private var messageInputText: String = ""
    @State private var businessHoursMessage: String?
    @State private var shouldHideBusinessHoursBanner: Bool = true
    @State private var isWithinBusinessHours: Bool = false
    @State private var showEndChatConfirmation = false
    @ObservedObject var observeableConversationData: ObserveableConversationEntries
    @ObservedObject var viewModel: MessagingViewModel

    init(isChatFeedHidden: Bool = true, messageInputText: String = "") {
        self.isChatFeedHidden = isChatFeedHidden
        self.messageInputText = messageInputText
        let observableEntries = ObserveableConversationEntries()
        self.observeableConversationData = observableEntries
        self.viewModel = MessagingViewModel(observeableConversationData: observableEntries)
    }

    var body: some View {
        if !isChatFeedHidden {
            ChatFeed
        } else {
            ChatMenu
        }
    }

    private var ChatMenu: some View {
        ZStack {
            // Sunset gradient background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.98, green: 0.68, blue: 0.24),  // Warm orange
                    Color(red: 0.95, green: 0.45, blue: 0.25),  // Coral
                    Color(red: 0.45, green: 0.12, blue: 0.38)   // Deep purple
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                // Welcome Section
                VStack(spacing: 16) {
                    Text("Welcome to Coral Cloud Resort,")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Text("your ultimate tropical escape\nnested in the heart of paradise.")
                        .font(.system(size: 24))
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .padding(.top, 60)
                .padding(.bottom, 40)
                
                // Activities Section
                VStack(spacing: 8) {
                    Text("Discover Our Activities")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                        .padding(.bottom, 10)
                    
                    ScrollView {
                        VStack(spacing: 20) {
                            ActivityCard(title: "Canyon Zip Line", icon: "figure.climbing")
                            ActivityCard(title: "Mountain Climbing", icon: "mountain.2.fill")
                            ActivityCard(title: "Off-Road Safari", icon: "car.fill")
                            ActivityCard(title: "Cave Exploration", icon: "flashlight.on.fill")
                            ActivityCard(title: "Water Rafting", icon: "water.waves")
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical, 20)
                
                Spacer()
                
                // Chat button
                Button(action: {
                    isChatFeedHidden.toggle()
                    viewModel.fetchAndUpdateConversation()
                }) {
                    HStack {
                        Image(systemName: "message.fill")
                            .font(.system(size: 20))
                        Text("Need Help? Talk to Our Agent")
                            .font(.headline)
                    }
                    .padding(.horizontal, 32)
                    .padding(.vertical, 16)
                    .background(Color.white)
                    .clipShape(Capsule())
                    .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                }
                .padding(.bottom, 30)
            }
        }
        .overlay(
            Group {
                if viewModel.isLoading {
                    LoadingOverlay()
                }
            }
        )
    }

    // Activity Card View
    private struct ActivityCard: View {
        let title: String
        let icon: String
        
        var body: some View {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(Color(red: 0.45, green: 0.12, blue: 0.38))
                    .frame(width: 50, height: 50)
                    .background(Color.white)
                    .clipShape(Circle())
                
                Text(title)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.white.opacity(0.7))
            }
            .padding()
            .background(Color.white.opacity(0.2))
            .cornerRadius(15)
        }
    }

    private var ChatFeed: some View {
        ZStack {
            // Sunset gradient background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.98, green: 0.68, blue: 0.24),  // Warm orange
                    Color(red: 0.95, green: 0.45, blue: 0.25),  // Coral
                    Color(red: 0.45, green: 0.12, blue: 0.38)   // Deep purple
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack {
                // Add this new HStack for the top navigation bar
                HStack {
                    Button(action: {
                        isChatFeedHidden.toggle()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    Text("Coral Cloud Agent")
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: {
                        showEndChatConfirmation = true
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "phone.down.fill")
                                .font(.system(size: 16))
                            Text("End Session")
                                .font(.system(size: 14, weight: .medium))
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.red.opacity(0.8))
                        .foregroundColor(.white)
                        .cornerRadius(16)
                    }
                    .alert("End Agent Session", isPresented: $showEndChatConfirmation) {
                        Button("Cancel", role: .cancel) { }
                        Button("End Session", role: .destructive) {
                            viewModel.endConversation()
                            isChatFeedHidden.toggle()
                        }
                    } message: {
                        Text("Are you sure you want to end this agent session? This action cannot be undone.")
                    }
                }
                .padding()
                .background(Color(red: 0.45, green: 0.12, blue: 0.38).opacity(0.9))
                
                // Business hours banner
                if !shouldHideBusinessHoursBanner {
                    Text(businessHoursMessage ?? "Not within business hours")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(isWithinBusinessHours ? 
                            Color.green.opacity(0.8) : 
                            Color.red.opacity(0.8))
                        .foregroundColor(.white)
                }
                
                // Chat messages
                ChatFeedList
                    .onAppear {
                        viewModel.checkIfWithinBusinessHours(completion: { isWithinBusinessHours, isBusinessHoursConfigured in
                            DispatchQueue.main.async {
                                self.shouldHideBusinessHoursBanner = !isBusinessHoursConfigured
                                self.isWithinBusinessHours = isWithinBusinessHours
                                self.businessHoursMessage = isWithinBusinessHours ? 
                                    "You are within business hours" : 
                                    "You are not within business hours"
                            }
                        })
                    }
                
                // Message input area
                VStack(spacing: 12) {
                    HStack {
                        TextField("Type a Message", text: $messageInputText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(Color.white)
                            .cornerRadius(20)
                        
                        Button(action: {
                            guard !messageInputText.isEmpty else { return }
                            viewModel.sendTextMessage(message: messageInputText) { success in
                                DispatchQueue.main.async {
                                    if success {
                                        messageInputText = ""
                                    }
                                }
                            }
                        }) {
                            Image(systemName: "arrow.up.circle.fill")
                                .font(.system(size: 32))
                                .foregroundColor(.white)
                        }
                        .disabled(messageInputText.isEmpty)
                    }
                    .padding(.horizontal)
                    
                    Button(action: {
                        isChatFeedHidden.toggle()
                    }) {
                        Text("Back to Menu")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background(Color.white.opacity(0.2))
                            .clipShape(Capsule())
                    }
                    .padding(.bottom, 8)
                }
                .padding(.vertical, 8)
                .background(Color(red: 0.45, green: 0.12, blue: 0.38).opacity(0.9))
            }
        }
        .overlay(
            Group {
                if viewModel.isLoading {
                    LoadingOverlay()
                }
            }
        )
    }

    private var ChatFeedList: some View {
        ScrollViewReader { scrollView in
            ScrollView {
                LazyVStack {
                    ForEach(observeableConversationData.conversationEntries, id: \.identifier) { message in
                        switch message.format {
                        case .textMessage:
                            if let textMessage = message.payload as? TextMessage {
                                TextMessageCell(
                                    text: textMessage.text,
                                    role: message.sender.role,
                                    timestamp: message.timestamp
                                )
                                .id(message.identifier)
                            }
                        default:
                            EmptyView()
                        }
                    }
                }
                .padding(.vertical, 12)
            }
            .onChange(of: observeableConversationData.conversationEntries.count) { _ in
                if let lastMessage = observeableConversationData.conversationEntries.last {
                    withAnimation {
                        scrollView.scrollTo(lastMessage.identifier, anchor: .bottom)
                    }
                }
            }
        }
    }

    private struct TextMessageCell: View {
        var text: String
        var role: ParticipantRole
        var timestamp: Date
        
        var body: some View {
            VStack(alignment: role == .user ? .trailing : .leading, spacing: 4) {
                HStack {
                    if role == .user {
                        Spacer()
                    }
                    
                    VStack(alignment: role == .user ? .trailing : .leading, spacing: 4) {
                        Text(text)
                            .font(.system(size: 16, weight: .regular))
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(backgroundColor)
                            .foregroundColor(foregroundColor)
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 2)
                        
                        TimeStampView(date: timestamp)
                            .padding(.horizontal, 8)
                    }
                    
                    if role != .user {
                        Spacer()
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 4)
            }
        }
        
        private var backgroundColor: Color {
            switch role {
            case .user:
                return Color.white
            case .agent, .chatbot:
                return Color.white.opacity(0.9)
            default:
                return Color(.systemGray6)
            }
        }
        
        private var foregroundColor: Color {
            switch role {
            case .user:
                return Color(red: 0.45, green: 0.12, blue: 0.38)  // Deep purple
            default:
                return Color.black.opacity(0.85)
            }
        }
    }

    struct TimeStampView: View {
        let date: Date
        
        var body: some View {
            Text(formatTimestamp(date))
                .font(.system(size: 12))
                .foregroundColor(.white)
                .padding(.horizontal, 8)
                .padding(.vertical, 2)
                .background(Color.black.opacity(0.2))
                .cornerRadius(10)
        }
        
        private func formatTimestamp(_ date: Date) -> String {
            let formatter = DateFormatter()
            if Calendar.current.isDateInToday(date) {
                formatter.dateFormat = "h:mm a"
            } else {
                formatter.dateFormat = "MMM d, h:mm a"
            }
            return formatter.string(from: date)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(isChatFeedHidden: true, messageInputText: "")
    }
}

struct FancyButtonStyle: ButtonStyle {
    func makeBody(configuration: ButtonStyle.Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.white)
            .foregroundColor(Color(red: 0.45, green: 0.12, blue: 0.38))
            .clipShape(Capsule())
            .shadow(color: Color.black.opacity(0.2), radius: 10)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

extension View {
    @ViewBuilder func isHidden(_ hidden: Bool, remove: Bool = false) -> some View {
        if hidden {
            if !remove {
                self.hidden()
            }
        } else {
            self
        }
    }
}

struct LoadingOverlay: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
            
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                .scaleEffect(1.5)
        }
    }
}

