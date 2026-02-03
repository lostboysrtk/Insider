import UIKit

// MARK: - Model
struct DiscussionPost {
    let id = UUID()
    let author: String = "Me"
    var text: String
    var likes: Int = 0
    var replies: [DiscussionPost] = []
    var level: Int = 0
    var replyingTo: String?
}

class PostDiscussionViewController: UIViewController {
    
    var newsItem: NewsItem?
    private var discussionThreads: [DiscussionPost] = []
    private var activeReplyIndex: Int?
    
    // MARK: - Interaction Bar Properties
    private let likeBtn = UIButton(type: .system)
    private let dislikeBtn = UIButton(type: .system)
    private let devKnowsBtn = UIButton(type: .system)
    private let bookmarkBtn = UIButton(type: .system)
    private let separatorLine = UIView()

    private var isLiked = false
    private var isDisliked = false
    private var isBookmarked = false
    
    // MARK: - UI Elements
    private let tableView = UITableView(frame: .zero, style: .plain)
    
    private let inputBar: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: -1)
        view.layer.shadowOpacity = 0.05
        view.layer.shadowRadius = 5
        return view
    }()
    
    private let replyField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Write a new thread..."
        tf.backgroundColor = UIColor(white: 0.96, alpha: 1.0)
        tf.layer.cornerRadius = 18
        tf.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 1))
        tf.leftViewMode = .always
        return tf
    }()
    
    private let sendButton: UIButton = {
        let btn = UIButton(type: .system)
        let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .bold)
        btn.setImage(UIImage(systemName: "paperplane.fill", withConfiguration: config), for: .normal)
        btn.tintColor = .systemBlue
        return btn
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        setupKeyboardHandling()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.tintColor = .black
        let titleLabel = UILabel()
        titleLabel.text = "Discussion"
        titleLabel.font = .systemFont(ofSize: 17, weight: .bold)
        titleLabel.textColor = .black
        navigationItem.titleView = titleLabel
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(DiscussionCommentCell.self, forCellReuseIdentifier: "CommentCell")
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.backgroundColor = .white
        
        view.addSubview(tableView)
        view.addSubview(inputBar)
        inputBar.addSubview(replyField)
        inputBar.addSubview(sendButton)
        
        [tableView, inputBar, replyField, sendButton].forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: inputBar.topAnchor),
            
            inputBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            inputBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            inputBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            inputBar.heightAnchor.constraint(equalToConstant: 60),
            
            replyField.leadingAnchor.constraint(equalTo: inputBar.leadingAnchor, constant: 16),
            replyField.centerYAnchor.constraint(equalTo: inputBar.centerYAnchor),
            replyField.heightAnchor.constraint(equalToConstant: 36),
            replyField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -8),
            
            sendButton.trailingAnchor.constraint(equalTo: inputBar.trailingAnchor, constant: -16),
            sendButton.centerYAnchor.constraint(equalTo: inputBar.centerYAnchor),
            sendButton.widthAnchor.constraint(equalToConstant: 44)
        ])
        
        setupHeader()
    }
    
    private func setupHeader() {
        let headerWidth = view.frame.width
        let imageHeight: CGFloat = 350
        let spacing: CGFloat = 20
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: headerWidth, height: 500))
        headerView.backgroundColor = .white
        
        let postImage = UIImageView(frame: CGRect(x: 0, y: 0, width: headerWidth, height: imageHeight))
        postImage.contentMode = .scaleAspectFill
        postImage.clipsToBounds = true
        
        let headlineLabel = UILabel(frame: CGRect(x: spacing, y: imageHeight + 10, width: headerWidth - (spacing * 2), height: 60))
        headlineLabel.font = .systemFont(ofSize: 18, weight: .bold)
        headlineLabel.numberOfLines = 2
        
        if let item = newsItem {
            ImageLoader.shared.loadImage(from: item.imageURL, into: postImage)
            headlineLabel.text = item.title
        }
        
        let interactionStack = UIStackView()
        interactionStack.axis = .horizontal
        interactionStack.distribution = .fill
        interactionStack.spacing = 25
        interactionStack.translatesAutoresizingMaskIntoConstraints = false
        
        let config = UIImage.SymbolConfiguration(pointSize: 18, weight: .medium)
        func style(_ btn: UIButton, icon: String, color: UIColor = .systemGray) {
            btn.setImage(UIImage(systemName: icon, withConfiguration: config), for: .normal)
            btn.tintColor = color
        }
        
        style(likeBtn, icon: "hand.thumbsup")
        style(dislikeBtn, icon: "hand.thumbsdown")
        style(devKnowsBtn, icon: "sparkles", color: .systemIndigo)
        style(bookmarkBtn, icon: "bookmark")
        
        [likeBtn, dislikeBtn, bookmarkBtn, devKnowsBtn].forEach { $0.addTarget(self, action: #selector(btnTapped), for: .touchUpInside) }

        interactionStack.addArrangedSubview(likeBtn)
        interactionStack.addArrangedSubview(dislikeBtn)
        let spacer = UIView()
        spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)
        interactionStack.addArrangedSubview(spacer)
        interactionStack.addArrangedSubview(devKnowsBtn)
        interactionStack.addArrangedSubview(bookmarkBtn)
        
        separatorLine.backgroundColor = UIColor(white: 0.92, alpha: 1.0)
        separatorLine.translatesAutoresizingMaskIntoConstraints = false
        
        headerView.addSubview(postImage)
        headerView.addSubview(headlineLabel)
        headerView.addSubview(interactionStack)
        headerView.addSubview(separatorLine)
        
        NSLayoutConstraint.activate([
            interactionStack.topAnchor.constraint(equalTo: headlineLabel.bottomAnchor, constant: 10),
            interactionStack.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: spacing),
            interactionStack.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -spacing),
            interactionStack.heightAnchor.constraint(equalToConstant: 44),
            
            separatorLine.topAnchor.constraint(equalTo: interactionStack.bottomAnchor, constant: 10),
            separatorLine.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: spacing),
            separatorLine.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -spacing),
            separatorLine.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        tableView.tableHeaderView = headerView
    }

    @objc private func btnTapped(sender: UIButton) {
        if sender == likeBtn { isLiked.toggle(); isDisliked = false }
        if sender == dislikeBtn { isDisliked.toggle(); isLiked = false }
        if sender == bookmarkBtn { isBookmarked.toggle() }
        if sender == devKnowsBtn {
             let devVC = DevKnowsViewController()
             devVC.newsItemContext = newsItem
             present(devVC, animated: true)
        }
        updateHeaderUI()
    }

    private func updateHeaderUI() {
        likeBtn.setImage(UIImage(systemName: isLiked ? "hand.thumbsup.fill" : "hand.thumbsup"), for: .normal)
        dislikeBtn.setImage(UIImage(systemName: isDisliked ? "hand.thumbsdown.fill" : "hand.thumbsdown"), for: .normal)
        bookmarkBtn.setImage(UIImage(systemName: isBookmarked ? "bookmark.fill" : "bookmark"), for: .normal)
    }

    @objc private func handleSend() {
        guard let text = replyField.text, !text.isEmpty else { return }
        
        if let threadIndex = activeReplyIndex {
            let reply = DiscussionPost(text: text, level: 1, replyingTo: discussionThreads[threadIndex].author)
            discussionThreads[threadIndex].replies.append(reply)
        } else {
            let newThread = DiscussionPost(text: text, level: 0)
            discussionThreads.append(newThread)
        }
        
        replyField.text = ""
        replyField.placeholder = "Write a new thread..."
        activeReplyIndex = nil
        view.endEditing(true)
        tableView.reloadData()
    }

    private func setupKeyboardHandling() {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in
            if let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let height = value.cgRectValue.height
                self.inputBar.transform = CGAffineTransform(translationX: 0, y: -height + self.view.safeAreaInsets.bottom)
            }
        }
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
            self.inputBar.transform = .identity
        }
    }
}

