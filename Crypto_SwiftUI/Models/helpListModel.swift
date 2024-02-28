    import Foundation
    import Firebase

    struct HelpListModel: Identifiable, Codable{
        var id: String // Use timestamp as id
        var title: String
        var description: String
        var status: String
        var timestamp: Timestamp?
        var imageData: Data?

        enum CodingKeys: String, CodingKey {
            case id
            case title
            case description
            case status
            case timestamp
            case imageData // Updated field name
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            id = UUID().uuidString // Generate a UUID as a string for id
            title = try container.decode(String.self, forKey: .title)
            description = try container.decode(String.self, forKey: .description)
            status = try container.decode(String.self, forKey: .status)
            timestamp = try? container.decode(Timestamp.self, forKey: .timestamp)
            imageData = try? container.decode(Data.self, forKey: .imageData) // Updated field name

        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(id, forKey: .id)
            try container.encode(title, forKey: .title)
            try container.encode(description, forKey: .description)
            try container.encode(status, forKey: .status)
            try? container.encode(timestamp, forKey: .timestamp)
            try? container.encode(imageData, forKey: .imageData) // Updated field name

        }
    }
