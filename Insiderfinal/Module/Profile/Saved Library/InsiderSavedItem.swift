import UIKit

// MARK: - Supporting Types
struct InsiderSavedItem: Hashable {
    let id = UUID()
    let title: String
    let itemCount: Int
    let articleImageUrl: String
    let category: String
    let apiCategory: NewsCategory
}

// MARK: - Constants & Theme
extension UIColor {
    static let insiderThemeBlue = UIColor(red: 0.40, green: 0.55, blue: 0.85, alpha: 1.0)
}

// MARK: - 1. Filter Pill Cell
class InsiderFilterPillCell: UICollectionViewCell {
    static let reuseIdentifier = "InsiderFilterPillCell"
    private let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupUI() {
        contentView.layer.cornerRadius = 19
        contentView.clipsToBounds = true
        
        titleLabel.font = .systemFont(ofSize: 14, weight: .bold)
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func configure(title: String, isSelected: Bool) {
        titleLabel.text = title
        if isSelected {
            contentView.backgroundColor = .insiderThemeBlue
            titleLabel.textColor = .white
        } else {
            // Subtle dark background for pills on pure black
            contentView.backgroundColor = UIColor.white.withAlphaComponent(0.12)
            titleLabel.textColor = .lightGray
        }
    }
}

// MARK: - 2. Library Controller
class InsiderSavedLibraryController: UIViewController {
    
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, AnyHashable>!
    
    private let filters = ["All", "Audio", "Articles"]
    private var selectedFilter = "All"
    
    private let mockItems = [
        InsiderSavedItem(title: "Swift Patterns", itemCount: 42, articleImageUrl: "https://images.unsplash.com/photo-1516116216624-53e697fedbea?q=80&w=1000", category: "Articles", apiCategory: .swift),
        InsiderSavedItem(title: "Blockchain & Web3", itemCount: 18, articleImageUrl: "https://images.unsplash.com/photo-1639762681485-074b7f938ba0?q=80&w=1000", category: "Articles", apiCategory: .feed),
        InsiderSavedItem(title: "Web Frontend", itemCount: 25, articleImageUrl: "https://images.unsplash.com/photo-1555066931-4365d14bab8c?q=80&w=1000", category: "Articles", apiCategory: .web),
        InsiderSavedItem(title: "Smart Contracts", itemCount: 12, articleImageUrl: "https://images.unsplash.com/photo-1642104704074-907c0698bcd9?q=80&w=1000", category: "Articles", apiCategory: .feed),
        InsiderSavedItem(title: "Engineering Audio", itemCount: 8, articleImageUrl: "https://images.unsplash.com/photo-1590602847861-f357a9332bbc?q=80&w=1000", category: "Audio", apiCategory: .daily)
    ]

    enum Section: Int, CaseIterable { case filters, grid }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTheme()
        setupCollectionView()
        configureDataSource()
        updateUI()
    }
    
    private func setupTheme() {
        title = "Saved Library"
        
        // 1. PURE BLACK VIEW BACKGROUND
        view.backgroundColor = .black
        
        let appearance = UINavigationBarAppearance()
        
        // 2. THE FIX: Remove transparency and blur completely
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .black  // FORCE SOLID BLACK
        appearance.shadowColor = .clear      // REMOVE THE GREY LINE
        
        // White text for high contrast on black
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        // Apply to ALL states to ensure it doesn't change when scrolling
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        
        navigationController?.navigationBar.tintColor = .white
        
        // If you want the title next to the back button, keep prefersLargeTitles = false
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func setupCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // 3. PURE BLACK COLLECTION BACKGROUND
        collectionView.backgroundColor = .black
        
        collectionView.delegate = self
        view.addSubview(collectionView)
        
        collectionView.register(InsiderFilterPillCell.self, forCellWithReuseIdentifier: InsiderFilterPillCell.reuseIdentifier)
        collectionView.register(InsiderGridFolderCell.self, forCellWithReuseIdentifier: InsiderGridFolderCell.reuseIdentifier)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { sectionIndex, _ in
            let section = Section(rawValue: sectionIndex)
            if section == .filters {
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .estimated(80), heightDimension: .absolute(38)))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .estimated(80), heightDimension: .absolute(38)), subitems: [item])
                let sec = NSCollectionLayoutSection(group: group)
                sec.orthogonalScrollingBehavior = .continuous
                sec.interGroupSpacing = 8
                sec.contentInsets = .init(top: 16, leading: 16, bottom: 4, trailing: 16)
                return sec
            } else {
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0)))
                item.contentInsets = .init(top: 2, leading: 6, bottom: 2, trailing: 6)
                
                let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.55))
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
                
                let sec = NSCollectionLayoutSection(group: group)
                sec.contentInsets = .init(top: 4, leading: 10, bottom: 20, trailing: 10)
                return sec
            }
        }
    }

    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>(collectionView: collectionView) { (cv, ip, item) in
            if let filterTitle = item as? String {
                let cell = cv.dequeueReusableCell(withReuseIdentifier: InsiderFilterPillCell.reuseIdentifier, for: ip) as! InsiderFilterPillCell
                cell.configure(title: filterTitle, isSelected: filterTitle == self.selectedFilter)
                return cell
            } else if let libraryItem = item as? InsiderSavedItem {
                let cell = cv.dequeueReusableCell(withReuseIdentifier: InsiderGridFolderCell.reuseIdentifier, for: ip) as! InsiderGridFolderCell
                cell.configure(with: libraryItem)
                return cell
            }
            return nil
        }
    }
    
    private func updateUI() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, AnyHashable>()
        snapshot.appendSections([.filters, .grid])
        snapshot.appendItems(filters, toSection: .filters)
        let filteredData = selectedFilter == "All" ? mockItems : mockItems.filter { $0.category == selectedFilter }
        snapshot.appendItems(filteredData, toSection: .grid)
        snapshot.reloadSections([.filters])
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension InsiderSavedLibraryController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            UISelectionFeedbackGenerator().selectionChanged()
            selectedFilter = filters[indexPath.item]
            updateUI()
        } else {
            let currentItems = selectedFilter == "All" ? mockItems : mockItems.filter { $0.category == selectedFilter }
            let selectedItem = currentItems[indexPath.item]
            let detailVC = LibraryDetailViewController(category: selectedItem.apiCategory, libraryTitle: selectedItem.title)
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}
