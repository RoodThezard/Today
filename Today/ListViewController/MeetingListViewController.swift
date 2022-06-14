//
//  ViewController.swift
//  Today
//
//  Created by Rood-Landy Thezard on 6/8/22.
//

import UIKit

class MeetingListViewController: UICollectionViewController {
    //dataSource property that is implicitly unwrapped because we know that this optional will have a value since we will initialize it in viewDidLoad().
    var dataSource: DataSource!
    var meetings: [Meeting] = Meeting.sampleData
    var filteredMeetings: [Meeting] {
        return meetings.filter { listStyle.shouldInclude(date: $0.date) }.sorted { $0.date < $1.date }
    }
    var listStyle: MeetingListStyle = .today
    let listStyleSegmentedControl = UISegmentedControl(items: [
        MeetingListStyle.today.name, MeetingListStyle.future.name, MeetingListStyle.all.name
    ])
    var headerView: ProgressHeaderView?
    var progress: CGFloat {
        let chunkSize = 1.0 / CGFloat(filteredMeetings.count)
        let progress = filteredMeetings.reduce(0.0) {
            let chunk = $1.hasPast ? chunkSize : 0
            return $0 + chunk
        }
        return progress
    }
    
    //After the view controller loads its view hierarchy into memory, the system calls viewDidLoad().
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        collectionView.backgroundColor = .todayGradientFutureBegin
        if let color = collectionView.backgroundColor{
            print(color.accessibilityName)
        } else{
            print("missing")
        }
        
        //Creates a new list layout and then assigns the list layout to the collection view layout.
        let listLayout = listLayout()
        collectionView.collectionViewLayout = listLayout
        
        //Creates a new cell registration which specifies how to configure the content and appearance of a cell.
        let cellRegistration = UICollectionView.CellRegistration(handler: cellRegistrationHandler)
        
        //Initializes data source optional property with a closure that cofigures and returns a cell for a collection view.
        dataSource = DataSource(collectionView: collectionView) { (collectionView: UICollectionView, indexPath: IndexPath, itemIdentifier: Meeting.ID) in
            //Dequeues and returns a cell using the cell registration so we can reuse cells to allow our app to perform well even with a vast number of items
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        }
        
        let headerRegistration = UICollectionView.SupplementaryRegistration(elementKind: ProgressHeaderView.elementKind, handler: supplementaryRegistrationHandler)
        dataSource.supplementaryViewProvider = { supplementaryView, elementKind, indexPath in
            return self.collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
        }
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didPressAddButton(_:)))
        addButton.accessibilityLabel = NSLocalizedString("Add meeting", comment: "Add button accessibility label")
        navigationItem.rightBarButtonItem = addButton
        
        listStyleSegmentedControl.selectedSegmentIndex = listStyle.rawValue
        listStyleSegmentedControl.addTarget(self, action: #selector(didChangeListStyle(_:)), for: .valueChanged)
        navigationItem.titleView = listStyleSegmentedControl
        
        updateSnapshot()
        
        //Assigns the data source to the collection view.
        collectionView.dataSource = dataSource
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshBackground()
    }
    
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let id = filteredMeetings[indexPath.item].id
        showDetail(for: id)
        return false
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        guard elementKind == ProgressHeaderView.elementKind, let progressView = view as? ProgressHeaderView else {
            return
        }
        progressView.progress = progress
    }
    
    func refreshBackground() {
        collectionView.backgroundView = nil
        let backgroundView = UIView()
        let gradientLayer = CAGradientLayer.gradientLayer(for: listStyle, in: collectionView.frame)
        backgroundView.layer.addSublayer(gradientLayer)
        collectionView.backgroundView = backgroundView
    }
    
    func showDetail(for id: Meeting.ID) {
        let meeting = meeting(for: id)
        let viewController = MeetingViewController(meeting: meeting) { [weak self] meeting in
            self?.update(meeting, with: meeting.id)
            self?.updateSnapshot(reloading: [meeting.id])
        }
        navigationController?.pushViewController(viewController, animated: true)

    }

    //Returns a list configuration variable with a grouped appearance with no separators and a clear backgroud color. UICollectionLayoutListConfiguration creates a section in a list layout.
    private func listLayout () -> UICollectionViewCompositionalLayout{
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .grouped)
        listConfiguration.headerMode = .supplementary
        listConfiguration.showsSeparators = false
        listConfiguration.trailingSwipeActionsConfigurationProvider = makeSwipeActions
        listConfiguration.backgroundColor = .clear
        return UICollectionViewCompositionalLayout.list(using: listConfiguration)
    }
    
    private func makeSwipeActions(for indexPath: IndexPath?) -> UISwipeActionsConfiguration? {
        guard let indexPath = indexPath, let id = dataSource.itemIdentifier(for: indexPath) else { return nil }
        let deleteActionTitle = NSLocalizedString("Delete", comment: "Delete action title")
        let deleteAction = UIContextualAction(style: .destructive, title: deleteActionTitle) { [weak self] _, _, completion in
            self?.deleteMeeting(with: id)
            self?.updateSnapshot()
            completion(false)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }

    private func supplementaryRegistrationHandler(progressView: ProgressHeaderView, elementKind: String, indexPath: IndexPath) {
        headerView = progressView
    }
}

