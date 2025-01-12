import Foundation
import SMIClientCore

extension MessagingViewModel: ConversationClientDelegate {
    public func conversation(_ conversation: ConversationClient, didError error: Error) {
        print("Conversation error: \(error.localizedDescription)")
        DispatchQueue.main.async {
            self.isLoading = false
        }
    }
    
    public func conversation(_ conversation: ConversationClient, didReceiveMessage message: ConversationEntry) {
        print("Received message")
        DispatchQueue.main.async {
            self.isLoading = false
        }
    }
    
    public func conversation(_ conversation: ConversationClient, didSend entry: ConversationEntry) {
        // Message was successfully sent
        fetchAndUpdateConversation()
    }
    
    public func conversation(_ conversation: ConversationClient, didFailToSend entry: ConversationEntry, error: Error) {
        // Message failed to send
        print("Failed to send message: \(error.localizedDescription)")
    }
} 