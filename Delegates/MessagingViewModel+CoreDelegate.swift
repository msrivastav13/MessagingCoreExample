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
        
        DispatchQueue.main.async {
            for entry in entries {
                self.observeableConversationData?.conversationEntries.append(entry)
            }
            self.isWaitingForConversationConfirmation = false
        }
    }

    /// Message status has changed.
    public func core(_ core: CoreClient,
                     conversation: Conversation,
                     didUpdateEntries entries: [ConversationEntry]) {
        guard conversation.identifier == self.conversationID else { return }
        print("didUpdateEntries")
        DispatchQueue.main.async {
            self.isWaitingForConversationConfirmation = true
        }
    }

    /// Conversation was created.
    public func core(_ core: CoreClient, didCreateConversation conversation: Conversation) {
        guard conversation.identifier == self.conversationID else { return }
        print("didCreateConversation")
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

