//////
////////
////////  NewAudioViewController.swift
////////  Insiderfinal
////////
////////  Created by Sarthak Sharma on 21/12/25.
////
////
//import UIKit
//
//class NewAudioViewController: UIViewController {
//    
//    // MARK: - Properties
//    private var collectionView: UICollectionView!
//    private let store = AudioDataStore.shared
//    
//    // API Data Storage
//    private var breakingNewsItems: [BreakingNewsItem] = []
//    private var technicalBriefs: [TopChoiceItem] = []
//    
//    // NEW: Storage for image URLs mapped by title to ensure they match API results
//    private var imageCacheMap: [String: String] = [:]
//    
//    private var isLoadingData = false
//    private let refreshControl = UIRefreshControl()
//    private let loadingView = UIActivityIndicatorView(style: .large)
//    
//    enum Section: Int, CaseIterable {
//        case breakingNews
//        case devToolkits
//        case technicalBriefs
//        
//        var title: String {
//            switch self {
//            case .breakingNews: return "Featured"
//            case .devToolkits: return "Essential Dev Toolkits"
//            case .technicalBriefs: return "Technical Briefs"
//            }
//        }
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupUI()
//        loadAPIData()
//    }
//    
//    // MARK: - Setup
//    private func setupUI() {
//        title = "Audio"
//        self.tabBarItem.title = "Audio"
//        
//        view.backgroundColor = .systemBackground
//        navigationController?.navigationBar.prefersLargeTitles = true
//        
//        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
//        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        collectionView.backgroundColor = .clear
//        
//        collectionView.register(HeroHeadlineCell.self, forCellWithReuseIdentifier: "HeroCell")
//        collectionView.register(ToolkitCardCell.self, forCellWithReuseIdentifier: "ToolkitCell")
//        collectionView.register(NewsListCell.self, forCellWithReuseIdentifier: "ListCell")
//        collectionView.register(AudioHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header")
//        
//        collectionView.dataSource = self
//        collectionView.delegate = self
//        view.addSubview(collectionView)
//        
//        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
//        collectionView.refreshControl = refreshControl
//        
//        loadingView.translatesAutoresizingMaskIntoConstraints = false
//        loadingView.color = .systemIndigo
//        view.addSubview(loadingView)
//        
//        NSLayoutConstraint.activate([
//            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
//        ])
//    }
//    
//    // MARK: - API Data Loading
//    private func loadAPIData() {
//        guard !isLoadingData else { return }
//        isLoadingData = true
//        loadingView.startAnimating()
//        
//        let group = DispatchGroup()
//        
//        group.enter()
//        // We call the API service directly to get raw results with image_urls
//        AudioNewsAPIService.shared.fetchBreakingNews { [weak self] result in
//            if case .success(let items) = result {
//                self?.breakingNewsItems = items
//            }
//            group.leave()
//        }
//        
//        group.enter()
//        AudioNewsAPIService.shared.fetchAllTechnicalBriefs { [weak self] result in
//            if case .success(let items) = result {
//                self?.technicalBriefs = items
//            }
//            group.leave()
//        }
//        
//        group.notify(queue: .main) { [weak self] in
//            self?.isLoadingData = false
//            self?.loadingView.stopAnimating()
//            self?.collectionView.reloadData()
//        }
//    }
//    
//    @objc private func refreshData() {
//        store.refreshAllData { [weak self] success in
//            self?.refreshControl.endRefreshing()
//            if success { self?.loadAPIData() }
//        }
//    }
//
//    // MARK: - Layout Creation
//    private func createLayout() -> UICollectionViewLayout {
//        return UICollectionViewCompositionalLayout { (sectionIdx, _) -> NSCollectionLayoutSection? in
//            guard let sectionType = Section(rawValue: sectionIdx) else { return nil }
//            
//            switch sectionType {
//            case .breakingNews:
//                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
//                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.92), heightDimension: .absolute(350)), subitems: [item])
//                let section = NSCollectionLayoutSection(group: group)
//                section.orthogonalScrollingBehavior = .groupPagingCentered
//                section.interGroupSpacing = 12
//                section.contentInsets = .init(top: 10, leading: 0, bottom: 20, trailing: 0)
//                return section
//                
//            case .devToolkits:
//                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
//                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .absolute(160), heightDimension: .absolute(210)), subitems: [item])
//                let section = NSCollectionLayoutSection(group: group)
//                section.orthogonalScrollingBehavior = .continuous
//                section.interGroupSpacing = 16
//                section.contentInsets = .init(top: 10, leading: 20, bottom: 25, trailing: 20)
//                section.boundarySupplementaryItems = [self.createHeaderItem()]
//                return section
//                
//            case .technicalBriefs:
//                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(120)))
//                let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(120)), subitems: [item])
//                let section = NSCollectionLayoutSection(group: group)
//                section.interGroupSpacing = 0
//                section.contentInsets = .init(top: 10, leading: 20, bottom: 20, trailing: 20)
//                section.boundarySupplementaryItems = [self.createHeaderItem()]
//                return section
//            }
//        }
//    }
//    
//    private func createHeaderItem() -> NSCollectionLayoutBoundarySupplementaryItem {
//        return .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(44)),
//                     elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
//    }
//}
//
//// MARK: - Data Source & Delegate
//extension NewAudioViewController: UICollectionViewDataSource, UICollectionViewDelegate {
//    
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        Section.allCases.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        switch Section(rawValue: section) {
//        case .breakingNews: return breakingNewsItems.count
//        case .devToolkits: return store.devToolkits.count
//        case .technicalBriefs: return technicalBriefs.count
//        default: return 0
//        }
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let brandIndigo = UIColor(red: 0.40, green: 0.52, blue: 0.89, alpha: 1.0)
//        
//        switch Section(rawValue: indexPath.section) {
//        case .breakingNews:
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HeroCell", for: indexPath) as! HeroHeadlineCell
//            let newsItem = breakingNewsItems[indexPath.item]
//            // We pass the imageUrl here
//            cell.configure(category: newsItem.category, headline: newsItem.headline, source: newsItem.source, imageUrl: newsItem.imageUrl)
//            cell.categoryLabel.textColor = brandIndigo
//            return cell
//            
//        case .devToolkits:
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ToolkitCell", for: indexPath) as! ToolkitCardCell
//            let toolkit = store.devToolkits[indexPath.item]
//            cell.titleLabel.text = toolkit.name
//            cell.iconView.image = UIImage(systemName: toolkit.icon)
//            cell.iconView.tintColor = toolkit.color
//            return cell
//            
//        case .technicalBriefs:
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListCell", for: indexPath) as! NewsListCell
//            let brief = technicalBriefs[indexPath.item]
//            // Passing the imageUrl associated with the technical brief
//            cell.configure(with: brief, imageUrl: brief.imageUrl)
//            return cell
//            
//        default:
//            return UICollectionViewCell()
//        }
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath) as! AudioHeaderView
//        header.titleLabel.text = Section(rawValue: indexPath.section)?.title
//        return header
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
//        let section = Section(rawValue: indexPath.section)
//        
//        switch section {
//        case .breakingNews:
//            let breakingItem = breakingNewsItems[indexPath.item]
//            let topChoiceItem = TopChoiceItem(title: breakingItem.headline, date: DateFormatter.audioDateFormatter.string(from: Date()), summary: "Breaking news from \(breakingItem.source)", category: breakingItem.category, imageUrl: breakingItem.imageUrl)
//            presentPlayer(with: topChoiceItem, index: indexPath.item)
//            
//        case .technicalBriefs:
//            presentPlayer(with: technicalBriefs[indexPath.item], index: indexPath.item)
//            
//        case .devToolkits:
//            let toolkit = store.devToolkits[indexPath.item]
//            let detailVC = CategoryDetailViewController()
//            detailVC.toolkitName = toolkit.name
//            navigationController?.pushViewController(detailVC, animated: true)
//            
//        default: break
//        }
//    }
//    
//    private func presentPlayer(with item: TopChoiceItem, index: Int) {
//        let playerVC = NewAudioPlayerViewController()
//        playerVC.newsItem = item
//        playerVC.transcriptIndex = index
//        playerVC.modalPresentationStyle = .fullScreen
//        present(playerVC, animated: true)
//    }
//}
//
//// MARK: - UI Components
//class HeroHeadlineCell: UICollectionViewCell {
//    let heroImageView = UIImageView()
//    let categoryLabel = UILabel()
//    let headlineLabel = UILabel()
//    let sourceLabel = UILabel()
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        
//        heroImageView.backgroundColor = .systemGray6
//        heroImageView.layer.cornerRadius = 20
//        heroImageView.clipsToBounds = true
//        heroImageView.contentMode = .scaleAspectFill
//        
//        categoryLabel.font = .systemFont(ofSize: 12, weight: .bold)
//        headlineLabel.font = .systemFont(ofSize: 22, weight: .bold)
//        headlineLabel.numberOfLines = 3
//        sourceLabel.font = .systemFont(ofSize: 13, weight: .medium)
//        sourceLabel.textColor = .secondaryLabel
//        
//        [heroImageView, categoryLabel, headlineLabel, sourceLabel].forEach {
//            $0.translatesAutoresizingMaskIntoConstraints = false
//            contentView.addSubview($0)
//        }
//        
//        NSLayoutConstraint.activate([
//            heroImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
//            heroImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            heroImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            heroImageView.heightAnchor.constraint(equalToConstant: 220),
//            
//            categoryLabel.topAnchor.constraint(equalTo: heroImageView.bottomAnchor, constant: 12),
//            categoryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
//            
//            headlineLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 4),
//            headlineLabel.leadingAnchor.constraint(equalTo: categoryLabel.leadingAnchor),
//            headlineLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
//            
//            sourceLabel.topAnchor.constraint(equalTo: headlineLabel.bottomAnchor, constant: 4),
//            sourceLabel.leadingAnchor.constraint(equalTo: categoryLabel.leadingAnchor)
//        ])
//    }
//    
//    func configure(category: String, headline: String, source: String, imageUrl: String?) {
//        categoryLabel.text = category.uppercased()
//        headlineLabel.text = headline
//        sourceLabel.text = source
//        // Load realtime image using the shared ImageLoader
//        AudioImageLoader.shared.loadImage(from: imageUrl, into: heroImageView)
//    }
//    required init?(coder: NSCoder) { fatalError() }
//}
//
////class ToolkitCardCell: UICollectionViewCell {
////    let titleLabel = UILabel()
////    let iconContainer = UIView()
////    let iconView = UIImageView()
////    
////    override init(frame: CGRect) {
////        super.init(frame: frame)
////        contentView.layer.shadowColor = UIColor.black.cgColor
////        contentView.layer.shadowOpacity = 0.05
////        contentView.layer.shadowRadius = 10
////        
////        iconContainer.backgroundColor = .white
////        iconContainer.layer.cornerRadius = 18
////        iconView.contentMode = .scaleAspectFit
////        titleLabel.font = .systemFont(ofSize: 15, weight: .semibold)
////        titleLabel.numberOfLines = 2
////        
////        [iconContainer, titleLabel].forEach {
////            $0.translatesAutoresizingMaskIntoConstraints = false
////            contentView.addSubview($0)
////        }
////        iconContainer.addSubview(iconView)
////        iconView.translatesAutoresizingMaskIntoConstraints = false
////        
////        NSLayoutConstraint.activate([
////            iconContainer.topAnchor.constraint(equalTo: contentView.topAnchor),
////            iconContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
////            iconContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
////            iconContainer.heightAnchor.constraint(equalTo: iconContainer.widthAnchor),
////            iconView.centerXAnchor.constraint(equalTo: iconContainer.centerXAnchor),
////            iconView.centerYAnchor.constraint(equalTo: iconContainer.centerYAnchor),
////            iconView.widthAnchor.constraint(equalTo: iconContainer.widthAnchor, multiplier: 0.5),
////            titleLabel.topAnchor.constraint(equalTo: iconContainer.bottomAnchor, constant: 10),
////            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
////            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
////        ])
////    }
////    required init?(coder: NSCoder) { fatalError() }
////}
//
//class ToolkitCardCell: UICollectionViewCell {
//    let titleLabel = UILabel()
//    let iconContainer = UIView()
//    let iconView = UIImageView()
//    let innerShadowLayer = CALayer()
//    
////    override init(frame: CGRect) {
////        super.init(frame: frame)
////        
////        // 1. Shadow & Background Blur Effect (Matching Home Screen Cards)
////        contentView.backgroundColor = UIColor.white.withAlphaComponent(0.4)
////        contentView.layer.cornerRadius = 28
////        contentView.layer.masksToBounds = false
////        
////        // Matching the high-fidelity shadow from home cards
////        contentView.layer.shadowColor = UIColor.black.cgColor
////        contentView.layer.shadowOpacity = 0.12
////        contentView.layer.shadowOffset = CGSize(width: 0, height: 12)
////        contentView.layer.shadowRadius = 18
////        
////        // 2. Glassmorphism Inner Box
////        iconContainer.layer.cornerRadius = 24
////        iconContainer.clipsToBounds = true
////        iconContainer.backgroundColor = UIColor.white.withAlphaComponent(0.1)
////        
////        // 3. Increased Image Size
////        iconView.contentMode = .scaleAspectFit
////        
////        titleLabel.font = .systemFont(ofSize: 15, weight: .bold)
////        titleLabel.textAlignment = .center
////        titleLabel.textColor = .label
////        
////        [iconContainer, titleLabel].forEach {
////            $0.translatesAutoresizingMaskIntoConstraints = false
////            contentView.addSubview($0)
////        }
////        
////        iconContainer.contentView.addSubview(iconView)
////        iconView.translatesAutoresizingMaskIntoConstraints = false
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        iconContainer.backgroundColor = .secondarySystemBackground
//        iconContainer.layer.cornerRadius = 18
//        iconView.contentMode = .scaleAspectFit
//        titleLabel.font = .systemFont(ofSize: 15, weight: .semibold)
//        titleLabel.numberOfLines = 2
//
//        [iconContainer, titleLabel].forEach {
//            $0.translatesAutoresizingMaskIntoConstraints = false
//            contentView.addSubview($0)
//        }
//        iconContainer.addSubview(iconView)
//        iconView.translatesAutoresizingMaskIntoConstraints = false
//        
//        NSLayoutConstraint.activate([
//            // Container constraints
//            iconContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
//            iconContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
//            iconContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
//            iconContainer.heightAnchor.constraint(equalTo: iconContainer.widthAnchor),
//            
//            // INCREASED ICON SIZE (Now 65% of container vs previous 50%)
//            iconView.centerXAnchor.constraint(equalTo: iconContainer.centerXAnchor),
//            iconView.centerYAnchor.constraint(equalTo: iconContainer.centerYAnchor),
//            iconView.widthAnchor.constraint(equalTo: iconContainer.widthAnchor, multiplier: 0.65),
//            iconView.heightAnchor.constraint(equalTo: iconView.widthAnchor),
//            
//            // Title constraints
//            titleLabel.topAnchor.constraint(equalTo: iconContainer.bottomAnchor, constant: 14),
//            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
//            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
//        ])
//    }
//    
//    // Applying an "Inner Glow" effect similar to Feed cards
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        contentView.layer.shadowPath = UIBezierPath(roundedRect: contentView.bounds, cornerRadius: 28).cgPath
//    }
//    
//    required init?(coder: NSCoder) { fatalError() }
//}
//
//class NewsListCell: UICollectionViewCell {
//    let titleLabel = UILabel()
//    let summaryLabel = UILabel()
//    let dateLabel = UILabel()
//    let thumbnailImageView = UIImageView()
//    let separator = UIView()
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        titleLabel.font = .systemFont(ofSize: 16, weight: .bold)
//        titleLabel.numberOfLines = 2
//        
//        summaryLabel.font = .systemFont(ofSize: 13)
//        summaryLabel.textColor = .secondaryLabel
//        summaryLabel.numberOfLines = 2
//        
//        dateLabel.font = .systemFont(ofSize: 11, weight: .bold)
//        dateLabel.textColor = .systemIndigo
//        
//        thumbnailImageView.contentMode = .scaleAspectFill
//        thumbnailImageView.layer.cornerRadius = 10
//        thumbnailImageView.clipsToBounds = true
//        thumbnailImageView.backgroundColor = .systemGray6
//        
//        separator.backgroundColor = .separator.withAlphaComponent(0.2)
//        
//        [titleLabel, summaryLabel, dateLabel, thumbnailImageView, separator].forEach {
//            $0.translatesAutoresizingMaskIntoConstraints = false
//            contentView.addSubview($0)
//        }
//        
//        NSLayoutConstraint.activate([
//            thumbnailImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            thumbnailImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
//            thumbnailImageView.widthAnchor.constraint(equalToConstant: 75),
//            thumbnailImageView.heightAnchor.constraint(equalToConstant: 75),
//            
//            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
//            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            titleLabel.trailingAnchor.constraint(equalTo: thumbnailImageView.leadingAnchor, constant: -12),
//            
//            summaryLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
//            summaryLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
//            summaryLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
//            
//            dateLabel.topAnchor.constraint(equalTo: summaryLabel.bottomAnchor, constant: 6),
//            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
//            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
//            
//            separator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            separator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            separator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
//            separator.heightAnchor.constraint(equalToConstant: 0.5)
//        ])
//    }
//    
//    func configure(with item: TopChoiceItem, imageUrl: String?) {
//        titleLabel.text = item.title
//        summaryLabel.text = item.summary
//        dateLabel.text = item.date.uppercased()
//        
//        // INTEGRATED IMAGE LOADER: Logic to load realtime thumbnail
//        AudioImageLoader.shared.loadImage(from: imageUrl, into: thumbnailImageView)
//    }
//    
//    required init?(coder: NSCoder) { fatalError() }
//}
//
//class AudioHeaderView: UICollectionReusableView {
//    let titleLabel = UILabel()
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        titleLabel.font = .systemFont(ofSize: 22, weight: .bold)
//        addSubview(titleLabel)
//        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
//            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
//        ])
//    }
//    required init?(coder: NSCoder) { fatalError() }
//}
//
//







