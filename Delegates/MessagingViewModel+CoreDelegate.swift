//
//  MessagingViewModel+CoreDelegate.swift
//  MessagingCoreExample
//

import Foundation
import SMIClientCore

/**
 Implementation of the CoreDelegate
 To learn more, see
 https://developer.salesforce.com/docs/service/messaging-in-app/guide/ios-core-sdk.html#listen-for-events
 */
extension MessagingViewModel: CoreDelegate {

    /// Received incoming conversation entries.
    public func core(_ core: CoreClient,
                     conversation: Conversation,
                     didReceiveEntries entries: [ConversationEntry],
                     paged: Bool) {
        guard conversation.identifier == self.conversationID else { return }
        
        updateConversationState(.loading)
        DispatchQueue.main.async {
            for entry in entries {
                self.observeableConversationData?.conversationEntries.append(entry)
            }
        }
        updateConversationState(.idle)
    }

    /// Message status has changed.
    public func core(_ core: CoreClient,
                     conversation: Conversation,
                     didUpdateEntries entries: [ConversationEntry]) {
        print("didUpdateEntries")
    }

    /// Conversation was created.
    public func core(_ core: CoreClient, didCreateConversation conversation: Conversation) {
        print("didCreateConversation")
    }

    /// Received a started typing event.
    public func core(_ core: CoreClient, didReceiveTypingStartedEvent event: ConversationEntry) {
        updateConversationState(.typing)
    }

    /// Received a stopped typing event.
    public func core(_ core: CoreClient, didReceiveTypingStoppedEvent event: ConversationEntry) {
        updateConversationState(.idle)
    }

    /// Network status has changed.
    public func core(_ core: CoreClient, didChangeNetworkState state: NetworkConnectivityState) {
        print("didChangeNetworkState")
    }

    /// Received an error message.
    public func core(_ core: CoreClient, didError error: Error) {
        let errorCode = (error as NSError).code
        let errorMessage = (error as NSError).localizedDescription
        print("Please check your deployment credentials")
        print(String(errorCode) + ": " + errorMessage)
    }
}

