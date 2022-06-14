//
//  MeetingListViewController+Actions.swift
//  Today
//
//  Created by Rood-Landy Thezard on 6/9/22.
//

import UIKit

extension MeetingListViewController {
    @objc func didPressDoneButton(_ sender: MeetingDoneButton) {
        guard let id = sender.id else { return }
        completeMeeting(with: id)
    }
    
    @objc func didPressAddButton(_ sender: UIBarButtonItem) {
        let meeting = Meeting(title: "", date: Date.now, host: "Host", attendees: "Attendees (separate by comma)")
        let viewController = MeetingViewController(meeting: meeting) { [weak self] meeting in
            self?.add(meeting)
            self?.updateSnapshot()
            self?.dismiss(animated: true)
        }
        viewController.isAddingNewMeeting = true
        viewController.setEditing(true, animated: false)
        viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(didCancelAdd(_:)))
        viewController.navigationItem.title = NSLocalizedString("Add Meeting", comment: "Add Meeting view controller title")
        let navigationController = UINavigationController(rootViewController: viewController)
        present(navigationController, animated: true)
    }
        
    @objc func didCancelAdd(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @objc func didChangeListStyle(_ sender: UISegmentedControl) {
        listStyle = MeetingListStyle(rawValue: sender.selectedSegmentIndex) ?? .today
        updateSnapshot()
        refreshBackground()
    }
}