//
//// essential dev toolkits - like filter
//import UIKit
//
//class NewAudioViewController: UIViewController {
//    
//    // MARK: - Properties
//    private var collectionView: UICollectionView!
//    private let store = AudioDataStore.shared
//    
//    // API Data Storage
//    private var breakingNewsItems: [BreakingNewsItem] = []
//    private var technicalBriefs: [TopChoiceItem] = []
//    
//    private var isLoadingData = false
//    private let refreshControl = UIRefreshControl()
//    private let loadingView = UIActivityIndicatorView(style: .large)
//    
//    enum Section: Int, CaseIterable {
//        case breakingNews
//        case devToolkits
//        case technicalBriefs
//        
//        var title: String {
//            switch self {
//            case .breakingNews: return "Featured"
//            case .devToolkits: return "Essential Dev Toolkits"
//            case .technicalBriefs: return "Technical Briefs"
//            }
//        }
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupUI()
//        loadAPIData()
//    }
//    
//    // MARK: - Setup
//    private func setupUI() {
//        title = "Audio"
//        self.tabBarItem.title = "Audio"
//        
//        view.backgroundColor = .systemBackground
//        navigationController?.navigationBar.prefersLargeTitles = true
//        
//        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
//        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        collectionView.backgroundColor = .clear
//        
//        collectionView.register(HeroHeadlineCell.self, forCellWithReuseIdentifier: "HeroCell")
//        collectionView.register(ToolkitPillCell.self, forCellWithReuseIdentifier: "ToolkitCell")
//        collectionView.register(NewsListCell.self, forCellWithReuseIdentifier: "ListCell")
//        collectionView.register(AudioHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header")
//        
//        collectionView.dataSource = self
//        collectionView.delegate = self
//        view.addSubview(collectionView)
//        
//        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
//        collectionView.refreshControl = refreshControl
//        
//        loadingView.translatesAutoresizingMaskIntoConstraints = false
//        loadingView.color = .systemIndigo
//        view.addSubview(loadingView)
//        
//        NSLayoutConstraint.activate([
//            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
//        ])
//    }
//    
//    private func loadAPIData() {
//        guard !isLoadingData else { return }
//        isLoadingData = true
//        loadingView.startAnimating()
//        
//        let group = DispatchGroup()
//        
//        group.enter()
//        AudioNewsAPIService.shared.fetchBreakingNews { [weak self] result in
//            if case .success(let items) = result {
//                self?.breakingNewsItems = items
//            }
//            group.leave()
//        }
//        
//        group.enter()
//        AudioNewsAPIService.shared.fetchAllTechnicalBriefs { [weak self] result in
//            if case .success(let items) = result {
//                self?.technicalBriefs = items
//            }
//            group.leave()
//        }
//        
//        group.notify(queue: .main) { [weak self] in
//            self?.isLoadingData = false
//            self?.loadingView.stopAnimating()
//            self?.collectionView.reloadData()
//        }
//    }
//    
//    @objc private func refreshData() {
//        store.refreshAllData { [weak self] success in
//            self?.refreshControl.endRefreshing()
//            if success { self?.loadAPIData() }
//        }
//    }
//
//    // MARK: - Layout Creation
//    private func createLayout() -> UICollectionViewLayout {
//        return UICollectionViewCompositionalLayout { (sectionIdx, _) -> NSCollectionLayoutSection? in
//            guard let sectionType = Section(rawValue: sectionIdx) else { return nil }
//            
//            switch sectionType {
//            case .breakingNews:
//                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
//                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.92), heightDimension: .absolute(350)), subitems: [item])
//                let section = NSCollectionLayoutSection(group: group)
//                section.orthogonalScrollingBehavior = .groupPagingCentered
//                section.interGroupSpacing = 12
//                section.contentInsets = .init(top: 10, leading: 0, bottom: 20, trailing: 0)
//                return section
//                
//            case .devToolkits:
//                // MINIMAL REDESIGN: Shorter height (50) and narrower width (150)
//                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
//                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .absolute(150), heightDimension: .absolute(50)), subitems: [item])
//                let section = NSCollectionLayoutSection(group: group)
//                section.orthogonalScrollingBehavior = .continuous
//                section.interGroupSpacing = 12
//                section.contentInsets = .init(top: 10, leading: 20, bottom: 30, trailing: 20)
//                section.boundarySupplementaryItems = [self.createHeaderItem()]
//                return section
//                
//            case .technicalBriefs:
//                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(120)))
//                let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(120)), subitems: [item])
//                let section = NSCollectionLayoutSection(group: group)
//                section.interGroupSpacing = 0
//                section.contentInsets = .init(top: 10, leading: 20, bottom: 20, trailing: 20)
//                section.boundarySupplementaryItems = [self.createHeaderItem()]
//                return section
//            }
//        }
//    }
//    
//    private func createHeaderItem() -> NSCollectionLayoutBoundarySupplementaryItem {
//        return .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(44)),
//                     elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
//    }
//}
//
//// MARK: - Data Source & Delegate
//extension NewAudioViewController: UICollectionViewDataSource, UICollectionViewDelegate {
//    
//    func numberOfSections(in collectionView: UICollectionView) -> Int { Section.allCases.count }
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        switch Section(rawValue: section) {
//        case .breakingNews: return breakingNewsItems.count
//        case .devToolkits: return store.devToolkits.count
//        case .technicalBriefs: return technicalBriefs.count
//        default: return 0
//        }
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        switch Section(rawValue: indexPath.section) {
//        case .breakingNews:
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HeroCell", for: indexPath) as! HeroHeadlineCell
//            let newsItem = breakingNewsItems[indexPath.item]
//            cell.configure(category: newsItem.category, headline: newsItem.headline, source: newsItem.source, imageUrl: newsItem.imageUrl)
//            return cell
//            
//        case .devToolkits:
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ToolkitCell", for: indexPath) as! ToolkitPillCell
//            let toolkit = store.devToolkits[indexPath.item]
//            cell.configure(name: toolkit.name, icon: toolkit.icon, color: toolkit.color)
//            return cell
//            
//        case .technicalBriefs:
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListCell", for: indexPath) as! NewsListCell
//            let brief = technicalBriefs[indexPath.item]
//            cell.configure(with: brief, imageUrl: brief.imageUrl)
//            return cell
//            
//        default: return UICollectionViewCell()
//        }
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath) as! AudioHeaderView
//        header.titleLabel.text = Section(rawValue: indexPath.section)?.title
//        return header
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
//        let section = Section(rawValue: indexPath.section)
//        
//        switch section {
//        case .breakingNews:
//            let breakingItem = breakingNewsItems[indexPath.item]
//            let topChoiceItem = TopChoiceItem(title: breakingItem.headline, date: DateFormatter.audioDateFormatter.string(from: Date()), summary: "Breaking news from \(breakingItem.source)", category: breakingItem.category, imageUrl: breakingItem.imageUrl)
//            presentPlayer(with: topChoiceItem, index: indexPath.item)
//        case .technicalBriefs:
//            presentPlayer(with: technicalBriefs[indexPath.item], index: indexPath.item)
//        case .devToolkits:
//            let toolkit = store.devToolkits[indexPath.item]
//            let detailVC = CategoryDetailViewController()
//            detailVC.toolkitName = toolkit.name
//            navigationController?.pushViewController(detailVC, animated: true)
//        default: break
//        }
//    }
//    
//    private func presentPlayer(with item: TopChoiceItem, index: Int) {
//        let playerVC = NewAudioPlayerViewController()
//        playerVC.newsItem = item
//        playerVC.transcriptIndex = index
//        playerVC.modalPresentationStyle = .fullScreen
//        present(playerVC, animated: true)
//    }
//}
//
//// MARK: - UI Components
//
//class HeroHeadlineCell: UICollectionViewCell {
//    let heroImageView = UIImageView()
//    let categoryLabel = UILabel()
//    let headlineLabel = UILabel()
//    let sourceLabel = UILabel()
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        heroImageView.backgroundColor = .systemGray6
//        heroImageView.layer.cornerRadius = 20
//        heroImageView.clipsToBounds = true
//        heroImageView.contentMode = .scaleAspectFill
//        
//        categoryLabel.font = .systemFont(ofSize: 12, weight: .bold)
//        categoryLabel.textColor = UIColor(red: 0.40, green: 0.52, blue: 0.89, alpha: 1.0)
//        
//        headlineLabel.font = .systemFont(ofSize: 22, weight: .bold)
//        headlineLabel.numberOfLines = 3
//        
//        sourceLabel.font = .systemFont(ofSize: 13, weight: .medium)
//        sourceLabel.textColor = .secondaryLabel
//        
//        [heroImageView, categoryLabel, headlineLabel, sourceLabel].forEach {
//            $0.translatesAutoresizingMaskIntoConstraints = false
//            contentView.addSubview($0)
//        }
//        
//        NSLayoutConstraint.activate([
//            heroImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
//            heroImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            heroImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            heroImageView.heightAnchor.constraint(equalToConstant: 220),
//            
//            categoryLabel.topAnchor.constraint(equalTo: heroImageView.bottomAnchor, constant: 12),
//            categoryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
//            
//            headlineLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 4),
//            headlineLabel.leadingAnchor.constraint(equalTo: categoryLabel.leadingAnchor),
//            headlineLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
//            
//            sourceLabel.topAnchor.constraint(equalTo: headlineLabel.bottomAnchor, constant: 4),
//            sourceLabel.leadingAnchor.constraint(equalTo: categoryLabel.leadingAnchor)
//        ])
//    }
//    
//    func configure(category: String, headline: String, source: String, imageUrl: String?) {
//        categoryLabel.text = category.uppercased()
//        headlineLabel.text = headline
//        sourceLabel.text = source
//        AudioImageLoader.shared.loadImage(from: imageUrl, into: heroImageView)
//    }
//    required init?(coder: NSCoder) { fatalError() }
//}
//
//// NEW: Minimal Pill-Style Toolkit Cell
//class ToolkitPillCell: UICollectionViewCell {
//    let titleLabel = UILabel()
//    let iconView = UIImageView()
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        contentView.backgroundColor = .secondarySystemBackground
//        contentView.layer.cornerRadius = 25 // Pill shape
//        
//        iconView.contentMode = .scaleAspectFit
//        titleLabel.font = .systemFont(ofSize: 14, weight: .semibold)
//        
//        [iconView, titleLabel].forEach {
//            $0.translatesAutoresizingMaskIntoConstraints = false
//            contentView.addSubview($0)
//        }
//        
//        NSLayoutConstraint.activate([
//            iconView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 14),
//            iconView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
//            iconView.widthAnchor.constraint(equalToConstant: 22),
//            iconView.heightAnchor.constraint(equalToConstant: 22),
//            
//            titleLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 10),
//            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -14),
//            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
//        ])
//    }
//    
//    func configure(name: String, icon: String, color: UIColor) {
//        titleLabel.text = name
//        iconView.image = UIImage(systemName: icon)
//        iconView.tintColor = color
//    }
//    required init?(coder: NSCoder) { fatalError() }
//}
//
//class NewsListCell: UICollectionViewCell {
//    let titleLabel = UILabel()
//    let summaryLabel = UILabel()
//    let dateLabel = UILabel()
//    let thumbnailImageView = UIImageView()
//    let separator = UIView()
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        titleLabel.font = .systemFont(ofSize: 16, weight: .bold)
//        titleLabel.numberOfLines = 2
//        summaryLabel.font = .systemFont(ofSize: 13)
//        summaryLabel.textColor = .secondaryLabel
//        summaryLabel.numberOfLines = 2
//        dateLabel.font = .systemFont(ofSize: 11, weight: .bold)
//        dateLabel.textColor = .systemIndigo
//        
//        thumbnailImageView.contentMode = .scaleAspectFill
//        thumbnailImageView.layer.cornerRadius = 10
//        thumbnailImageView.clipsToBounds = true
//        thumbnailImageView.backgroundColor = .systemGray6
//        separator.backgroundColor = .separator.withAlphaComponent(0.2)
//        
//        [titleLabel, summaryLabel, dateLabel, thumbnailImageView, separator].forEach {
//            $0.translatesAutoresizingMaskIntoConstraints = false
//            contentView.addSubview($0)
//        }
//        
//        NSLayoutConstraint.activate([
//            thumbnailImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            thumbnailImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
//            thumbnailImageView.widthAnchor.constraint(equalToConstant: 75),
//            thumbnailImageView.heightAnchor.constraint(equalToConstant: 75),
//            
//            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
//            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            titleLabel.trailingAnchor.constraint(equalTo: thumbnailImageView.leadingAnchor, constant: -12),
//            summaryLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
//            summaryLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
//            summaryLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
//            dateLabel.topAnchor.constraint(equalTo: summaryLabel.bottomAnchor, constant: 6),
//            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
//            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
//            
//            separator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            separator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            separator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
//            separator.heightAnchor.constraint(equalToConstant: 0.5)
//        ])
//    }
//    
//    func configure(with item: TopChoiceItem, imageUrl: String?) {
//        titleLabel.text = item.title
//        summaryLabel.text = item.summary
//        dateLabel.text = item.date.uppercased()
//        AudioImageLoader.shared.loadImage(from: imageUrl, into: thumbnailImageView)
//    }
//    required init?(coder: NSCoder) { fatalError() }
//}
//
//class AudioHeaderView: UICollectionReusableView {
//    let titleLabel = UILabel()
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        titleLabel.font = .systemFont(ofSize: 22, weight: .bold)
//        addSubview(titleLabel)
//        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
//            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
//        ])
//    }
//    required init?(coder: NSCoder) { fatalError() }
//}









//import UIKit
//
//class NewAudioViewController: UIViewController {
//    
//    // MARK: - Properties
//    private var collectionView: UICollectionView!
//    private let store = AudioDataStore.shared
//    
//    // API Data Storage
//    private var breakingNewsItems: [BreakingNewsItem] = []
//    private var technicalBriefs: [TopChoiceItem] = []
//    
//    private var isLoadingData = false
//    private let refreshControl = UIRefreshControl()
//    private let loadingView = UIActivityIndicatorView(style: .large)
//    
//    // Section order: Toolkits -> Breaking News -> Technical Briefs
//    enum Section: Int, CaseIterable {
//        case devToolkits
//        case breakingNews
//        case technicalBriefs
//        
//        var title: String? {
//            switch self {
//            case .devToolkits: return "Essential Dev Toolkits"
//            case .breakingNews: return nil // REMOVED: Breaking news title
//            case .technicalBriefs: return "Technical Briefs"
//            }
//        }
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupUI()
//        loadAPIData()
//    }
//    
//    // MARK: - Setup
//    private func setupUI() {
//        title = "Audio"
//        self.tabBarItem.title = "Audio"
//        
//        view.backgroundColor = .systemBackground
//        navigationController?.navigationBar.prefersLargeTitles = true
//        
//        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
//        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        collectionView.backgroundColor = .clear
//        
//        collectionView.register(HeroHeadlineCell.self, forCellWithReuseIdentifier: "HeroCell")
//        collectionView.register(ToolkitPillCell.self, forCellWithReuseIdentifier: "ToolkitCell")
//        collectionView.register(NewsListCell.self, forCellWithReuseIdentifier: "ListCell")
//        collectionView.register(AudioHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header")
//        
//        collectionView.dataSource = self
//        collectionView.delegate = self
//        view.addSubview(collectionView)
//        
//        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
//        collectionView.refreshControl = refreshControl
//        
//        loadingView.translatesAutoresizingMaskIntoConstraints = false
//        loadingView.color = .systemIndigo
//        view.addSubview(loadingView)
//        
//        NSLayoutConstraint.activate([
//            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
//        ])
//    }
//    
//    private func loadAPIData() {
//        guard !isLoadingData else { return }
//        isLoadingData = true
//        loadingView.startAnimating()
//        
//        let group = DispatchGroup()
//        
//        group.enter()
//        AudioNewsAPIService.shared.fetchBreakingNews { [weak self] result in
//            if case .success(let items) = result {
//                self?.breakingNewsItems = items
//            }
//            group.leave()
//        }
//        
//        group.enter()
//        AudioNewsAPIService.shared.fetchAllTechnicalBriefs { [weak self] result in
//            if case .success(let items) = result {
//                self?.technicalBriefs = items
//            }
//            group.leave()
//        }
//        
//        group.notify(queue: .main) { [weak self] in
//            self?.isLoadingData = false
//            self?.loadingView.stopAnimating()
//            self?.collectionView.reloadData()
//        }
//    }
//    
//    @objc private func refreshData() {
//        store.refreshAllData { [weak self] success in
//            self?.refreshControl.endRefreshing()
//            if success { self?.loadAPIData() }
//        }
//    }
//
//    // MARK: - Layout Creation
//    private func createLayout() -> UICollectionViewLayout {
//        return UICollectionViewCompositionalLayout { (sectionIdx, _) -> NSCollectionLayoutSection? in
//            guard let sectionType = Section(rawValue: sectionIdx) else { return nil }
//            
//            switch sectionType {
//            case .devToolkits:
//                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
//                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .absolute(150), heightDimension: .absolute(50)), subitems: [item])
//                let section = NSCollectionLayoutSection(group: group)
//                section.orthogonalScrollingBehavior = .continuous
//                section.interGroupSpacing = 12
//                section.contentInsets = .init(top: 10, leading: 20, bottom: 25, trailing: 20)
//                section.boundarySupplementaryItems = [self.createHeaderItem()]
//                return section
//                
//            case .breakingNews:
//                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
//                // REDUCED: Group height from 350 to 310
//                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.92), heightDimension: .absolute(310)), subitems: [item])
//                let section = NSCollectionLayoutSection(group: group)
//                section.orthogonalScrollingBehavior = .groupPagingCentered
//                section.interGroupSpacing = 12
//                section.contentInsets = .init(top: 10, leading: 0, bottom: 20, trailing: 0)
//                // Header removed for this section via Section.title returning nil
//                return section
//                
//            case .technicalBriefs:
//                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(120)))
//                let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(120)), subitems: [item])
//                let section = NSCollectionLayoutSection(group: group)
//                section.interGroupSpacing = 0
//                section.contentInsets = .init(top: 10, leading: 20, bottom: 20, trailing: 20)
//                section.boundarySupplementaryItems = [self.createHeaderItem()]
//                return section
//            }
//        }
//    }
//    
//    private func createHeaderItem() -> NSCollectionLayoutBoundarySupplementaryItem {
//        return .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(44)),
//                     elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
//    }
//}
//
//// MARK: - Data Source & Delegate
//extension NewAudioViewController: UICollectionViewDataSource, UICollectionViewDelegate {
//    
//    func numberOfSections(in collectionView: UICollectionView) -> Int { Section.allCases.count }
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        switch Section(rawValue: section) {
//        case .devToolkits: return store.devToolkits.count
//        case .breakingNews: return breakingNewsItems.count
//        case .technicalBriefs: return technicalBriefs.count
//        default: return 0
//        }
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        switch Section(rawValue: indexPath.section) {
//        case .devToolkits:
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ToolkitCell", for: indexPath) as! ToolkitPillCell
//            let toolkit = store.devToolkits[indexPath.item]
//            cell.configure(name: toolkit.name, icon: toolkit.icon, color: toolkit.color)
//            return cell
//
//        case .breakingNews:
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HeroCell", for: indexPath) as! HeroHeadlineCell
//            let newsItem = breakingNewsItems[indexPath.item]
//            cell.configure(category: newsItem.category, headline: newsItem.headline, source: newsItem.source, imageUrl: newsItem.imageUrl)
//            return cell
//            
//        case .technicalBriefs:
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListCell", for: indexPath) as! NewsListCell
//            let brief = technicalBriefs[indexPath.item]
//            cell.configure(with: brief, imageUrl: brief.imageUrl)
//            return cell
//            
//        default: return UICollectionViewCell()
//        }
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath) as! AudioHeaderView
//        
//        // Only show title if it exists for the section
//        if let title = Section(rawValue: indexPath.section)?.title {
//            header.titleLabel.text = title
//            header.isHidden = false
//        } else {
//            header.isHidden = true
//        }
//        
//        return header
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
//        let section = Section(rawValue: indexPath.section)
//        
//        switch section {
//        case .devToolkits:
//            let toolkit = store.devToolkits[indexPath.item]
//            let detailVC = CategoryDetailViewController()
//            detailVC.toolkitName = toolkit.name
//            navigationController?.pushViewController(detailVC, animated: true)
//            
//        case .breakingNews:
//            let breakingItem = breakingNewsItems[indexPath.item]
//            let topChoiceItem = TopChoiceItem(title: breakingItem.headline, date: DateFormatter.audioDateFormatter.string(from: Date()), summary: "Breaking news from \(breakingItem.source)", category: breakingItem.category, imageUrl: breakingItem.imageUrl)
//            presentPlayer(with: topChoiceItem, index: indexPath.item)
//            
//        case .technicalBriefs:
//            presentPlayer(with: technicalBriefs[indexPath.item], index: indexPath.item)
//            
//        default: break
//        }
//    }
//    
//    private func presentPlayer(with item: TopChoiceItem, index: Int) {
//        let playerVC = NewAudioPlayerViewController()
//        playerVC.newsItem = item
//        playerVC.transcriptIndex = index
//        playerVC.modalPresentationStyle = .fullScreen
//        present(playerVC, animated: true)
//    }
//}
//
//// MARK: - UI Components
//
//class HeroHeadlineCell: UICollectionViewCell {
//    let heroImageView = UIImageView()
//    let categoryLabel = UILabel()
//    let headlineLabel = UILabel()
//    let sourceLabel = UILabel()
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        heroImageView.backgroundColor = .systemGray6
//        heroImageView.layer.cornerRadius = 20
//        heroImageView.clipsToBounds = true
//        heroImageView.contentMode = .scaleAspectFill
//        
//        categoryLabel.font = .systemFont(ofSize: 11, weight: .bold) // Slightly smaller
//        categoryLabel.textColor = UIColor(red: 0.40, green: 0.52, blue: 0.89, alpha: 1.0)
//        
//        headlineLabel.font = .systemFont(ofSize: 18, weight: .bold) // Reduced from 22
//        headlineLabel.numberOfLines = 2 // Reduced lines
//        
//        sourceLabel.font = .systemFont(ofSize: 12, weight: .medium)
//        sourceLabel.textColor = .secondaryLabel
//        
//        [heroImageView, categoryLabel, headlineLabel, sourceLabel].forEach {
//            $0.translatesAutoresizingMaskIntoConstraints = false
//            contentView.addSubview($0)
//        }
//        
//        NSLayoutConstraint.activate([
//            heroImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
//            heroImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            heroImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            heroImageView.heightAnchor.constraint(equalToConstant: 200), // REDUCED: height from 220 to 200
//            
//            categoryLabel.topAnchor.constraint(equalTo: heroImageView.bottomAnchor, constant: 10),
//            categoryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
//            
//            headlineLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 4),
//            headlineLabel.leadingAnchor.constraint(equalTo: categoryLabel.leadingAnchor),
//            headlineLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
//            
//            sourceLabel.topAnchor.constraint(equalTo: headlineLabel.bottomAnchor, constant: 4),
//            sourceLabel.leadingAnchor.constraint(equalTo: categoryLabel.leadingAnchor)
//        ])
//    }
//    
//    func configure(category: String, headline: String, source: String, imageUrl: String?) {
//        categoryLabel.text = category.uppercased()
//        headlineLabel.text = headline
//        sourceLabel.text = source
//        AudioImageLoader.shared.loadImage(from: imageUrl, into: heroImageView)
//    }
//    required init?(coder: NSCoder) { fatalError() }
//}
//
//class ToolkitPillCell: UICollectionViewCell {
//    let titleLabel = UILabel()
//    let iconView = UIImageView()
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        contentView.backgroundColor = .secondarySystemBackground
//        contentView.layer.cornerRadius = 25
//        
//        iconView.contentMode = .scaleAspectFit
//        titleLabel.font = .systemFont(ofSize: 14, weight: .semibold)
//        
//        [iconView, titleLabel].forEach {
//            $0.translatesAutoresizingMaskIntoConstraints = false
//            contentView.addSubview($0)
//        }
//        
//        NSLayoutConstraint.activate([
//            iconView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 14),
//            iconView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
//            iconView.widthAnchor.constraint(equalToConstant: 22),
//            iconView.heightAnchor.constraint(equalToConstant: 22),
//            
//            titleLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 10),
//            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -14),
//            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
//        ])
//    }
//    
//    func configure(name: String, icon: String, color: UIColor) {
//        titleLabel.text = name
//        iconView.image = UIImage(systemName: icon)
//        iconView.tintColor = color
//    }
//    required init?(coder: NSCoder) { fatalError() }
//}
//
//class NewsListCell: UICollectionViewCell {
//    let titleLabel = UILabel()
//    let summaryLabel = UILabel()
//    let dateLabel = UILabel()
//    let thumbnailImageView = UIImageView()
//    let separator = UIView()
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        titleLabel.font = .systemFont(ofSize: 16, weight: .bold)
//        titleLabel.numberOfLines = 2
//        summaryLabel.font = .systemFont(ofSize: 13)
//        summaryLabel.textColor = .secondaryLabel
//        summaryLabel.numberOfLines = 2
//        dateLabel.font = .systemFont(ofSize: 11, weight: .bold)
//        dateLabel.textColor = .systemIndigo
//        
//        thumbnailImageView.contentMode = .scaleAspectFill
//        thumbnailImageView.layer.cornerRadius = 10
//        thumbnailImageView.clipsToBounds = true
//        thumbnailImageView.backgroundColor = .systemGray6
//        separator.backgroundColor = .separator.withAlphaComponent(0.2)
//        
//        [titleLabel, summaryLabel, dateLabel, thumbnailImageView, separator].forEach {
//            $0.translatesAutoresizingMaskIntoConstraints = false
//            contentView.addSubview($0)
//        }
//        
//        NSLayoutConstraint.activate([
//            thumbnailImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            thumbnailImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
//            thumbnailImageView.widthAnchor.constraint(equalToConstant: 75),
//            thumbnailImageView.heightAnchor.constraint(equalToConstant: 75),
//            
//            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
//            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            titleLabel.trailingAnchor.constraint(equalTo: thumbnailImageView.leadingAnchor, constant: -12),
//            summaryLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
//            summaryLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
//            summaryLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
//            dateLabel.topAnchor.constraint(equalTo: summaryLabel.bottomAnchor, constant: 6),
//            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
//            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
//            
//            separator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            separator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            separator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
//            separator.heightAnchor.constraint(equalToConstant: 0.5)
//        ])
//    }
//    
//    func configure(with item: TopChoiceItem, imageUrl: String?) {
//        titleLabel.text = item.title
//        summaryLabel.text = item.summary
//        dateLabel.text = item.date.uppercased()
//        AudioImageLoader.shared.loadImage(from: imageUrl, into: thumbnailImageView)
//    }
//    required init?(coder: NSCoder) { fatalError() }
//}
//
//class AudioHeaderView: UICollectionReusableView {
//    let titleLabel = UILabel()
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        titleLabel.font = .systemFont(ofSize: 22, weight: .bold)
//        addSubview(titleLabel)
//        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
//            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
//        ])
//    }
//    required init?(coder: NSCoder) { fatalError() }
//}








import UIKit

class NewAudioViewController: UIViewController {
    
    // MARK: - Properties
    private var collectionView: UICollectionView!
    private let store = AudioDataStore.shared
    
    // API Data Storage
    private var breakingNewsItems: [BreakingNewsItem] = []
    private var technicalBriefs: [TopChoiceItem] = []
    
    private var isLoadingData = false
    private let refreshControl = UIRefreshControl()
    private let loadingView = UIActivityIndicatorView(style: .large)
    
    // UPDATED: Section order swapped to put Breaking News at the top
    enum Section: Int, CaseIterable {
        case breakingNews    // Now Index 0
        case devToolkits     // Now Index 1
        case technicalBriefs // Now Index 2
        
        var title: String? {
            switch self {
            case .breakingNews: return nil // Still nil as per your previous requirement
            case .devToolkits: return "Essential Dev Toolkits"
            case .technicalBriefs: return "Technical Briefs"
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadAPIData()
    }
    
    // MARK: - Setup
    private func setupUI() {
        title = "Audio"
        self.tabBarItem.title = "Audio"
        
        view.backgroundColor = .systemBackground
        navigationController?.navigationBar.prefersLargeTitles = true
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .clear
        
        collectionView.register(HeroHeadlineCell.self, forCellWithReuseIdentifier: "HeroCell")
        collectionView.register(ToolkitPillCell.self, forCellWithReuseIdentifier: "ToolkitCell")
        collectionView.register(NewsListCell.self, forCellWithReuseIdentifier: "ListCell")
        collectionView.register(AudioHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header")
        
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)
        
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.color = .systemIndigo
        view.addSubview(loadingView)
        
        NSLayoutConstraint.activate([
            loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func loadAPIData() {
        guard !isLoadingData else { return }
        isLoadingData = true
        loadingView.startAnimating()
        
        let group = DispatchGroup()
        
        group.enter()
        AudioNewsAPIService.shared.fetchBreakingNews { [weak self] result in
            if case .success(let items) = result {
                self?.breakingNewsItems = items
            }
            group.leave()
        }
        
        group.enter()
        AudioNewsAPIService.shared.fetchAllTechnicalBriefs { [weak self] result in
            if case .success(let items) = result {
                self?.technicalBriefs = items
            }
            group.leave()
        }
        
        group.notify(queue: .main) { [weak self] in
            self?.isLoadingData = false
            self?.loadingView.stopAnimating()
            self?.collectionView.reloadData()
        }
    }
    
    @objc private func refreshData() {
        store.refreshAllData { [weak self] success in
            self?.refreshControl.endRefreshing()
            if success { self?.loadAPIData() }
        }
    }

    // MARK: - Layout Creation
    private func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { (sectionIdx, _) -> NSCollectionLayoutSection? in
            guard let sectionType = Section(rawValue: sectionIdx) else { return nil }
            
            switch sectionType {
            case .breakingNews:
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.92), heightDimension: .absolute(310)), subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .groupPagingCentered
                section.interGroupSpacing = 12
                section.contentInsets = .init(top: 10, leading: 0, bottom: 20, trailing: 0)
                return section

            case .devToolkits:
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .absolute(150), heightDimension: .absolute(50)), subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.interGroupSpacing = 12
                section.contentInsets = .init(top: 10, leading: 20, bottom: 25, trailing: 20)
                section.boundarySupplementaryItems = [self.createHeaderItem()]
                return section
                
            case .technicalBriefs:
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(120)))
                let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(120)), subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.interGroupSpacing = 0
                section.contentInsets = .init(top: 10, leading: 20, bottom: 20, trailing: 20)
                section.boundarySupplementaryItems = [self.createHeaderItem()]
                return section
            }
        }
    }
    
    private func createHeaderItem() -> NSCollectionLayoutBoundarySupplementaryItem {
        return .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(44)),
                     elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
    }
}

