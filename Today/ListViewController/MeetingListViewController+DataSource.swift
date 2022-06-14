//
//  ReminderListViewController+DataSource.swift
//  Today
//
//  Created by Rood-Landy Thezard on 6/9/22.
//

import UIKit

//This extension will contain all the behaviors that let the ReminderListViewController act as a data source to the reminder list.
extension MeetingListViewController {
    //Type alias for the diffable data source and its snapshot with a simpler name. Diffable data sources manage the state of your data with snapshots.
    typealias DataSource = UICollectionViewDiffableDataSource<Int, Meeting.ID>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Meeting.ID>
    
    var meetingCompletedValue: String {
         NSLocalizedString("Completed", comment: "Meeting completed value")
     }
     var meetingNotCompletedValue: String {
         NSLocalizedString("Not completed", comment: "Meeting not completed value")
     }
    
    func updateSnapshot(reloading idsThatChanged: [Meeting.ID] = []) {
        let ids = idsThatChanged.filter { id in filteredMeetings.contains(where: { $0.id == id }) }
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(filteredMeetings.map { $0.id })
        if !ids.isEmpty {
                snapshot.reloadItems(ids)
        }
        dataSource.apply(snapshot)
        headerView?.progress = progress
    }
    
    func cellRegistrationHandler(cell: UICollectionViewListCell, indexPath: IndexPath, id: Meeting.ID) {
        //The cell registration is initialized with a closure that retrieves the meeting correspoding to the cell. Then it retrieves the cells default content configuration to assign meeting values to the content configuration
        let meeting = meeting(for: id)
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = meeting.title
        contentConfiguration.secondaryText = meeting.date.dayAndTimeText
        contentConfiguration.secondaryTextProperties.font = UIFont.preferredFont(forTextStyle: .caption1)
        cell.contentConfiguration = contentConfiguration
        
        var doneButtonConfiguration = doneButtonConfiguration(for: meeting)
        doneButtonConfiguration.tintColor = .todayListCellDoneButtonTint
        cell.accessibilityCustomActions = [ doneButtonAccessibilityAction(for: meeting) ]
        cell.accessibilityValue = meeting.hasPast ? meetingCompletedValue : meetingNotCompletedValue
        cell.accessories = [ .customView(configuration: doneButtonConfiguration), .disclosureIndicator(displayed: .always) ]
                
        
        var backgroundConfiguration = UIBackgroundConfiguration.listGroupedCell()
        backgroundConfiguration.backgroundColor = .todayListCellBackground
        cell.backgroundConfiguration = backgroundConfiguration
    }
    
    func completeMeeting(with id: Meeting.ID) {
        var meeting = meeting(for: id)
        meeting.hasPast.toggle()
        update(meeting, with: id)
        updateSnapshot(reloading: [id])
    }
    
    private func doneButtonAccessibilityAction(for meeting: Meeting) -> UIAccessibilityCustomAction {
        let name = NSLocalizedString("Toggle completion", comment: "Meeting done button accessibility label")
        let action = UIAccessibilityCustomAction(name: name) { [weak self] action in
                self?.completeMeeting(with: meeting.id)
                return true
            }
        return action
    }
    
    private func doneButtonConfiguration(for meeting: Meeting) -> UICellAccessory.CustomViewConfiguration {
        let symbolName = meeting.hasPast ? "circle.fill" : "circle"
        let symbolConfiguration = UIImage.SymbolConfiguration(textStyle: .title1)
        let image = UIImage(systemName: symbolName, withConfiguration: symbolConfiguration)
        let button = MeetingDoneButton()
        button.addTarget(self, action: #selector(didPressDoneButton(_:)), for: .touchUpInside)
        button.id = meeting.id
        button.setImage(image, for: .normal)
        return UICellAccessory.CustomViewConfiguration(customView: button, placement: .leading(displayed: .always))
    }
    
    func add(_ meeting: Meeting) {
        meetings.append(meeting)
    }
    
    func deleteMeeting(with id: Meeting.ID) {
        let index = meetings.indexOfMeeting(with: id)
        meetings.remove(at: index)
    }

    func meeting(for id: Meeting.ID) -> Meeting {
        let index = meetings.indexOfMeeting(with: id)
        return meetings[index]
    }
    
    func update(_ meeting: Meeting, with id: Meeting.ID) {
        let index = meetings.indexOfMeeting(with: id)
        meetings[index] = meeting
    }
}