// MARK: - TableView Extensions
extension PostDiscussionViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return discussionThreads.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 + discussionThreads[section].replies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! DiscussionCommentCell
        let thread = discussionThreads[indexPath.section]
        let post = indexPath.row == 0 ? thread : thread.replies[indexPath.row - 1]
        
        let isFirst = indexPath.row == 0
        let isLast = indexPath.row == thread.replies.count
        
        cell.configure(with: post, isFirstInBlock: isFirst, isLastInBlock: isLast)
        
        cell.onReply = { [weak self] in
            self?.activeReplyIndex = indexPath.section
            self?.replyField.placeholder = "Replying in thread..."
            self?.replyField.becomeFirstResponder()
        }
        return cell
    }
}

// MARK: - Refined Card Discussion Cell
class DiscussionCommentCell: UITableViewCell {
    var onReply: (() -> Void)?
    
    private let containerView = UIView()
    private let authorLabel = UILabel()
    private let messageLabel = UILabel()
    private let likeBtn = UIButton(type: .system)
    private let dislikeBtn = UIButton(type: .system)
    private let replyBtn = UIButton(type: .system)
    
    private var leftPaddingConstraint: NSLayoutConstraint?
    private var containerBottomConstraint: NSLayoutConstraint?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    private func setupCell() {
        backgroundColor = .clear
        selectionStyle = .none
        
        containerView.backgroundColor = UIColor(white: 0.97, alpha: 1.0)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)
        
