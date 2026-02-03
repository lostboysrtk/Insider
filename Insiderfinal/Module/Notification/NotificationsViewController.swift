//
//import UIKit
//
//// MARK: - Models
//enum NotificationType {
//    case reply(discussion: String, username: String, topic: String, time: String)
//    case streak(days: Int, time: String)
//    case helpful(topic: String, time: String)
//    case trending(topic: String, time: String)
//    case badge(title: String, description: String, time: String)
//    case newArticle(title: String, category: String, time: String)
//}
//
//enum NotificationFilter: String, CaseIterable {
//    case all = "All"
//    case catchUp = "Catch Up"
//    case discussions = "Discussions"
//    case audio = "Audio"
//    case activity = "Activity"
//}
//
//struct NotificationItem {
//    let type: NotificationType
//    let isRead: Bool
//    let timestamp: Date
//    let category: NotificationFilter
//}
//
//// MARK: - Main View Controller
//class NotificationsViewController: UIViewController {
//    
//    private var tableView: UITableView!
//    private var allNotifications: [NotificationItem] = []
//    private var filteredNotifications: [NotificationItem] = []
//    private var selectedFilter: NotificationFilter = .all
//    
//    private lazy var filterScrollView: UIScrollView = {
//        let scroll = UIScrollView()
//        scroll.showsHorizontalScrollIndicator = false
//        scroll.translatesAutoresizingMaskIntoConstraints = false
//        return scroll
//    }()
//    
//    private lazy var filterStackView: UIStackView = {
//        let stack = UIStackView()
//        stack.axis = .horizontal
//        stack.spacing = 12
//        stack.translatesAutoresizingMaskIntoConstraints = false
//        return stack
//    }()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupUI()
//        loadNotifications()
//        setupFilters()
//    }
//    
//    private func setupUI() {
//        title = "Notifications"
//        view.backgroundColor = .systemBackground
//        navigationController?.navigationBar.prefersLargeTitles = false
//        
//        // Setup filter scroll view
//        view.addSubview(filterScrollView)
//        filterScrollView.addSubview(filterStackView)
//        
//        // Setup table view
//        tableView = UITableView(frame: .zero, style: .plain)
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.backgroundColor = .systemBackground
//        tableView.separatorStyle = .singleLine
//        tableView.separatorInset = UIEdgeInsets(top: 0, left: 72, bottom: 0, right: 60)
//        tableView.estimatedRowHeight = 80
//        tableView.rowHeight = UITableView.automaticDimension
//        
//        tableView.register(NotificationCell.self, forCellReuseIdentifier: "NotificationCell")
//        
//        view.addSubview(tableView)
//        
//        NSLayoutConstraint.activate([
//            filterScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            filterScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            filterScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            filterScrollView.heightAnchor.constraint(equalToConstant: 50),
//            
//            filterStackView.topAnchor.constraint(equalTo: filterScrollView.topAnchor, constant: 8),
//            filterStackView.leadingAnchor.constraint(equalTo: filterScrollView.leadingAnchor, constant: 16),
//            filterStackView.trailingAnchor.constraint(equalTo: filterScrollView.trailingAnchor, constant: -16),
//            filterStackView.bottomAnchor.constraint(equalTo: filterScrollView.bottomAnchor, constant: -8),
//            filterStackView.heightAnchor.constraint(equalToConstant: 34),
//            
//            tableView.topAnchor.constraint(equalTo: filterScrollView.bottomAnchor),
//            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//        ])
//    }
//    
//    private func setupFilters() {
//        for filter in NotificationFilter.allCases {
//            let button = createFilterButton(title: filter.rawValue, filter: filter)
//            filterStackView.addArrangedSubview(button)
//        }
//        
//        // Select first button by default
//        if let firstButton = filterStackView.arrangedSubviews.first as? UIButton {
//            selectFilterButton(firstButton)
//        }
//    }
//    
//    private func createFilterButton(title: String, filter: NotificationFilter) -> UIButton {
//        let button = UIButton(type: .system)
//        button.setTitle(title, for: .normal)
//        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
//        button.backgroundColor = .secondarySystemBackground
//        button.setTitleColor(.secondaryLabel, for: .normal)
//        button.layer.cornerRadius = 17
//        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
//        button.tag = NotificationFilter.allCases.firstIndex(of: filter) ?? 0
//        button.addTarget(self, action: #selector(filterButtonTapped(_:)), for: .touchUpInside)
//        return button
//    }
//    
//    @objc private func filterButtonTapped(_ sender: UIButton) {
//        selectFilterButton(sender)
//        
//        let filter = NotificationFilter.allCases[sender.tag]
//        selectedFilter = filter
//        
//        if filter == .all {
//            filteredNotifications = allNotifications
//        } else {
//            filteredNotifications = allNotifications.filter { $0.category == filter }
//        }
//        
//        tableView.reloadData()
//    }
//    
//    private func selectFilterButton(_ button: UIButton) {
//        // Deselect all buttons
//        for case let btn as UIButton in filterStackView.arrangedSubviews {
//            btn.backgroundColor = .secondarySystemBackground
//            btn.setTitleColor(.secondaryLabel, for: .normal)
//        }
//        
//        // Select tapped button
//        button.backgroundColor = .label
//        button.setTitleColor(.systemBackground, for: .normal)
//    }
//    
//    private func loadNotifications() {
//        allNotifications = [
//            NotificationItem(type: .reply(discussion: "Swift", username: "mohan_sh9", topic: "Swift Concurrency", time: "2h"), isRead: false, timestamp: Date(), category: .discussions),
//            NotificationItem(type: .reply(discussion: "Swift", username: "sohanach12", topic: "SwiftUI Best Practices", time: "3h"), isRead: false, timestamp: Date(), category: .discussions),
//            NotificationItem(type: .reply(discussion: "Java", username: "rohan68_1", topic: "Spring Boot Tutorial", time: "3h"), isRead: false, timestamp: Date(), category: .discussions),
//            NotificationItem(type: .streak(days: 25, time: "13h"), isRead: true, timestamp: Date(), category: .activity),
//            NotificationItem(type: .helpful(topic: "Kotlin", time: "23h"), isRead: true, timestamp: Date(), category: .activity),
//            NotificationItem(type: .trending(topic: "Java", time: "1d"), isRead: true, timestamp: Date(), category: .catchUp),
//            NotificationItem(type: .newArticle(title: "Advanced Patterns", category: "Swift", time: "1d"), isRead: true, timestamp: Date(), category: .catchUp),
//            NotificationItem(type: .badge(title: "Code Master", description: "Posted 50 helpful answers", time: "2d"), isRead: true, timestamp: Date(), category: .activity),
//            NotificationItem(type: .trending(topic: "React Native", time: "3d"), isRead: true, timestamp: Date(), category: .catchUp),
//            NotificationItem(type: .reply(discussion: "Kotlin", username: "dev_master", topic: "Coroutines Deep Dive", time: "4d"), isRead: true, timestamp: Date(), category: .discussions)
//        ]
//        
//        filteredNotifications = allNotifications
//        tableView.reloadData()
//    }
//}
//
//// MARK: - Table View DataSource & Delegate
//extension NotificationsViewController: UITableViewDataSource, UITableViewDelegate {
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return filteredNotifications.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as! NotificationCell
//        let item = filteredNotifications[indexPath.row]
//        cell.configure(with: item)
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        
//        let generator = UIImpactFeedbackGenerator(style: .light)
//        generator.impactOccurred()
//        
//        let item = filteredNotifications[indexPath.row]
//        handleNotificationTap(item)
//    }
//    
//    private func handleNotificationTap(_ item: NotificationItem) {
//        switch item.type {
//        case .reply(let discussion, _, _, _):
//            print("Navigate to discussion: \(discussion)")
//        case .trending(let topic, _):
//            print("Navigate to trending topic: \(topic)")
//        case .newArticle(let title, _, _):
//            print("Navigate to article: \(title)")
//        default:
//            print("Notification tapped")
//        }
//    }
//}
//
//// MARK: - Notification Cell
//class NotificationCell: UITableViewCell {
//    
//    private let iconContainer: UIView = {
//        let view = UIView()
//        view.layer.cornerRadius = 24
//        view.clipsToBounds = true
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//    
//    private let iconView: UIImageView = {
//        let iv = UIImageView()
//        iv.contentMode = .scaleAspectFit
//        iv.translatesAutoresizingMaskIntoConstraints = false
//        return iv
//    }()
//    
//    private let avatarLabel: UILabel = {
//        let label = UILabel()
//        label.textAlignment = .center
//        label.font = .systemFont(ofSize: 18, weight: .semibold)
//        label.textColor = .white
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//    
//    private let messageLabel: UILabel = {
//        let label = UILabel()
//        label.font = .systemFont(ofSize: 15)
//        label.numberOfLines = 0
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//    
//    private let timeLabel: UILabel = {
//        let label = UILabel()
//        label.font = .systemFont(ofSize: 13)
//        label.textColor = .secondaryLabel
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//    
//    private let dotView: UIView = {
//        let view = UIView()
//        view.backgroundColor = .systemBlue
//        view.layer.cornerRadius = 4
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//    
//    private let thumbnailView: UIImageView = {
//        let iv = UIImageView()
//        iv.contentMode = .scaleAspectFit
//        iv.tintColor = .systemGray
//        iv.backgroundColor = .secondarySystemBackground
//        iv.layer.cornerRadius = 6
//        iv.clipsToBounds = true
//        iv.translatesAutoresizingMaskIntoConstraints = false
//        return iv
//    }()
//    
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        setupCell()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError()
//    }
//    
//    private func setupCell() {
//        backgroundColor = .systemBackground
//        selectionStyle = .default
//        
//        contentView.addSubview(dotView)
//        contentView.addSubview(iconContainer)
//        iconContainer.addSubview(iconView)
//        iconContainer.addSubview(avatarLabel)
//        contentView.addSubview(messageLabel)
//        contentView.addSubview(timeLabel)
//        contentView.addSubview(thumbnailView)
//        
//        NSLayoutConstraint.activate([
//            dotView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
//            dotView.centerYAnchor.constraint(equalTo: iconContainer.centerYAnchor),
//            dotView.widthAnchor.constraint(equalToConstant: 8),
//            dotView.heightAnchor.constraint(equalToConstant: 8),
//            
//            iconContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),
//            iconContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
//            iconContainer.widthAnchor.constraint(equalToConstant: 48),
//            iconContainer.heightAnchor.constraint(equalToConstant: 48),
//            
//            iconView.centerXAnchor.constraint(equalTo: iconContainer.centerXAnchor),
//            iconView.centerYAnchor.constraint(equalTo: iconContainer.centerYAnchor),
//            iconView.widthAnchor.constraint(equalToConstant: 24),
//            iconView.heightAnchor.constraint(equalToConstant: 24),
//            
//            avatarLabel.centerXAnchor.constraint(equalTo: iconContainer.centerXAnchor),
//            avatarLabel.centerYAnchor.constraint(equalTo: iconContainer.centerYAnchor),
//            
//            messageLabel.leadingAnchor.constraint(equalTo: iconContainer.trailingAnchor, constant: 12),
//            messageLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
//            messageLabel.trailingAnchor.constraint(equalTo: thumbnailView.leadingAnchor, constant: -12),
//            
//            timeLabel.leadingAnchor.constraint(equalTo: messageLabel.leadingAnchor),
//            timeLabel.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 4),
//            timeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
//            
//            thumbnailView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
//            thumbnailView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
//            thumbnailView.widthAnchor.constraint(equalToConstant: 32),
//            thumbnailView.heightAnchor.constraint(equalToConstant: 32)
//        ])
//    }
//    
//    func configure(with item: NotificationItem) {
//        dotView.isHidden = item.isRead
//        backgroundColor = item.isRead ? .systemBackground : .systemBackground.withAlphaComponent(0.98)
//        
//        switch item.type {
//        case .reply(let discussion, let username, _, let time):
//            let colors: [UIColor] = [.systemPurple, .systemPink, .systemOrange, .systemBlue, .systemTeal, .systemIndigo]
//            iconContainer.backgroundColor = colors.randomElement()
//            iconView.isHidden = true
//            avatarLabel.isHidden = false
//            avatarLabel.text = String(username.prefix(1).uppercased())
//            
//            let text = NSMutableAttributedString(string: username, attributes: [
//                .font: UIFont.boldSystemFont(ofSize: 15),
//                .foregroundColor: UIColor.label
//            ])
//            text.append(NSAttributedString(string: " replied to your discussion on ", attributes: [
//                .font: UIFont.systemFont(ofSize: 15),
//                .foregroundColor: UIColor.label
//            ]))
//            text.append(NSAttributedString(string: discussion, attributes: [
//                .font: UIFont.boldSystemFont(ofSize: 15),
//                .foregroundColor: UIColor.label
//            ]))
//            messageLabel.attributedText = text
//            timeLabel.text = time
//            thumbnailView.image = UIImage(systemName: "message.fill")
//            
//        case .streak(let days, let time):
//            iconView.isHidden = false
//            avatarLabel.isHidden = true
//            iconView.image = UIImage(systemName: "flame.fill")
//            iconView.tintColor = .white
//            iconContainer.backgroundColor = .systemOrange
//            messageLabel.text = "You are on a \(days) days reading streak! Keep it up."
//            timeLabel.text = time
//            thumbnailView.image = nil
//            
//        case .helpful(let topic, let time):
//            iconView.isHidden = false
//            avatarLabel.isHidden = true
//            iconView.image = UIImage(systemName: "hand.thumbsup.fill")
//            iconView.tintColor = .white
//            iconContainer.backgroundColor = .systemBlue
//            messageLabel.text = "Your thread on \(topic) marked as most helpful."
//            timeLabel.text = time
//            thumbnailView.image = nil
//            
//        case .trending(let topic, let time):
//            iconView.isHidden = false
//            avatarLabel.isHidden = true
//            iconView.image = UIImage(systemName: "chart.line.uptrend.xyaxis")
//            iconView.tintColor = .white
//            iconContainer.backgroundColor = .systemGreen
//            messageLabel.text = "A new post is trending in your followed topic: \(topic)."
//            timeLabel.text = time
//            thumbnailView.image = nil
//            
//        case .badge(let title, let description, let time):
//            iconView.isHidden = false
//            avatarLabel.isHidden = true
//            iconView.image = UIImage(systemName: "star.fill")
//            iconView.tintColor = .white
//            iconContainer.backgroundColor = .systemYellow
//            
//            let text = NSMutableAttributedString(string: "You earned a badge: \(title)\n", attributes: [
//                .font: UIFont.boldSystemFont(ofSize: 15),
//                .foregroundColor: UIColor.label
//            ])
//            text.append(NSAttributedString(string: description, attributes: [
//                .font: UIFont.systemFont(ofSize: 14),
//                .foregroundColor: UIColor.secondaryLabel
//            ]))
//            messageLabel.attributedText = text
//            timeLabel.text = time
//            thumbnailView.image = nil
//            
//        case .newArticle(let title, let category, let time):
//            iconView.isHidden = false
//            avatarLabel.isHidden = true
//            iconView.image = UIImage(systemName: "newspaper.fill")
//            iconView.tintColor = .white
//            iconContainer.backgroundColor = .systemIndigo
//            messageLabel.text = "New article in \(category): \(title)"
//            timeLabel.text = time
//            thumbnailView.image = UIImage(systemName: "doc.text.fill")
//        }
//    }
//}















