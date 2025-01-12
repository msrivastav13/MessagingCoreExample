class MessagingViewModel: ObservableObject, ConversationClientDelegate {
    func conversationClient(_ client: ConversationClient, didReceiveMessage message: Message) {
        // Handle received message
        messages.append(message)
    }
    
    func conversationClient(_ client: ConversationClient, didReceiveError error: Error) {
        // Handle error
        print("Conversation client error: \(error)")
    }
} 