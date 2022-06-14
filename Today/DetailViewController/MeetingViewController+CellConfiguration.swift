//
//  MeetingViewController+CellConfiguration.swift
//  Today
//
//  Created by Rood-Landy Thezard on 6/13/22.
//

import UIKit

extension MeetingViewController {
    func defaultConfiguration(for cell: UICollectionViewListCell, at row: Row) -> UIListContentConfiguration{
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = text(for: row)
        contentConfiguration.textProperties.font = UIFont.preferredFont(forTextStyle: row.textStyle)
        contentConfiguration.image = row.image
        return contentConfiguration
    }
    
    func headerConfiguration(for cell: UICollectionViewListCell, with title: String) -> UIListContentConfiguration {
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = title
        return contentConfiguration
    }
    
    func titleConfiguration(for cell: UICollectionViewListCell, with title: String?) -> TextFieldContentView.Configuration {
        var contentConfiguration = cell.textFieldConfiguration()
        contentConfiguration.text = title
        contentConfiguration.onChange = { [weak self] title in
            self?.workingMeeting.title = title
        }
        return contentConfiguration
    }
    
    func dateConfiguration(for cell: UICollectionViewListCell, with date: Date) -> DatePickerContentView.Configuration {
        var contentConfiguration = cell.datePickerConfiguration()
        contentConfiguration.date = date
        contentConfiguration.onChange = { [weak self] date in
            self?.workingMeeting.date = date
        }
        return contentConfiguration
    }
    
    func descriptionConfiguration(for cell: UICollectionViewListCell, with description: String?) -> TextViewContentView.Configuration {
        var contentConfiguration = cell.textViewConfiguration()
        contentConfiguration.text = description
        contentConfiguration.onChange = { [weak self] description in
            self?.workingMeeting.description = description
        }
        return contentConfiguration
    }
    
    func hostConfiguration(for cell: UICollectionViewListCell, with host: String?) -> TextFieldContentView.Configuration {
        var contentConfiguration = cell.textFieldConfiguration()
        contentConfiguration.text = host
        contentConfiguration.onChange = { [weak self] host in
            self?.workingMeeting.host = host
        }
        return contentConfiguration
    }
    
    func attendeesConfiguration(for cell: UICollectionViewListCell, with attendees: String?) -> TextViewContentView.Configuration {
        var contentConfiguration = cell.textViewConfiguration()
        contentConfiguration.text = attendees
        return contentConfiguration
    }
    
    
    func text(for row: Row) -> String? {
        switch row {
            case .viewDate: return meeting.date.dayText
            case .viewDescription: return meeting.description
            case .viewTime: return meeting.date.formatted(date: .omitted, time: .shortened)
            case .viewTitle: return meeting.title
            case .viewHost: return meeting.host
            case .viewAttendees: return meeting.attendees
            default: return nil
        }
    }
}
