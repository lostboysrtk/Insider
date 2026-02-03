import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var newsItems: [NewsItem] = []
    private let refreshControl = UIRefreshControl()
    private var currentCategory: NewsCategory = .feed
    
    // Pagination state
    private var currentOffset = 0
    private let pageSize = 15
    private var isLoadingMore = false
    
    private let headerContainer = UIView()
    
    private let segmentedControl: UISegmentedControl = {
        let items = ["Daily", "Feed", "Swift", "Web"]
        let sc = UISegmentedControl(items: items)
        sc.selectedSegmentIndex = 1
        sc.backgroundColor = .secondarySystemBackground
        sc.selectedSegmentTintColor = .white
        sc.translatesAutoresizingMaskIntoConstraints = false
        return sc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCustomHeaderView()
        setupTableView()
        setupRefreshControl()
        segmentedControl.addTarget(self, action: #selector(segmentChanged(_:)), for: .valueChanged)
        
        // Initial load using the default tag from your Edge Function
        loadNews(for: .feed)
    }
    
    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    @objc private func refreshData() {
        currentOffset = 0
        loadNews(for: currentCategory)
    }
    
    func loadNews(for category: NewsCategory) {
        self.currentCategory = category
        currentOffset = 0
        
        // Matches the 'category' parameter in your Edge Function logic
        let tagToSearch: String
        switch category {
        case .feed: tagToSearch = "technology"
        case .swift: tagToSearch = "swift"
        case .web: tagToSearch = "web"
        case .daily: tagToSearch = "technology"
        }
        
        NewsPersistenceManager.shared.fetchNewsCards(byTag: tagToSearch, limit: pageSize) { [weak self] result in
            DispatchQueue.main.async {
                self?.refreshControl.endRefreshing()
                switch result {
                case .success(let dbCards):
                    self?.newsItems = dbCards.map { $0.toNewsItem() }
                    self?.tableView.reloadData()
                    if dbCards.isEmpty {
                        print("⚠️ No items found for tag: \(tagToSearch).")
                    }
                case .failure(let error):
                    print("❌ Error loading from DB: \(error)")
                }
            }
        }
    }
    
    // MARK: - Infinite Scroll
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.height * 2 && !isLoadingMore && !newsItems.isEmpty {
            loadMoreNews()
        }
    }
    
    private func loadMoreNews() {
        isLoadingMore = true
        currentOffset += pageSize
        
        NewsPersistenceManager.shared.fetchNewsCards(limit: pageSize, offset: currentOffset) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoadingMore = false
                if case .success(let newCards) = result, !newCards.isEmpty {
                    let items = newCards.map { $0.toNewsItem() }
                    self?.newsItems.append(contentsOf: items)
                    self?.tableView.reloadData()
                }
            }
        }
    }
    
    // MARK: - Layout Fixes for Tab Bar Glass Effect
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: headerContainer.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            // Pin to view.bottom (not safe area) to allow scrolling behind the tab bar
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        tableView.contentInsetAdjustmentBehavior = .never
        // Add bottom inset (approx 90pt) so the final card clears the tab bar
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 90, right: 0)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @objc func segmentChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0: loadNews(for: .daily)
        case 1: loadNews(for: .feed)
        case 2: loadNews(for: .swift)
        case 3: loadNews(for: .web)
        default: break
        }
    }
    
    private func setupCustomHeaderView() {
        headerContainer.backgroundColor = .systemBackground
        headerContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(headerContainer)
        
        let topRow = UIView()
        topRow.translatesAutoresizingMaskIntoConstraints = false
        headerContainer.addSubview(topRow)
        
        let titleLabel = UILabel()
        titleLabel.text = "Insider"
        titleLabel.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        topRow.addSubview(titleLabel)
        
        let config = UIImage.SymbolConfiguration(pointSize: 22, weight: .medium)
        
        let profileButton = UIButton(type: .system)
        profileButton.setImage(UIImage(systemName: "person.crop.circle", withConfiguration: config), for: .normal)
        profileButton.tintColor = .systemGray
        profileButton.backgroundColor = .secondarySystemBackground
        profileButton.layer.cornerRadius = 20
        profileButton.translatesAutoresizingMaskIntoConstraints = false
        profileButton.addTarget(self, action: #selector(profileTapped), for: .touchUpInside)
        topRow.addSubview(profileButton)

        let notificationButton = UIButton(type: .system)
        notificationButton.setImage(UIImage(systemName: "bell.fill", withConfiguration: config), for: .normal)
        notificationButton.tintColor = .systemGray
        notificationButton.backgroundColor = .secondarySystemBackground
        notificationButton.layer.cornerRadius = 20
        notificationButton.translatesAutoresizingMaskIntoConstraints = false
        notificationButton.addTarget(self, action: #selector(notificationTapped), for: .touchUpInside)
        topRow.addSubview(notificationButton)
        
        headerContainer.addSubview(segmentedControl)
        
        NSLayoutConstraint.activate([
            headerContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            headerContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerContainer.heightAnchor.constraint(equalToConstant: 105),
            
            topRow.topAnchor.constraint(equalTo: headerContainer.topAnchor),
            topRow.leadingAnchor.constraint(equalTo: headerContainer.leadingAnchor),
            topRow.trailingAnchor.constraint(equalTo: headerContainer.trailingAnchor),
            topRow.heightAnchor.constraint(equalToConstant: 60),
            
            titleLabel.centerYAnchor.constraint(equalTo: topRow.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: topRow.leadingAnchor, constant: 20),
            
            profileButton.centerYAnchor.constraint(equalTo: topRow.centerYAnchor),
            profileButton.trailingAnchor.constraint(equalTo: topRow.trailingAnchor, constant: -20),
            profileButton.widthAnchor.constraint(equalToConstant: 40),
            profileButton.heightAnchor.constraint(equalToConstant: 40),
            
            notificationButton.centerYAnchor.constraint(equalTo: topRow.centerYAnchor),
            notificationButton.trailingAnchor.constraint(equalTo: profileButton.leadingAnchor, constant: -12),
            notificationButton.widthAnchor.constraint(equalToConstant: 40),
            notificationButton.heightAnchor.constraint(equalToConstant: 40),
            
            segmentedControl.topAnchor.constraint(equalTo: topRow.bottomAnchor, constant: 0),
            segmentedControl.leadingAnchor.constraint(equalTo: headerContainer.leadingAnchor, constant: 16),
            segmentedControl.trailingAnchor.constraint(equalTo: headerContainer.trailingAnchor, constant: -16),
            segmentedControl.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
    
    @objc func notificationTapped() {
        let notificationVC = NotificationsViewController()
        self.navigationController?.pushViewController(notificationVC, animated: true)
    }

    @objc func profileTapped() {
        let profileVC = ProfileViewController()
        self.navigationController?.pushViewController(profileVC, animated: true)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CardTableViewCell", for: indexPath) as? CardTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: newsItems[indexPath.row])
        cell.discussion.tag = indexPath.row
        cell.devknows.tag = indexPath.row
        cell.discussion.addTarget(self, action: #selector(discussionButtonTapped(sender:)), for: .touchUpInside)
        cell.devknows.addTarget(self, action: #selector(devKnowsButtonTapped(sender:)), for: .touchUpInside)
        return cell
    }
    
    @objc func discussionButtonTapped(sender: UIButton) {
        let item = newsItems[sender.tag]
        let discussionVC = PostDiscussionViewController()
        discussionVC.newsItem = item
        self.navigationController?.pushViewController(discussionVC, animated: true)
    }
    
    @objc func devKnowsButtonTapped(sender: UIButton) {
        let item = newsItems[sender.tag]
        let devVC = DevKnowsViewController()
        devVC.newsItemContext = item
        present(devVC, animated: true)
    }
}

