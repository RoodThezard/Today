//
//  Meeting.swift
//  Today
//
//  Created by Rood-Landy Thezard on 6/8/22.
//

import Foundation

struct Meeting: Equatable, Identifiable {
    var id: String = UUID().uuidString
    var title: String
    var date: Date
    var description: String? = nil
    var host: String
    var attendees: String
    var hasPast: Bool = false
}

extension Array where Element == Meeting {
    func indexOfMeeting(with id: Meeting.ID) -> Self.Index {
        guard let index = firstIndex(where: { $0.id == id }) else {
            fatalError()
        }
        return index
    }

}

#if DEBUG
extension Meeting {
    static var sampleData = [
        Meeting(title: "Virtual Coffee Hours", date: Date().addingTimeInterval(800.0), description: "The Microsoft Ignite conference is Microsoft’s annual meeting specifically for enterprise professionals, services, and products Ignite offers its 25,000+ attendees priority access to technical training, new and innovative tools, and opportunities to network with peers and experts in the tech community.", host: "Darinka Chadwick", attendees: ["Colby Geraldine", "Dex Darcey", "Elsie Josh"].joined(separator: ", ")),
        
        Meeting(title: "Networking Tips and Tricks", date: Date().addingTimeInterval(14000.0), host: "Thom Valentine", attendees: ["Colby Geraldine", "Roddy Boone", "Rowena Rick", "Cary Guy", "Florrie Oakley", "Kevan Kathleen"].joined(separator: ", "), hasPast: true),
        
        Meeting(title: "Networking Keynote", date: Date().addingTimeInterval(24000.0), description: "Check tech specs in shared folder", host: "Juliana Joss", attendees: ["Colby Geraldine", "Dex Darcey", "Elsie Josh"].joined(separator: ", ")),
        
        Meeting(title: "Engineering Review", date: Date().addingTimeInterval(3200.0), host: "Drew Ozzy", attendees: ["Colby Geraldine", "Dex Darcey", "Elsie Josh", "Rowena Rick", "Cary Guy"].joined(separator: ", "), hasPast: true),
        
        Meeting(title: "Apple Keynote", date: Date().addingTimeInterval(60000.0), description: "Oracle Developer Live is a series of free virtual events that feature keynotes, technical sessions, hands-on labs, demos, and panels and participation in a live Q&A with experts.", host: "Raven Corrine", attendees: ["Colby Geraldine", "Rowena Rick", "Cary Guy"].joined(separator: ", ")),
        
        Meeting(title: "Drop In Resume & Career Help", date: Date().addingTimeInterval(72000.0), description: "v0.9 out on Friday", host: "Tamera Jayne", attendees: ["Florrie Oakley", "Dex Darcey", "Roddy Boone"].joined(separator: ", ")),
        
        Meeting(title: "Search Engine Optimization Strategies for Entrepreneurs", date: Date().addingTimeInterval(83000.0), host: "Darinka Chadwick", attendees: ["Colby Geraldine", "Roddy Boone"].joined(separator: ", ")),
        
        Meeting(title: "2022 Developer Week", date: Date().addingTimeInterval(92500.0), description: "Check tech specs in shared folder", host: "Roddy Boone", attendees: ["Juliana Joss", "Tamera Jayne", "Darinka Chadwick", "Thom Valentine"].joined(separator: ", ")),
        
        Meeting(title: "PyCon", date: Date().addingTimeInterval(101000.0), host: "Darinka Chadwick", attendees: ["Colby Geraldine", "Thom Valentine"].joined(separator: ", ")),
        
        Meeting(title: "Oracle Developer Live", date: Date().addingTimeInterval(120000.0), description: "Discuss trends with management", host: "Dex Darcey", attendees: ["Colby Geraldine", "Dex Darcey", "Darinka Chadwick", "Thom Valentine"].joined(separator: ", ")),
    ]
}
#endif
