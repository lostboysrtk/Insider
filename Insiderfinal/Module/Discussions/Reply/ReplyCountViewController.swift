import UIKit

// MARK: - 1. User Activity Model
struct UserActivity {
    let newsItem: NewsItem
    let myComment: String
    let replyCount: Int
    let likeCount: Int
    let day: Int
    let date: Date
    var isBookmarked: Bool
}

// MARK: - 2. Filter Cell (Unified Card Header)
class FilterCell: UITableViewCell {
    private let sortLabel = UILabel()
    let filterButton = UIButton(type: .system)
    private let separatorLine = UIView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setupLayout() {
        selectionStyle = .none
        backgroundColor = .secondarySystemGroupedBackground
        
        sortLabel.text = "SORT BY"
        sortLabel.font = .systemFont(ofSize: 10, weight: .bold)
        sortLabel.textColor = .tertiaryLabel
        sortLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(sortLabel)
        
        filterButton.setTitleColor(.label, for: .normal)
        filterButton.titleLabel?.font = .systemFont(ofSize: 13, weight: .semibold)
        filterButton.contentHorizontalAlignment = .right
        filterButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(filterButton)
        
        separatorLine.backgroundColor = .systemGray5
        separatorLine.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(separatorLine)

        NSLayoutConstraint.activate([
            sortLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            sortLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            filterButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            filterButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            separatorLine.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            separatorLine.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            separatorLine.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorLine.heightAnchor.constraint(equalToConstant: 0.5),
            
            contentView.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
}

// MARK: - 3. News Activity Cell
class UserActivityCell: UITableViewCell {
    private let newsImageView = UIImageView()
    private let headlineLabel = UILabel()
    private let myCommentLabel = UILabel()
    private let statsStack = UIStackView()
    private let replyLabel = UILabel()
    private let likeLabel = UILabel()
    private let viewRepliesButton = UIButton(type: .system)
    private let separatorLine = UIView()
    
    var onViewReplies: (() -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCellLayout()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setupCellLayout() {
        selectionStyle = .none
        backgroundColor = .secondarySystemGroupedBackground
        
        newsImageView.contentMode = .scaleAspectFill
        newsImageView.layer.cornerRadius = 8
        newsImageView.clipsToBounds = true
        newsImageView.backgroundColor = .systemGray6
        newsImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(newsImageView)
        
        headlineLabel.font = .systemFont(ofSize: 15, weight: .bold)
        headlineLabel.numberOfLines = 2
        headlineLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(headlineLabel)
        
        myCommentLabel.font = .systemFont(ofSize: 13)
        myCommentLabel.textColor = .secondaryLabel
        myCommentLabel.numberOfLines = 2
        myCommentLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(myCommentLabel)
        
        statsStack.axis = .horizontal
        statsStack.spacing = 12
        statsStack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(statsStack)
        
        let replyIcon = UIImageView(image: UIImage(systemName: "bubble.left"))
        let likeIcon = UIImageView(image: UIImage(systemName: "hand.thumbsup"))
        [replyIcon, likeIcon].forEach {
            $0.tintColor = .systemGray2
            $0.contentMode = .scaleAspectFit
            $0.widthAnchor.constraint(equalToConstant: 12).isActive = true
        }
        
        [replyLabel, likeLabel].forEach {
            $0.font = .systemFont(ofSize: 11, weight: .semibold)
            $0.textColor = .tertiaryLabel
        }

        let rStack = UIStackView(arrangedSubviews: [replyIcon, replyLabel]); rStack.spacing = 4
        let lStack = UIStackView(arrangedSubviews: [likeIcon, likeLabel]); lStack.spacing = 4
        statsStack.addArrangedSubview(rStack)
        statsStack.addArrangedSubview(lStack)
        
        viewRepliesButton.titleLabel?.font = .systemFont(ofSize: 12, weight: .bold)
        viewRepliesButton.setTitleColor(.systemGray, for: .normal)
        viewRepliesButton.addTarget(self, action: #selector(btnTapped), for: .touchUpInside)
        viewRepliesButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(viewRepliesButton)
        
        separatorLine.backgroundColor = .systemGray5
        separatorLine.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(separatorLine)

        NSLayoutConstraint.activate([
            newsImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            newsImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            newsImageView.widthAnchor.constraint(equalToConstant: 60),
            newsImageView.heightAnchor.constraint(equalToConstant: 60),
            
            headlineLabel.topAnchor.constraint(equalTo: newsImageView.topAnchor),
            headlineLabel.leadingAnchor.constraint(equalTo: newsImageView.trailingAnchor, constant: 12),
            headlineLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            myCommentLabel.topAnchor.constraint(equalTo: headlineLabel.bottomAnchor, constant: 4),
            myCommentLabel.leadingAnchor.constraint(equalTo: headlineLabel.leadingAnchor),
            myCommentLabel.trailingAnchor.constraint(equalTo: headlineLabel.trailingAnchor),
            
            statsStack.topAnchor.constraint(equalTo: myCommentLabel.bottomAnchor, constant: 8),
            statsStack.leadingAnchor.constraint(equalTo: headlineLabel.leadingAnchor),
            
            viewRepliesButton.topAnchor.constraint(equalTo: statsStack.bottomAnchor, constant: 10),
            viewRepliesButton.leadingAnchor.constraint(equalTo: headlineLabel.leadingAnchor),
            viewRepliesButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            
            separatorLine.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            separatorLine.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            separatorLine.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorLine.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }
    
    @objc private func btnTapped() { onViewReplies?() }

    func configure(with activity: UserActivity, isLast: Bool) {
        headlineLabel.text = activity.newsItem.title
        myCommentLabel.text = "“\(activity.myComment)”"
        replyLabel.text = "\(activity.replyCount)"
        likeLabel.text = "\(activity.likeCount)"
        viewRepliesButton.setTitle("VIEW \(activity.replyCount) REPLIES", for: .normal)
        separatorLine.isHidden = isLast
        
        if let imagePath = activity.newsItem.imageURL, let url = URL(string: imagePath) {
            URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async { self?.newsImageView.image = image }
                }
            }.resume()
        }
    }
}

// MARK: - 4. Main View Controller
class ReplyCountViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tableView: UITableView!
    var selectedDay: Int = 0
    var currentSortIndex: Int = 0
    var allActivities: [UserActivity] = []
    var filteredActivities: [UserActivity] = []
    
    // Use the singleton
    private let newsService = NewsAPIService.shared
    
    // Graph Properties
    private let replyGraphData: [CGFloat] = [25, 40, 60, 30, 85, 45, 100, 50, 35, 20, 65, 80, 45, 30, 55]
    private var barLayers: [CAGradientLayer] = []
    private var chartViewRef: UIView?
    private var dateLabels: [UILabel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCenteredNavbar()
        loadNewsFromAPI()
    }

    private func setupCenteredNavbar() {
        let titleLabel = UILabel()
        titleLabel.text = "Activity Center"
        titleLabel.font = .systemFont(ofSize: 17, weight: .semibold)
        self.navigationItem.titleView = titleLabel
    }

    private func setupUI() {
        view.backgroundColor = .systemGroupedBackground
        
        // style: .insetGrouped bundles everything into a single card
        tableView = UITableView(frame: .zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        
        tableView.register(FilterCell.self, forCellReuseIdentifier: "FilterCell")
        tableView.register(UserActivityCell.self, forCellReuseIdentifier: "UserActivityCell")
        
        tableView.tableHeaderView = createGraphHeader()
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    // MARK: - Graph Header (#5880bf Gradient)
    private func createGraphHeader() -> UIView {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 200))
        let chartContainer = UIView()
        chartContainer.backgroundColor = .secondarySystemGroupedBackground
        chartContainer.layer.cornerRadius = 20
        chartContainer.translatesAutoresizingMaskIntoConstraints = false
        header.addSubview(chartContainer)
        
        let chartView = UIView()
        chartView.translatesAutoresizingMaskIntoConstraints = false
        chartContainer.addSubview(chartView)
        self.chartViewRef = chartView

        NSLayoutConstraint.activate([
            chartContainer.topAnchor.constraint(equalTo: header.topAnchor, constant: 10),
            chartContainer.leadingAnchor.constraint(equalTo: header.leadingAnchor, constant: 16),
            chartContainer.trailingAnchor.constraint(equalTo: header.trailingAnchor, constant: -16),
            chartContainer.bottomAnchor.constraint(equalTo: header.bottomAnchor, constant: -10),
            
            chartView.topAnchor.constraint(equalTo: chartContainer.topAnchor, constant: 35),
            chartView.leadingAnchor.constraint(equalTo: chartContainer.leadingAnchor, constant: 20),
            chartView.trailingAnchor.constraint(equalTo: chartContainer.trailingAnchor, constant: -20),
            chartView.bottomAnchor.constraint(equalTo: chartContainer.bottomAnchor, constant: -30)
        ])
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleGraphTap(_:)))
        chartView.addGestureRecognizer(tap)
        
        DispatchQueue.main.async { self.drawGraph(in: chartView) }
        return header
    }

    private func drawGraph(in view: UIView) {
        view.layer.sublayers?.forEach { if $0 is CAGradientLayer || ($0 is CAShapeLayer && $0.name == "GridLine") { $0.removeFromSuperlayer() } }
        barLayers.removeAll(); dateLabels.forEach { $0.removeFromSuperview() }; dateLabels.removeAll()

        let width = view.bounds.width; let height = view.bounds.height - 20; let spacing: CGFloat = 6; let barWidth = (width - (spacing * 14)) / 15
        
        // --- GRADIENT COLOR #5880bf ---
        let mainColor = UIColor(appHex: "#5880bf")
        let lightVariant = mainColor.withAlphaComponent(0.7).cgColor
        let darkVariant = mainColor.cgColor

        for (i, value) in replyGraphData.enumerated() {
            let dayOfBar = i + 2
            let barHeight = (value / 100) * height
            let xPos = CGFloat(i) * (barWidth + spacing)
            
            let gradient = CAGradientLayer()
            gradient.frame = CGRect(x: xPos, y: height - barHeight, width: barWidth, height: barHeight)
            gradient.colors = [lightVariant, darkVariant]
            gradient.opacity = (selectedDay == 0 || dayOfBar == selectedDay) ? 1.0 : 0.2
            gradient.cornerRadius = 3
            view.layer.addSublayer(gradient)
            barLayers.append(gradient)
            
            let label = UILabel(frame: CGRect(x: xPos - 2, y: height + 6, width: barWidth + 4, height: 14))
            label.text = "\(dayOfBar)"; label.font = .systemFont(ofSize: 10, weight: .bold); label.textColor = .secondaryLabel; label.textAlignment = .center; view.addSubview(label); dateLabels.append(label)
        }
    }

    // MARK: - TableView Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredActivities.count + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCell", for: indexPath) as! FilterCell
            let titles = ["Recent Activity", "Top Replies", "Most Liked"]
            cell.filterButton.setTitle("\(titles[currentSortIndex]) ▾", for: .normal)
            
            let menuItems = [
                UIAction(title: "Recent Activity", image: UIImage(systemName: "clock"), handler: { _ in self.updateSort(0) }),
                UIAction(title: "Top Replies", image: UIImage(systemName: "bubble.left"), handler: { _ in self.updateSort(1) }),
                UIAction(title: "Most Liked", image: UIImage(systemName: "hand.thumbsup"), handler: { _ in self.updateSort(2) })
            ]
            cell.filterButton.menu = UIMenu(title: "", children: menuItems)
            cell.filterButton.showsMenuAsPrimaryAction = true
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserActivityCell", for: indexPath) as! UserActivityCell
            let activity = filteredActivities[indexPath.row - 1]
            let isLast = indexPath.row == filteredActivities.count
            cell.configure(with: activity, isLast: isLast)
            
            cell.onViewReplies = { [weak self] in
                let discVC = DiscussionViewController()
                discVC.newsItem = activity.newsItem; discVC.userComment = activity.myComment
                self?.navigationController?.pushViewController(discVC, animated: true)
            }
            return cell
        }
    }

