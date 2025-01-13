import Foundation
import SMIClientCore

extension MessagingViewModel: ConversationClientDelegate {
    public func conversation(_ conversation: ConversationClient, didError error: Error) {
        print("Conversation error: \(error.localizedDescription)")
        updateConversationState(.idle)
    }
    
    public func conversation(_ conversation: ConversationClient, didReceiveMessage message: ConversationEntry) {
        updateConversationState(.idle)
        
        // Force a UI refresh by toggling a state
        self.objectWillChange.send()
        
        if !self.isFetchingConversation {
            self.fetchAndUpdateConversation()
        }
    }
    
    public func conversation(_ conversation: ConversationClient, didSend entry: ConversationEntry) {
        updateConversationState(.loading)
        self.fetchAndUpdateConversation()
    }
    
    public func conversation(_ conversation: ConversationClient, didFailToSend entry: ConversationEntry, error: Error) {
        print("Failed to send message: \(error.localizedDescription)")
        updateConversationState(.idle)
    }
} 