// MARK: - Data Source & Delegate
extension NewAudioViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int { Section.allCases.count }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch Section(rawValue: section) {
        case .breakingNews: return breakingNewsItems.count
        case .devToolkits: return store.devToolkits.count
        case .technicalBriefs: return technicalBriefs.count
        default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch Section(rawValue: indexPath.section) {
        case .breakingNews:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HeroCell", for: indexPath) as! HeroHeadlineCell
            let newsItem = breakingNewsItems[indexPath.item]
            cell.configure(category: newsItem.category, headline: newsItem.headline, source: newsItem.source, imageUrl: newsItem.imageUrl)
            return cell

        case .devToolkits:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ToolkitCell", for: indexPath) as! ToolkitPillCell
            let toolkit = store.devToolkits[indexPath.item]
            cell.configure(name: toolkit.name, icon: toolkit.icon, color: toolkit.color)
            return cell
            
        case .technicalBriefs:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListCell", for: indexPath) as! NewsListCell
            let brief = technicalBriefs[indexPath.item]
            cell.configure(with: brief, imageUrl: brief.imageUrl)
            return cell
            
        default: return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath) as! AudioHeaderView
        
        if let title = Section(rawValue: indexPath.section)?.title {
            header.titleLabel.text = title
            header.isHidden = false
        } else {
            header.isHidden = true
        }
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        let section = Section(rawValue: indexPath.section)
        