import UIKit

// MARK: - Models
enum NotificationType {
    case reply(discussion: String, username: String, topic: String, time: String)
    case streak(days: Int, time: String)
    case helpful(topic: String, time: String)
    case trending(topic: String, time: String)
    case badge(title: String, description: String, time: String)
    case newArticle(title: String, category: String, time: String)
}

enum NotificationFilter: String, CaseIterable {
    case all = "All"
    case forYou = "For You"
    case discussions = "Discussions"
    case audio = "Audio"
    case activity = "Activity"
}

struct NotificationItem {
    let type: NotificationType
    let isRead: Bool
    let timestamp: Date
    let category: NotificationFilter
}

// MARK: - Main View Controller
class NotificationsViewController: UIViewController {
    
    private var tableView: UITableView!
    private var allNotifications: [NotificationItem] = []
    private var filteredNotifications: [NotificationItem] = []
    private var selectedFilter: NotificationFilter = .all
    
    private lazy var filterScrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsHorizontalScrollIndicator = false
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    private lazy var filterStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadNotifications()
        setupFilters()
    }
    
        private func setupUI() {
            title = "Notifications"
            view.backgroundColor = .systemBackground
            navigationController?.navigationBar.prefersLargeTitles = false
    
            // Setup filter scroll view
            view.addSubview(filterScrollView)
            filterScrollView.addSubview(filterStackView)
    
            // Setup table view
            tableView = UITableView(frame: .zero, style: .plain)
            tableView.translatesAutoresizingMaskIntoConstraints = false
            tableView.delegate = self
            tableView.dataSource = self
            tableView.backgroundColor = .systemBackground
            tableView.separatorStyle = .singleLine
            tableView.separatorInset = UIEdgeInsets(top: 0, left: 72, bottom: 0, right: 60)
            tableView.estimatedRowHeight = 80
            tableView.rowHeight = UITableView.automaticDimension
    
            tableView.register(NotificationCell.self, forCellReuseIdentifier: "NotificationCell")
    
            view.addSubview(tableView)
    
            NSLayoutConstraint.activate([
                filterScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                filterScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                filterScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                filterScrollView.heightAnchor.constraint(equalToConstant: 50),
    
                filterStackView.topAnchor.constraint(equalTo: filterScrollView.topAnchor, constant: 8),
                filterStackView.leadingAnchor.constraint(equalTo: filterScrollView.leadingAnchor, constant: 16),
                filterStackView.trailingAnchor.constraint(equalTo: filterScrollView.trailingAnchor, constant: -16),
                filterStackView.bottomAnchor.constraint(equalTo: filterScrollView.bottomAnchor, constant: -8),
                filterStackView.heightAnchor.constraint(equalToConstant: 34),
    
                tableView.topAnchor.constraint(equalTo: filterScrollView.bottomAnchor),
                tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        }
    
//    private func setupUI() {
//        view.backgroundColor = .systemBackground
//        navigationController?.navigationBar.prefersLargeTitles = false
//        
//
//        
//        // Create custom title label
//        title = "Notifications"
//        view.backgroundColor = .systemBackground
//        navigationController?.navigationBar.prefersLargeTitles = false
//        
//        let titleLabel = UILabel()
//        titleLabel.text = "Notifications"
//        titleLabel.font = .systemFont(ofSize: 34, weight: .bold)
//        titleLabel.textColor = .label
//        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(titleLabel)
//        view.addSubview(titleLabel)
//        
//        // Setup filter scroll view
//        view.addSubview(filterScrollView)
//        filterScrollView.addSubview(filterStackView)
//        
//        // Setup table view
//        tableView = UITableView(frame: .zero, style: .plain)
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.backgroundColor = .systemBackground
//        tableView.separatorStyle = .singleLine
//        tableView.separatorInset = UIEdgeInsets(top: 0, left: 72, bottom: 0, right: 60)
//        tableView.estimatedRowHeight = 80
//        tableView.rowHeight = UITableView.automaticDimension
//        
//        tableView.register(NotificationCell.self, forCellReuseIdentifier: "NotificationCell")
//        
//        view.addSubview(tableView)
//        
//        NSLayoutConstraint.activate([
//            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
//            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
//            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
//            
//            filterScrollView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
//            filterScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            filterScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            filterScrollView.heightAnchor.constraint(equalToConstant: 50),
//            
//            filterStackView.topAnchor.constraint(equalTo: filterScrollView.topAnchor, constant: 8),
//            filterStackView.leadingAnchor.constraint(equalTo: filterScrollView.leadingAnchor, constant: 16),
//            filterStackView.trailingAnchor.constraint(equalTo: filterScrollView.trailingAnchor, constant: -16),
//            filterStackView.bottomAnchor.constraint(equalTo: filterScrollView.bottomAnchor, constant: -8),
//            filterStackView.heightAnchor.constraint(equalToConstant: 34),
//            
//            tableView.topAnchor.constraint(equalTo: filterScrollView.bottomAnchor),
//            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//        ])
//    }
    
    private func setupFilters() {
        for filter in NotificationFilter.allCases {
            let button = createFilterButton(title: filter.rawValue, filter: filter)
            filterStackView.addArrangedSubview(button)
        }
        
        // Select first button by default
        if let firstButton = filterStackView.arrangedSubviews.first as? UIButton {
            selectFilterButton(firstButton)
        }
    }
    
    private func createFilterButton(title: String, filter: NotificationFilter) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
        button.backgroundColor = .secondarySystemBackground
        button.setTitleColor(.secondaryLabel, for: .normal)
        button.layer.cornerRadius = 17
        button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        button.tag = NotificationFilter.allCases.firstIndex(of: filter) ?? 0
        button.addTarget(self, action: #selector(filterButtonTapped(_:)), for: .touchUpInside)
        return button
    }
    
    @objc private func filterButtonTapped(_ sender: UIButton) {
        selectFilterButton(sender)
        
        let filter = NotificationFilter.allCases[sender.tag]
        selectedFilter = filter
        
        if filter == .all {
            filteredNotifications = allNotifications
        } else {
            filteredNotifications = allNotifications.filter { $0.category == filter }
        }
        
        tableView.reloadData()
    }
    
    private func selectFilterButton(_ button: UIButton) {
        // Deselect all buttons
        for case let btn as UIButton in filterStackView.arrangedSubviews {
            btn.backgroundColor = .secondarySystemBackground
            btn.setTitleColor(.secondaryLabel, for: .normal)
        }
        
        // Select tapped button
        button.backgroundColor = .label
        button.setTitleColor(.systemBackground, for: .normal)
    }
    
    private func loadNotifications() {
        allNotifications = [
            NotificationItem(type: .reply(discussion: "Swift", username: "mohan_sh9", topic: "Swift Concurrency", time: "2h"), isRead: false, timestamp: Date(), category: .discussions),
            NotificationItem(type: .reply(discussion: "Swift", username: "sohanach12", topic: "SwiftUI Best Practices", time: "3h"), isRead: false, timestamp: Date(), category: .discussions),
            NotificationItem(type: .reply(discussion: "Java", username: "rohan68_1", topic: "Spring Boot Tutorial", time: "3h"), isRead: false, timestamp: Date(), category: .discussions),
            NotificationItem(type: .streak(days: 25, time: "13h"), isRead: true, timestamp: Date(), category: .activity),
            NotificationItem(type: .helpful(topic: "Kotlin", time: "23h"), isRead: true, timestamp: Date(), category: .activity),
            NotificationItem(type: .trending(topic: "Java", time: "1d"), isRead: true, timestamp: Date(), category: .forYou),
            NotificationItem(type: .newArticle(title: "Advanced Patterns", category: "Swift", time: "1d"), isRead: true, timestamp: Date(), category: .forYou),
            NotificationItem(type: .badge(title: "Code Master", description: "Posted 50 helpful answers", time: "2d"), isRead: true, timestamp: Date(), category: .activity),
            NotificationItem(type: .trending(topic: "React Native", time: "3d"), isRead: true, timestamp: Date(), category: .forYou),
            NotificationItem(type: .reply(discussion: "Kotlin", username: "dev_master", topic: "Coroutines Deep Dive", time: "4d"), isRead: true, timestamp: Date(), category: .discussions)
        ]
        
        filteredNotifications = allNotifications
        tableView.reloadData()
    }
}

// MARK: - Table View DataSource & Delegate
extension NotificationsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredNotifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as! NotificationCell
        let item = filteredNotifications[indexPath.row]
        cell.configure(with: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
        let item = filteredNotifications[indexPath.row]
        handleNotificationTap(item)
    }
    
    private func handleNotificationTap(_ item: NotificationItem) {
        switch item.type {
        case .reply(let discussion, _, _, _):
            print("Navigate to discussion: \(discussion)")
        case .trending(let topic, _):
            print("Navigate to trending topic: \(topic)")
        case .newArticle(let title, _, _):
            print("Navigate to article: \(title)")
        default:
            print("Notification tapped")
        }
    }
}

