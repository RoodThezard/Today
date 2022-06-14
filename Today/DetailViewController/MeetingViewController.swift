//
//  MeetingViewController.swift
//  Today
//
//  Created by Rood-Landy Thezard on 6/10/22.
//

import UIKit

class MeetingViewController: UICollectionViewController {
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Row>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Row>
    
    var meeting: Meeting {
            didSet {
                onChange(meeting)
            }
        }
    var workingMeeting: Meeting
    var isAddingNewMeeting = false
    var onChange: (Meeting)->Void
    private var dataSource: DataSource!
    
    init(meeting: Meeting, onChange: @escaping (Meeting) -> Void) {
        self.meeting = meeting
        self.workingMeeting = meeting
        self.onChange = onChange
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        listConfiguration.showsSeparators = false
        listConfiguration.headerMode = .firstItemInSection
        let listLayout = UICollectionViewCompositionalLayout.list(using: listConfiguration)
        super.init(collectionViewLayout: listLayout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Always initialize MeetingViewController using init(meeting:)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cellRegistration = UICollectionView.CellRegistration(handler: cellRegistrationHandler)
        dataSource = DataSource(collectionView: collectionView) { (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: Row) in
                return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        }
        
        navigationItem.title = NSLocalizedString("Meeting", comment: "Meeting view controller title")
        navigationItem.rightBarButtonItem = editButtonItem
        
        updateSnapshotForViewing()
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if editing {
            prepareForEditing()
        } else {
            if !isAddingNewMeeting {
                prepareForViewing()
            } else {
                onChange(workingMeeting)
            }
        }
    }
    
    func cellRegistrationHandler(cell: UICollectionViewListCell, indexPath: IndexPath, row: Row) {
        let section = section(for: indexPath)
        switch (section, row) {
            case (_, .header(let title)):
                cell.contentConfiguration = headerConfiguration(for: cell, with: title)
            case (.view, _):
                cell.contentConfiguration = defaultConfiguration(for: cell, at: row)
            case (.title, .editText(let title)):
                cell.contentConfiguration = titleConfiguration(for: cell, with: title)
            case (.date, .editDate(let date)):
                cell.contentConfiguration = dateConfiguration(for: cell, with: date)
            case (.description, .editText(let description)):
                cell.contentConfiguration = descriptionConfiguration(for: cell, with: description)
            case (.host, .editText(let host)):
                cell.contentConfiguration = hostConfiguration(for: cell, with: host)
            case (.attendees, .editText(let attendees)):
                cell.contentConfiguration = descriptionConfiguration(for: cell, with: attendees)
            default:
                fatalError("Unexpected combination of section and row.")
        }
        cell.tintColor = .todayPrimaryTint
    }
    
    @objc func didCancelEdit() {
        workingMeeting = meeting
        setEditing(false, animated: true)
    }
    
    private func prepareForEditing() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didCancelEdit))
        updateSnapshotForEditing()
    }
    
    private func updateSnapshotForEditing() {
        var snapshot = Snapshot()
        snapshot.appendSections([.title, .date, .description, .host, .attendees])
        snapshot.appendItems([.header(Section.title.name), .editText(meeting.title)], toSection: .title)
        snapshot.appendItems([.header(Section.date.name), .editDate(meeting.date)], toSection: .date)
        snapshot.appendItems([.header(Section.description.name), .editText(meeting.description)], toSection: .description)
        snapshot.appendItems([.header(Section.host.name), .editText(meeting.host)], toSection: .host)
        snapshot.appendItems([.header(Section.attendees.name), .editText(meeting.attendees)], toSection: .attendees)
        dataSource.apply(snapshot)
    }
    
    private func prepareForViewing() {
        navigationItem.leftBarButtonItem = nil
        if workingMeeting != meeting {
            meeting = workingMeeting
        }
        updateSnapshotForViewing()
    }
    
    private func updateSnapshotForViewing() {
        var snapshot = Snapshot()
        snapshot.appendSections([.view])
        snapshot.appendItems([.header(""), .viewTitle, .viewDate, .viewTime, .viewHost, .viewAttendees, .viewDescription], toSection: .view)
        dataSource.apply(snapshot)
    }
    
    private func section(for indexPath: IndexPath) -> Section {
        let sectionNumber = isEditing ? indexPath.section + 1 : indexPath.section
        guard let section = Section(rawValue: sectionNumber) else {
            fatalError("Unable to find matching section")
        }
        return section
    }
}