        switch section {
        case .breakingNews:
            let breakingItem = breakingNewsItems[indexPath.item]
            let topChoiceItem = TopChoiceItem(title: breakingItem.headline, date: DateFormatter.audioDateFormatter.string(from: Date()), summary: "Breaking news from \(breakingItem.source)", category: breakingItem.category, imageUrl: breakingItem.imageUrl)
            presentPlayer(with: topChoiceItem, index: indexPath.item)

        case .devToolkits:
            let toolkit = store.devToolkits[indexPath.item]
            let detailVC = CategoryDetailViewController()
            detailVC.toolkitName = toolkit.name
            navigationController?.pushViewController(detailVC, animated: true)
            
        case .technicalBriefs:
            presentPlayer(with: technicalBriefs[indexPath.item], index: indexPath.item)
            
        default: break
        }
    }
    
    private func presentPlayer(with item: TopChoiceItem, index: Int) {
        let playerVC = NewAudioPlayerViewController()
        playerVC.newsItem = item
        playerVC.transcriptIndex = index
        playerVC.modalPresentationStyle = .fullScreen
        present(playerVC, animated: true)
    }
}

// MARK: - UI Components

class HeroHeadlineCell: UICollectionViewCell {
    let heroImageView = UIImageView()
    let categoryLabel = UILabel()
    let headlineLabel = UILabel()
    let sourceLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        heroImageView.backgroundColor = .systemGray6
        heroImageView.layer.cornerRadius = 20
        heroImageView.clipsToBounds = true
        heroImageView.contentMode = .scaleAspectFill
        
