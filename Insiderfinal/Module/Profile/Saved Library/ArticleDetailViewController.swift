import UIKit
import SafariServices

class ArticleDetailViewController: UIViewController {
    
    private let article: NewsItem
    private let libraryTitle: String
    
    // State for interactions
    private var likeCount: Int = 40
    private var dislikeCount: Int = 7
    private var isLiked: Bool = false
    private var isDisliked: Bool = false
    
    // MARK: - UI Components
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 24
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 12
        return view
    }()
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 24
        iv.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        iv.backgroundColor = .tertiarySystemGroupedBackground
        return iv
    }()
    
    private let headlineLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.numberOfLines = 0
        label.textColor = .label
        return label
    }()
    
    private let bodyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let sourceStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 6
        stack.alignment = .center
        stack.isUserInteractionEnabled = true
        return stack
    }()
    
    private let linkIconView: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "link"))
        iv.tintColor = .systemBlue
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let sourceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .systemBlue
        return label
    }()
    
    private let separatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = .separator
        return view
    }()
    
    private let interactionStack = UIStackView()
    private let likeBtn = ArticleDetailViewController.createButton(image: "hand.thumbsup", title: "40")
    private let dislikeBtn = ArticleDetailViewController.createButton(image: "hand.thumbsdown", title: "7")
    private let sparkleBtn = ArticleDetailViewController.createIconButton(image: "sparkles", color: .systemBlue)
    private let commentBtn = ArticleDetailViewController.createButton(image: "bubble.left", title: "9")
    private let bookmarkBtn = ArticleDetailViewController.createIconButton(image: "bookmark", color: .secondaryLabel)

    // MARK: - Init
    init(article: NewsItem, libraryTitle: String) {
        self.article = article
        self.libraryTitle = libraryTitle
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureData()
        setupActions()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        self.title = libraryTitle
        navigationItem.largeTitleDisplayMode = .never
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        appearance.shadowColor = .clear
        
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.label,
            .font: UIFont.systemFont(ofSize: 17, weight: .bold)
        ]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = .label
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        
        [scrollView, contentView, cardView, imageView, headlineLabel, bodyLabel, sourceStack, separatorLine, interactionStack].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(cardView)
        
        cardView.addSubview(imageView)
        cardView.addSubview(headlineLabel)
        cardView.addSubview(bodyLabel)
        cardView.addSubview(sourceStack)
        cardView.addSubview(separatorLine)
        cardView.addSubview(interactionStack)
        
        sourceStack.addArrangedSubview(linkIconView)
        sourceStack.addArrangedSubview(sourceLabel)
        
        interactionStack.axis = .horizontal
        interactionStack.distribution = .equalSpacing
        [likeBtn, dislikeBtn, sparkleBtn, commentBtn, bookmarkBtn].forEach { interactionStack.addArrangedSubview($0) }
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            imageView.topAnchor.constraint(equalTo: cardView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 0.6),
            
            headlineLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            headlineLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            headlineLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            
            bodyLabel.topAnchor.constraint(equalTo: headlineLabel.bottomAnchor, constant: 12),
            bodyLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            bodyLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            
            sourceStack.topAnchor.constraint(equalTo: bodyLabel.bottomAnchor, constant: 16),
            sourceStack.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            linkIconView.widthAnchor.constraint(equalToConstant: 16),
            linkIconView.heightAnchor.constraint(equalToConstant: 16),
            
            separatorLine.topAnchor.constraint(equalTo: sourceStack.bottomAnchor, constant: 16),
            separatorLine.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            separatorLine.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            separatorLine.heightAnchor.constraint(equalToConstant: 0.5),
            
            interactionStack.topAnchor.constraint(equalTo: separatorLine.bottomAnchor, constant: 8),
            interactionStack.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            interactionStack.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            interactionStack.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12)
        ])
    }
    
    private func configureData() {
        headlineLabel.text = article.title
        bodyLabel.text = article.description
        sourceLabel.text = article.source.lowercased()
        
        // This will now work correctly
        imageView.loadImage(from: article.imageURL ?? "")
        updateButtonStates()
    }
    
    private func setupActions() {
        likeBtn.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        dislikeBtn.addTarget(self, action: #selector(handleDislike), for: .touchUpInside)
        
        // Connect Sparkle button to DevKnows
        sparkleBtn.addTarget(self, action: #selector(handleSparkleTapped), for: .touchUpInside)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(openSourceLink))
        sourceStack.addGestureRecognizer(tap)
    }
    
    @objc private func handleSparkleTapped() {
        let devKnowsVC = DevKnowsViewController()
        devKnowsVC.newsItemContext = self.article
        devKnowsVC.modalPresentationStyle = .fullScreen
        self.present(devKnowsVC, animated: true)
    }
    
    @objc private func openSourceLink() {
        guard let url = URL(string: "https://www.google.com") else { return }
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true)
    }

    @objc private func handleLike() {
        isLiked.toggle()
        if isLiked {
            likeCount += 1
            if isDisliked { isDisliked = false; dislikeCount -= 1 }
        } else { likeCount -= 1 }
        updateButtonStates()
        UISelectionFeedbackGenerator().selectionChanged()
    }
    
    @objc private func handleDislike() {
        isDisliked.toggle()
        if isDisliked {
            dislikeCount += 1
            if isLiked { isLiked = false; likeCount -= 1 }
        } else { dislikeCount -= 1 }
        updateButtonStates()
        UISelectionFeedbackGenerator().selectionChanged()
    }
    
    private func updateButtonStates() {
        likeBtn.configuration?.title = "\(likeCount)"
        likeBtn.configuration?.baseForegroundColor = isLiked ? .systemBlue : .secondaryLabel
        likeBtn.configuration?.image = UIImage(systemName: isLiked ? "hand.thumbsup.fill" : "hand.thumbsup")
        
        dislikeBtn.configuration?.title = "\(dislikeCount)"
        dislikeBtn.configuration?.baseForegroundColor = isDisliked ? .systemRed : .secondaryLabel
        dislikeBtn.configuration?.image = UIImage(systemName: isDisliked ? "hand.thumbsdown.fill" : "hand.thumbsdown")
    }
    
    static private func createButton(image: String, title: String) -> UIButton {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: image)
        config.title = title
        config.imagePadding = 6
        config.baseForegroundColor = .secondaryLabel
        return UIButton(configuration: config)
    }
    
    static private func createIconButton(image: String, color: UIColor) -> UIButton {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(systemName: image)
        config.baseForegroundColor = color
        return UIButton(configuration: config)
    }
}

// MARK: - UIImageView Extension
// This MUST be at the top-level (outside of the class) to be found.
extension UIImageView {
    func loadImage(from urlString: String) {
        guard !urlString.isEmpty, let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }.resume()
    }
}
