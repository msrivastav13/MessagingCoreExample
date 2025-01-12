import Foundation
import SMIClientCore

class MessagingService {
    private let baseURL: String
    
    init(configURL: URL) {
        // Read the config file to get the base URL
        guard let data = try? Data(contentsOf: configURL),
              let config = try? JSONDecoder().decode(ConfigResponse.self, from: data) else {
            self.baseURL = ""
            return
        }
        self.baseURL = config.scrtURL
    }
}

// Config response structure
private struct ConfigResponse: Codable {
    let scrtURL: String
    
    enum CodingKeys: String, CodingKey {
        case scrtURL = "scrt_url"
    }
} 