        categoryLabel.font = .systemFont(ofSize: 11, weight: .bold)
        categoryLabel.textColor = UIColor(red: 0.40, green: 0.52, blue: 0.89, alpha: 1.0)
        
        headlineLabel.font = .systemFont(ofSize: 18, weight: .bold)
        headlineLabel.numberOfLines = 2
        
        sourceLabel.font = .systemFont(ofSize: 12, weight: .medium)
        sourceLabel.textColor = .secondaryLabel
        
        [heroImageView, categoryLabel, headlineLabel, sourceLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            heroImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            heroImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            heroImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            heroImageView.heightAnchor.constraint(equalToConstant: 200),
            
            categoryLabel.topAnchor.constraint(equalTo: heroImageView.bottomAnchor, constant: 10),
            categoryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            
            headlineLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 4),
            headlineLabel.leadingAnchor.constraint(equalTo: categoryLabel.leadingAnchor),
            headlineLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            
            sourceLabel.topAnchor.constraint(equalTo: headlineLabel.bottomAnchor, constant: 4),
            sourceLabel.leadingAnchor.constraint(equalTo: categoryLabel.leadingAnchor)
        ])
    }
    
    func configure(category: String, headline: String, source: String, imageUrl: String?) {
        categoryLabel.text = category.uppercased()
        headlineLabel.text = headline
        sourceLabel.text = source
        AudioImageLoader.shared.loadImage(from: imageUrl, into: heroImageView)
    }
    required init?(coder: NSCoder) { fatalError() }
}