    private func updateSort(_ index: Int) {
        currentSortIndex = index; applyFilterAndSort(); UISelectionFeedbackGenerator().selectionChanged()
    }

    private func applyFilterAndSort() {
        var results = (selectedDay == 0) ? allActivities : allActivities.filter { $0.day == selectedDay }
        switch currentSortIndex {
        case 0: results.sort { $0.date > $1.date }
        case 1: results.sort { $0.replyCount > $1.replyCount }
        case 2: results.sort { $0.likeCount > $1.likeCount }
        default: break
        }
        self.filteredActivities = results; tableView.reloadData()
    }

    private func loadNewsFromAPI() {
        newsService.fetchNews(for: .feed) { [weak self] (result: Result<[NewsItem], NetworkError>) in
            DispatchQueue.main.async {
                if case .success(let newsItems) = result {
                    self?.allActivities = newsItems.map { item in
                        UserActivity(newsItem: item, myComment: item.discussionQuestion, replyCount: Int.random(in: 0...150), likeCount: Int.random(in: 0...500), day: Int.random(in: 2...16), date: Date().addingTimeInterval(TimeInterval.random(in: -2592000...0)), isBookmarked: Bool.random())
                    }
                    self?.applyFilterAndSort()
                }
            }
        }
    }

    @objc private func handleGraphTap(_ gesture: UITapGestureRecognizer) {
        guard let chart = chartViewRef else { return }
        let location = gesture.location(in: chart)
        for (index, layer) in barLayers.enumerated() {
            if layer.frame.contains(CGPoint(x: location.x, y: layer.frame.midY)) {
                selectedDay = (selectedDay == index + 2) ? 0 : index + 2
                applyFilterAndSort(); drawGraph(in: chart); return
            }
        }
        selectedDay = 0; applyFilterAndSort(); drawGraph(in: chart)
    }
}

// MARK: - UIColor Hex Extension (Ensured unique name)
extension UIColor {
    convenience init(appHex: String) {
        var cString = appHex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if cString.hasPrefix("#") { cString.remove(at: cString.startIndex) }
        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0, green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0, blue: CGFloat(rgbValue & 0x0000FF) / 255.0, alpha: 1.0)
    }
}
