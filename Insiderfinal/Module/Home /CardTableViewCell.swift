import UIKit

class CardTableViewCell: UITableViewCell, UITextViewDelegate {
    
    // ... UI Components remain the same ...
    // MARK: - UI Components
    private let cardContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemGroupedBackground
        view.layer.cornerRadius = 24
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.separator.cgColor
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.08
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 8
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let mainStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    let newsImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .systemGray5
        iv.layer.cornerRadius = 24
        iv.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.heightAnchor.constraint(equalToConstant: 180).isActive = true
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        lbl.numberOfLines = 3
        lbl.textColor = .label
        return lbl
    }()
    
    private let bodyLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont.preferredFont(forTextStyle: .body)
        lbl.numberOfLines = 6
        lbl.lineBreakMode = .byTruncatingTail
        lbl.textColor = .secondaryLabel
        return lbl
    }()
    
    private let sourceStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fill
        return stack
    }()
    
    private lazy var sourceTextView: UITextView = {
        let tv = UITextView()
        tv.isScrollEnabled = false
        tv.isEditable = false
        tv.isSelectable = true
        tv.textContainerInset = .zero
        tv.textContainer.lineFragmentPadding = 0
        tv.backgroundColor = .clear
        tv.delegate = self
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    let devknows: UIButton = {
        let btn = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .medium)
        btn.setImage(UIImage(systemName: "sparkles", withConfiguration: config), for: .normal)
        btn.tintColor = .systemIndigo
        btn.backgroundColor = .clear
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    private let actionStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.alignment = .center
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    let like = UIButton(type: .system)
    let dislike = UIButton(type: .system)
    let bookmark = UIButton(type: .system)
    let discussion = UIButton(type: .system)
    
    private let separatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray3
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        return view
    }()

    private var isLiked = false
    private var isBookmarked = false
    private var newsItemId: String?
    private var newsItem: NewsItem?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    func configure(with item: NewsItem) {
        self.newsItem = item
        titleLabel.text = item.title
        bodyLabel.text = item.description
        ImageLoader.shared.loadImage(from: item.imageURL, into: newsImageView)
        
        // Setup Link
        if let articleURLString = item.articleURL, let url = URL(string: articleURLString) {
            let linkText = "🔗 \(item.source)"
            let attributed = NSMutableAttributedString(string: linkText)
            attributed.addAttribute(.link, value: url, range: NSRange(location: 0, length: attributed.length))
            sourceTextView.attributedText = attributed
        }
        
        // Sync Interaction state from DB if you have it
        updateSocialUI()
    }
    
    @objc private func likeTapped() {
        guard let item = newsItem, let articleUrl = item.articleURL else { return }
        isLiked.toggle()
        
        // Sync with Supabase Persistence Manager
        // Note: You'll need the newsCardId.
        // Best practice: Fetch the ID during configure() by searching DB for articleUrl.
        updateSocialUI()
    }
    
    @objc private func bookmarkTapped() {
        isBookmarked.toggle()
        updateSocialUI()
    }
    
    private func updateSocialUI() {
        like.tintColor = isLiked ? .systemBlue : .systemGray
        like.setImage(UIImage(systemName: isLiked ? "hand.thumbsup.fill" : "hand.thumbsup"), for: .normal)
        
        bookmark.tintColor = isBookmarked ? .systemBlue : .systemGray
        bookmark.setImage(UIImage(systemName: isBookmarked ? "bookmark.fill" : "bookmark"), for: .normal)
    }
    
    // ... setupUI logic ...
    private func setupUI() {
        backgroundColor = .clear
        selectionStyle = .none
        contentView.subviews.forEach { $0.removeFromSuperview() }
        
        contentView.addSubview(cardContainer)
        cardContainer.addSubview(mainStack)
        mainStack.addArrangedSubview(newsImageView)
        
        let contentWrapper = UIStackView()
        contentWrapper.axis = .vertical
        contentWrapper.spacing = 8
        contentWrapper.isLayoutMarginsRelativeArrangement = true
        contentWrapper.layoutMargins = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        contentWrapper.addArrangedSubview(titleLabel)
        contentWrapper.addArrangedSubview(bodyLabel)
        
        sourceStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        sourceStack.addArrangedSubview(sourceTextView)
        let sourceSpacer = UIView()
        sourceSpacer.setContentHuggingPriority(.defaultLow, for: .horizontal)
        sourceStack.addArrangedSubview(sourceSpacer)
        
        contentWrapper.addArrangedSubview(sourceStack)
        mainStack.addArrangedSubview(contentWrapper)
        mainStack.addArrangedSubview(separatorLine)
        
        let actionWrapper = UIView()
        actionWrapper.addSubview(actionStack)
        setupActionButtons()
        
        actionStack.addArrangedSubview(like)
        actionStack.addArrangedSubview(dislike)
        
        let midSpacer = UIView()
        midSpacer.translatesAutoresizingMaskIntoConstraints = false
        midSpacer.setContentHuggingPriority(.defaultLow, for: .horizontal)
        actionStack.addArrangedSubview(midSpacer)
        
        actionStack.addArrangedSubview(devknows)
        actionStack.addArrangedSubview(discussion)
        actionStack.addArrangedSubview(bookmark)
        
        mainStack.addArrangedSubview(actionWrapper)
        
        NSLayoutConstraint.activate([
            cardContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            cardContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            cardContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            cardContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            mainStack.topAnchor.constraint(equalTo: cardContainer.topAnchor),
            mainStack.bottomAnchor.constraint(equalTo: cardContainer.bottomAnchor, constant: -12),
            mainStack.leadingAnchor.constraint(equalTo: cardContainer.leadingAnchor),
            mainStack.trailingAnchor.constraint(equalTo: cardContainer.trailingAnchor),
            
            sourceTextView.heightAnchor.constraint(greaterThanOrEqualToConstant: 24),
            
            actionStack.topAnchor.constraint(equalTo: actionWrapper.topAnchor),
            actionStack.bottomAnchor.constraint(equalTo: actionWrapper.bottomAnchor),
            actionStack.leadingAnchor.constraint(equalTo: actionWrapper.leadingAnchor, constant: 16),
            actionStack.trailingAnchor.constraint(equalTo: actionWrapper.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupActionButtons() {
        let config = UIImage.SymbolConfiguration(pointSize: 16, weight: .medium)
        func style(_ btn: UIButton, icon: String) {
            btn.setImage(UIImage(systemName: icon, withConfiguration: config), for: .normal)
            btn.tintColor = .systemGray
        }
        style(like, icon: "hand.thumbsup")
        style(dislike, icon: "hand.thumbsdown")
        style(discussion, icon: "bubble.left")
        style(bookmark, icon: "bookmark")
        
        like.addTarget(self, action: #selector(likeTapped), for: .touchUpInside)
        bookmark.addTarget(self, action: #selector(bookmarkTapped), for: .touchUpInside)
    }
}