class ToolkitPillCell: UICollectionViewCell {
    let titleLabel = UILabel()
    let iconView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        contentView.layer.cornerRadius = 25
        
        iconView.contentMode = .scaleAspectFit
        titleLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        
        [iconView, titleLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            iconView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 14),
            iconView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 22),
            iconView.heightAnchor.constraint(equalToConstant: 22),
            
            titleLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -14),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func configure(name: String, icon: String, color: UIColor) {
        titleLabel.text = name
        iconView.image = UIImage(systemName: icon)
        iconView.tintColor = color
    }
    required init?(coder: NSCoder) { fatalError() }
}

class NewsListCell: UICollectionViewCell {
    let titleLabel = UILabel()
    let summaryLabel = UILabel()
    let dateLabel = UILabel()
    let thumbnailImageView = UIImageView()
    let separator = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel.font = .systemFont(ofSize: 16, weight: .bold)
        titleLabel.numberOfLines = 2
        summaryLabel.font = .systemFont(ofSize: 13)
        summaryLabel.textColor = .secondaryLabel
        summaryLabel.numberOfLines = 2
        dateLabel.font = .systemFont(ofSize: 11, weight: .bold)
        dateLabel.textColor = .systemIndigo
        
        thumbnailImageView.contentMode = .scaleAspectFill
        thumbnailImageView.layer.cornerRadius = 10
        thumbnailImageView.clipsToBounds = true
        thumbnailImageView.backgroundColor = .systemGray6
        separator.backgroundColor = .separator.withAlphaComponent(0.2)
        
        [titleLabel, summaryLabel, dateLabel, thumbnailImageView, separator].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            thumbnailImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            thumbnailImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            thumbnailImageView.widthAnchor.constraint(equalToConstant: 75),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: 75),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: thumbnailImageView.leadingAnchor, constant: -12),
            
            summaryLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            summaryLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            summaryLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            dateLabel.topAnchor.constraint(equalTo: summaryLabel.bottomAnchor, constant: 6),
            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            
            separator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            separator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            separator.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separator.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }
    
    func configure(with item: TopChoiceItem, imageUrl: String?) {
        titleLabel.text = item.title
        summaryLabel.text = item.summary
        dateLabel.text = item.date.uppercased()
        AudioImageLoader.shared.loadImage(from: imageUrl, into: thumbnailImageView)
    }
    required init?(coder: NSCoder) { fatalError() }
}

class AudioHeaderView: UICollectionReusableView {
    let titleLabel = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel.font = .systemFont(ofSize: 22, weight: .bold)
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    required init?(coder: NSCoder) { fatalError() }
}