// MARK: - Notification Cell
class NotificationCell: UITableViewCell {
    
    private let iconContainer: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 24
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let iconView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let avatarLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dotView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        view.layer.cornerRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let thumbnailView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .systemGray
        iv.backgroundColor = .secondarySystemBackground
        iv.layer.cornerRadius = 6
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setupCell() {
        backgroundColor = .systemBackground
        selectionStyle = .default
        
        contentView.addSubview(dotView)
        contentView.addSubview(iconContainer)
        iconContainer.addSubview(iconView)
        iconContainer.addSubview(avatarLabel)
        contentView.addSubview(messageLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(thumbnailView)
        
        NSLayoutConstraint.activate([
            dotView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            dotView.centerYAnchor.constraint(equalTo: iconContainer.centerYAnchor),
            dotView.widthAnchor.constraint(equalToConstant: 8),
            dotView.heightAnchor.constraint(equalToConstant: 8),
            
            iconContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 28),
            iconContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            iconContainer.widthAnchor.constraint(equalToConstant: 48),
            iconContainer.heightAnchor.constraint(equalToConstant: 48),
            
            iconView.centerXAnchor.constraint(equalTo: iconContainer.centerXAnchor),
            iconView.centerYAnchor.constraint(equalTo: iconContainer.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 24),
            iconView.heightAnchor.constraint(equalToConstant: 24),
            
            avatarLabel.centerXAnchor.constraint(equalTo: iconContainer.centerXAnchor),
            avatarLabel.centerYAnchor.constraint(equalTo: iconContainer.centerYAnchor),
            
            messageLabel.leadingAnchor.constraint(equalTo: iconContainer.trailingAnchor, constant: 12),
            messageLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            messageLabel.trailingAnchor.constraint(equalTo: thumbnailView.leadingAnchor, constant: -12),
            
            timeLabel.leadingAnchor.constraint(equalTo: messageLabel.leadingAnchor),
            timeLabel.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 4),
            timeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            
            thumbnailView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            thumbnailView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            thumbnailView.widthAnchor.constraint(equalToConstant: 32),
            thumbnailView.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
    
    func configure(with item: NotificationItem) {
        dotView.isHidden = item.isRead
        backgroundColor = item.isRead ? .systemBackground : .systemBackground.withAlphaComponent(0.98)
        
        switch item.type {
        case .reply(let discussion, let username, _, let time):
            let colors: [UIColor] = [.systemPurple, .systemPink, .systemOrange, .systemBlue, .systemTeal, .systemIndigo]
            iconContainer.backgroundColor = colors.randomElement()
            iconView.isHidden = true
            avatarLabel.isHidden = false
            avatarLabel.text = String(username.prefix(1).uppercased())
            
            let text = NSMutableAttributedString(string: username, attributes: [
                .font: UIFont.boldSystemFont(ofSize: 15),
                .foregroundColor: UIColor.label
            ])
            text.append(NSAttributedString(string: " replied to your discussion on ", attributes: [
                .font: UIFont.systemFont(ofSize: 15),
                .foregroundColor: UIColor.label
            ]))
            text.append(NSAttributedString(string: discussion, attributes: [
                .font: UIFont.boldSystemFont(ofSize: 15),
                .foregroundColor: UIColor.label
            ]))
            messageLabel.attributedText = text
            timeLabel.text = time
            thumbnailView.image = UIImage(systemName: "message.fill")
            
        case .streak(let days, let time):
            iconView.isHidden = false
            avatarLabel.isHidden = true
            iconView.image = UIImage(systemName: "flame.fill")
            iconView.tintColor = .white
            iconContainer.backgroundColor = .systemOrange
            messageLabel.text = "You are on a \(days) days reading streak! Keep it up."
            timeLabel.text = time
            thumbnailView.image = nil
            
        case .helpful(let topic, let time):
            iconView.isHidden = false
            avatarLabel.isHidden = true
            iconView.image = UIImage(systemName: "hand.thumbsup.fill")
            iconView.tintColor = .white
            iconContainer.backgroundColor = .systemBlue
            messageLabel.text = "Your thread on \(topic) marked as most helpful."
            timeLabel.text = time
            thumbnailView.image = nil
            
        case .trending(let topic, let time):
            iconView.isHidden = false
            avatarLabel.isHidden = true
            iconView.image = UIImage(systemName: "chart.line.uptrend.xyaxis")
            iconView.tintColor = .white
            iconContainer.backgroundColor = .systemGreen
            messageLabel.text = "A new post is trending in your followed topic: \(topic)."
            timeLabel.text = time
            thumbnailView.image = nil
            
        case .badge(let title, let description, let time):
            iconView.isHidden = false
            avatarLabel.isHidden = true
            iconView.image = UIImage(systemName: "star.fill")
            iconView.tintColor = .white
            iconContainer.backgroundColor = .systemYellow
            
            let text = NSMutableAttributedString(string: "You earned a badge: \(title)\n", attributes: [
                .font: UIFont.boldSystemFont(ofSize: 15),
                .foregroundColor: UIColor.label
            ])
            text.append(NSAttributedString(string: description, attributes: [
                .font: UIFont.systemFont(ofSize: 14),
                .foregroundColor: UIColor.secondaryLabel
            ]))
            messageLabel.attributedText = text
            timeLabel.text = time
            thumbnailView.image = nil
            
        case .newArticle(let title, let category, let time):
            iconView.isHidden = false
            avatarLabel.isHidden = true
            iconView.image = UIImage(systemName: "newspaper.fill")
            iconView.tintColor = .white
            iconContainer.backgroundColor = .systemIndigo
            messageLabel.text = "New article in \(category): \(title)"
            timeLabel.text = time
            thumbnailView.image = UIImage(systemName: "doc.text.fill")
        }
    }
}


