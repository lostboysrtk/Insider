import UIKit

class MainDiscussionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, DiscussionsHeaderDelegate {
    
    private let tableView = UITableView(frame: .zero, style: .insetGrouped)
    var allItems: [NewsItem] = []
    var displayedItems: [NewsItem] = []
    var currentFilterIndex: Int = 0
    var currentSortIndex: Int = 0
    let sortOptions = ["Recent Activity", "Most Liked", "Top Replies"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchTechNews()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemGroupedBackground
        title = "Discussions"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        // Remove the default extra space at the top of the first section
        tableView.sectionHeaderTopPadding = 0
        
        // Registering programmatic cells
        tableView.register(DiscussionsHeaderCell.self, forCellReuseIdentifier: "DiscussionsHeaderCell")
        tableView.register(FilterRowCell.self, forCellReuseIdentifier: "FilterRowCell")
        tableView.register(DropdownSortRowCell.self, forCellReuseIdentifier: "DropdownSortRowCell")
        tableView.register(DiscussionRowCell.self, forCellReuseIdentifier: "DiscussionRowCell")
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    // Gap management between sections
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 1 ? 4 : 0.1
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }

    // MARK: - Logic
    private func fetchTechNews() {
        NewsAPIService.shared.fetchNews(for: .feed) { [weak self] result in
            DispatchQueue.main.async {
                if case .success(let items) = result {
                    self?.allItems = items.enumerated().map { (idx, item) in
                        var m = item
                        idx % 2 == 0 ? (m.isStartedByCurrentUser = true) : (m.isJoinedByCurrentUser = true)
                        return m
                    }
                    self?.applyFilterAndSort()
                }
            }
        }
    }

    func applyFilterAndSort() {
        var filtered = (currentFilterIndex == 0) ? allItems.filter { $0.isStartedByCurrentUser } : allItems.filter { $0.isJoinedByCurrentUser }
        
        if currentSortIndex == 1 {
            filtered.sort { Int($0.likes) ?? 0 > Int($1.likes) ?? 0 }
        } else if currentSortIndex == 2 {
            filtered.sort { Int($0.comments) ?? 0 > Int($1.comments) ?? 0 }
        }
        
        self.displayedItems = filtered
        UIView.transition(with: tableView, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.tableView.reloadData()
        })
    }

    // MARK: - DiscussionsHeaderDelegate
    func didTapGraphDay(dayIndex: Int) {
        let vc = ReplyCountViewController()
        vc.selectedDay = dayIndex
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func didChangeFilter(to index: Int) {
        self.currentFilterIndex = index
        self.applyFilterAndSort()
    }

    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int { return 2 }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 1 : displayedItems.count + 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "DiscussionsHeaderCell", for: indexPath) as! DiscussionsHeaderCell
            cell.delegate = self
            return cell
        } else {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "FilterRowCell", for: indexPath) as! FilterRowCell
                cell.startedJoinedButton.selectedSegmentIndex = currentFilterIndex
                cell.onFilterChanged = { [weak self] index in
                    self?.currentFilterIndex = index
                    self?.applyFilterAndSort()
                }
                return cell
            } else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DropdownSortRowCell", for: indexPath) as! DropdownSortRowCell
                cell.configure(selectedTitle: sortOptions[currentSortIndex]) { [weak self] index in
                    self?.currentSortIndex = index
                    self?.applyFilterAndSort()
                }
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "DiscussionRowCell", for: indexPath) as! DiscussionRowCell
                cell.configure(with: displayedItems[indexPath.row - 2], isStarted: currentFilterIndex == 0, isLast: indexPath.row == displayedItems.count + 1)
                return cell
            }
        }
    }

    // MARK: - Navigation Logic
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // 1. Navigation for the Discussion Activity Header (Section 0)
        if indexPath.section == 0 {
            let activityVC = ReplyCountViewController()
            navigationController?.pushViewController(activityVC, animated: true)
        }
        
        // 2. Navigation for News Articles (Section 1)
        else if indexPath.row >= 2 {
            let selectedItem = displayedItems[indexPath.row - 2]
            
            // CHECK: Route based on the current filter index
            if currentFilterIndex == 0 {
                // Navigates to the "Started By Me" screen
                let startedVC = StartedByMeDiscussionViewController()
                startedVC.newsItem = selectedItem
                // Pass any custom data if needed, e.g.:
                // startedVC.userInitialComment = "My thoughts on this..."
                self.navigationController?.pushViewController(startedVC, animated: true)
                
            } else {
                // Navigates to the "Joined By Me" screen
                let joinedVC = JoinedByMeDiscussionViewController()
                joinedVC.newsItem = selectedItem
                // Optional: Provide context for the reply highlight
                joinedVC.repliedToUsername = "CommunityUser"
                joinedVC.userReplyText = "I contributed this specific insight to the thread."
                self.navigationController?.pushViewController(joinedVC, animated: true)
            }
        }
    }
}
