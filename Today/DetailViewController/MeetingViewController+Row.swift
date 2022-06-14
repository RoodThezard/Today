//
//  MeetingViewController+Row.swift
//  Today
//
//  Created by Rood-Landy Thezard on 6/10/22.
//

import UIKit

extension MeetingViewController {
    enum Row: Hashable {
        case header(String)
        case viewDate
        case viewDescription
        case viewTime
        case viewTitle
        case viewHost
        case viewAttendees
        case editDate(Date)
        case editText(String?)
        
        var imageName: String? {
            switch self {
                case .viewDate: return "calendar.circle"
                case .viewDescription: return "square.and.pencil"
                case .viewTime: return "clock"
                case .viewHost: return "person"
                case .viewAttendees: return "person.2"
                default: return nil
            }
        }
        
        var image: UIImage? {
            guard let imageName = imageName else { return nil }
            let configuration = UIImage.SymbolConfiguration(textStyle: .headline)
            return UIImage(systemName: imageName, withConfiguration: configuration)
        }
        
        var textStyle: UIFont.TextStyle {
            switch self {
                case .viewTitle: return .headline
                default: return .subheadline
            }
        }
        
    }
}