        authorLabel.font = .systemFont(ofSize: 13, weight: .bold)
        authorLabel.textColor = .systemBlue
        
        messageLabel.font = .systemFont(ofSize: 15)
        messageLabel.numberOfLines = 0
        
        let config = UIImage.SymbolConfiguration(pointSize: 12, weight: .medium)
        likeBtn.setImage(UIImage(systemName: "arrow.up", withConfiguration: config), for: .normal)
        dislikeBtn.setImage(UIImage(systemName: "arrow.down", withConfiguration: config), for: .normal)
        [likeBtn, dislikeBtn].forEach { $0.tintColor = .systemGray }
        
        replyBtn.setTitle("Reply", for: .normal)
        replyBtn.titleLabel?.font = .systemFont(ofSize: 12, weight: .bold)
        replyBtn.addTarget(self, action: #selector(replyTapped), for: .touchUpInside)
        
        [authorLabel, messageLabel, likeBtn, dislikeBtn, replyBtn].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview($0)
        }
        
        leftPaddingConstraint = authorLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16)
        containerBottomConstraint = containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerBottomConstraint!,
            
            authorLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 12),
            leftPaddingConstraint!,
            
            messageLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 4),
            messageLabel.leadingAnchor.constraint(equalTo: authorLabel.leadingAnchor),
            messageLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            
            likeBtn.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 10),
            likeBtn.leadingAnchor.constraint(equalTo: authorLabel.leadingAnchor),
            likeBtn.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12),
            
            dislikeBtn.centerYAnchor.constraint(equalTo: likeBtn.centerYAnchor),
            dislikeBtn.leadingAnchor.constraint(equalTo: likeBtn.trailingAnchor, constant: 15),
            
            replyBtn.centerYAnchor.constraint(equalTo: likeBtn.centerYAnchor),
            replyBtn.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16)
        ])
    }
    
    @objc private func replyTapped() { onReply?() }
    
    func configure(with post: DiscussionPost, isFirstInBlock: Bool, isLastInBlock: Bool) {
        authorLabel.text = post.author
        
        if let tag = post.replyingTo {
            let attrText = NSMutableAttributedString(string: "@\(tag) ", attributes: [.foregroundColor: UIColor.systemBlue, .font: UIFont.boldSystemFont(ofSize: 14)])
            attrText.append(NSAttributedString(string: post.text))
            messageLabel.attributedText = attrText
            leftPaddingConstraint?.constant = 40
        } else {
            messageLabel.text = post.text
            leftPaddingConstraint?.constant = 16
        }
        
        containerView.layer.cornerRadius = 12
        var maskedCorners: CACornerMask = []
        if isFirstInBlock { maskedCorners.insert([.layerMinXMinYCorner, .layerMaxXMinYCorner]) }
        if isLastInBlock { maskedCorners.insert([.layerMinXMaxYCorner, .layerMaxXMaxYCorner]) }
        containerView.layer.maskedCorners = maskedCorners
        
        // Gap logic
        if isLastInBlock {
            containerBottomConstraint?.constant = -16
        } else {
            containerBottomConstraint?.constant = 0
        }
    }
}
