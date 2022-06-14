//
//  MeetingViewController+Section.swift
//  Today
//
//  Created by Rood-Landy Thezard on 6/10/22.
//

import Foundation

extension MeetingViewController {
    enum Section: Int, Hashable {
        case view
        case title
        case date
        case description
        case host
        case attendees
        
        var name: String {
            switch self {
                case .view: return ""
                case .title:
                    return NSLocalizedString("Title", comment: "Title section name")
                case .date:
                    return NSLocalizedString("Date", comment: "Date section name")
                case .description:
                    return NSLocalizedString("Description", comment: "Description section name")
                case .host:
                    return NSLocalizedString("Host", comment: "Host section name")
                case .attendees:
                    return NSLocalizedString("Attendees", comment: "Attendees section name")
                
            }
        }
    }
}
