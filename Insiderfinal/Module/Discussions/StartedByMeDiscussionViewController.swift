import UIKit

// MARK: - 1. Models


struct SBMComment {
    let id = UUID()
    let userName: String
    let text: String
    let timeAgo: String
    var likes: Int
    let profileColor: UIColor
    let isReply: Bool
    var voteStatus: VoteStatus = .none
    var nestedReplies: [SBMComment] = []
    var isExpanded: Bool = false
}

// MARK: - 2. View Controller
class StartedByMeDiscussionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private let tableView = UITableView(frame: .zero, style: .grouped)
    private let commentInputBar = UIView()
    private let inputField = UITextField()
    private let sendButton = UIButton(type: .system)
    
    var newsItem: NewsItem?
    var userInitialComment: String = "I think the new power management features are going to be a game changer for mobile developers. Can't wait to test the API!"
    
    private var activeReplyToUsername: String?
    private var activeReplyToIndex: Int?
    
    private var comments: [SBMComment] = [
        SBMComment(userName: "TechGuru_99", text: "I totally agree. The power efficiency is incredible.", timeAgo: "2h", likes: 12, profileColor: .systemGray, isReply: false, nestedReplies: [
            SBMComment(userName: "User_A", text: "True, but the cost is still quite high.", timeAgo: "1h", likes: 2, profileColor: .systemGray, isReply: true),
            SBMComment(userName: "User_B", text: "Worth it for pro users who need performance.", timeAgo: "45m", likes: 5, profileColor: .systemGray, isReply: true),
            SBMComment(userName: "User_C", text: "Still on M1, worth upgrading this year?", timeAgo: "30m", likes: 1, profileColor: .systemGray, isReply: true)
        ]),
        SBMComment(userName: "SwiftDev_Emily", text: "Does the API support backward compatibility?", timeAgo: "5h", likes: 8, profileColor: .systemGray, isReply: false)
    ]

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        self.hidesBottomBarWhenPushed = true
    }

    required init?(coder: NSCoder) { fatalError() }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavbar()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateNavbarAppearance()
    }

    private func setupNavbar() {
        self.title = "Started by me"
        navigationItem.largeTitleDisplayMode = .never
        updateNavbarAppearance()
    }
    
    private func updateNavbarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        
        let titleColor: UIColor = tableView.contentOffset.y > 250 ? .label : .white
        appearance.titleTextAttributes = [
            .foregroundColor: titleColor,
            .font: UIFont.systemFont(ofSize: 17, weight: .semibold)
        ]
        
        navigationController?.navigationBar.tintColor = titleColor
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }

    private func setupUI() {
        view.backgroundColor = .systemGroupedBackground
        
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(SBMCardCommentCell.self, forCellReuseIdentifier: "CardCell")
        
        commentInputBar.backgroundColor = .systemBackground
        commentInputBar.translatesAutoresizingMaskIntoConstraints = false
        
        inputField.placeholder = "Write a comment..."
        inputField.backgroundColor = .systemGray6
        inputField.layer.cornerRadius = 20
        inputField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 0))
        inputField.leftViewMode = .always
        inputField.translatesAutoresizingMaskIntoConstraints = false
        
        sendButton.setImage(UIImage(systemName: "paperplane.fill"), for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: #selector(handleSendComment), for: .touchUpInside)

        view.addSubview(tableView)
        view.addSubview(commentInputBar)
        commentInputBar.addSubview(inputField)
        commentInputBar.addSubview(sendButton)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: commentInputBar.topAnchor),
            
            commentInputBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            commentInputBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            commentInputBar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            commentInputBar.heightAnchor.constraint(equalToConstant: 100),
            
            inputField.topAnchor.constraint(equalTo: commentInputBar.topAnchor, constant: 12),
            inputField.leadingAnchor.constraint(equalTo: commentInputBar.leadingAnchor, constant: 16),
            inputField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -12),
            inputField.heightAnchor.constraint(equalToConstant: 40),

            sendButton.centerYAnchor.constraint(equalTo: inputField.centerYAnchor),
            sendButton.trailingAnchor.constraint(equalTo: commentInputBar.trailingAnchor, constant: -16)
        ])
    }
    
    @objc private func handleSendComment() {
        guard let text = inputField.text, !text.isEmpty else { return }
        
        if let replyIndex = activeReplyToIndex {
            let newReply = SBMComment(userName: "Me", text: text, timeAgo: "now", likes: 0, profileColor: .systemBlue, isReply: true, voteStatus: .upvoted)
            comments[replyIndex].nestedReplies.append(newReply)
            comments[replyIndex].isExpanded = true
        } else {
            let newComment = SBMComment(userName: "Me", text: text, timeAgo: "now", likes: 0, profileColor: .systemBlue, isReply: false, voteStatus: .upvoted)
            comments.insert(newComment, at: 0)
        }
        
        inputField.text = ""
        inputField.placeholder = "Write a comment..."
        activeReplyToUsername = nil
        activeReplyToIndex = nil
        inputField.resignFirstResponder()
        tableView.reloadData()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updateNavbarAppearance()
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let item = newsItem else { return nil }
        let headerView = UIView()

        let articleImageView = UIImageView()
        articleImageView.contentMode = .scaleAspectFill
        articleImageView.clipsToBounds = true
        articleImageView.backgroundColor = .systemGray6
        articleImageView.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(articleImageView)
        
        if let urlStr = item.imageURL, let url = URL(string: urlStr) {
            URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data { DispatchQueue.main.async { articleImageView.image = UIImage(data: data) } }
            }.resume()
        }
        
        let headlineLabel = UILabel()
        headlineLabel.text = item.title.uppercased()
        headlineLabel.font = .systemFont(ofSize: 11, weight: .bold)
        headlineLabel.textColor = .tertiaryLabel
        headlineLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let myCommentLabel = UILabel()
        myCommentLabel.text = userInitialComment
        myCommentLabel.font = .systemFont(ofSize: 22, weight: .bold)
        myCommentLabel.numberOfLines = 0
        myCommentLabel.translatesAutoresizingMaskIntoConstraints = false
        
        [headlineLabel, myCommentLabel].forEach { headerView.addSubview($0) }

        NSLayoutConstraint.activate([
            articleImageView.topAnchor.constraint(equalTo: headerView.topAnchor),
            articleImageView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            articleImageView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            articleImageView.heightAnchor.constraint(equalToConstant: 280),

            headlineLabel.topAnchor.constraint(equalTo: articleImageView.bottomAnchor, constant: 20),
            headlineLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            
            myCommentLabel.topAnchor.constraint(equalTo: headlineLabel.bottomAnchor, constant: 8),
            myCommentLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor, constant: 16),
            myCommentLabel.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -16),
            myCommentLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -24)
        ])
        return headerView
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return comments.count }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CardCell", for: indexPath) as! SBMCardCommentCell
        cell.configure(with: comments[indexPath.row])
        
        cell.onToggleExpansion = { [weak self] in
            guard let self = self else { return }
            self.comments[indexPath.row].isExpanded.toggle()
            UIView.setAnimationsEnabled(false)
            self.tableView.beginUpdates()
            cell.configure(with: self.comments[indexPath.row])
            self.tableView.endUpdates()
            UIView.setAnimationsEnabled(true)
        }
        
        cell.onReplyTriggered = { [weak self] username in
            self?.activeReplyToUsername = username
            self?.activeReplyToIndex = indexPath.row
            self?.inputField.placeholder = "Replying to \(username)..."
            self?.inputField.becomeFirstResponder()
        }
        
        return cell
    }
}

// MARK: - 3. Card Cell
class SBMCardCommentCell: UITableViewCell {
    private let mainCard = UIView()
    private let profileImage = UIImageView(image: UIImage(systemName: "person.crop.circle.fill"))
    private let nameLabel = UILabel()
    private let timeLabel = UILabel()
    private let bodyLabel = UILabel()
    private let actionsStack = UIStackView()
    private let upBtn = UIButton()
    private let scoreLabel = UILabel()
    private let downBtn = UIButton()
    private let replyBtn = UIButton()
    private let threadLine = UIView()
    private let replyStack = UIStackView()
    private let viewMoreBtn = UIButton(type: .system)

    var onToggleExpansion: (() -> Void)?
    var onReplyTriggered: ((String) -> Void)?
    
    private var currentVoteStatus: VoteStatus = .none
    private var baseLikes: Int = 0

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupLayout()
    }
    
    required init?(coder: NSCoder) { fatalError() }

    private func setupLayout() {
        selectionStyle = .none
        backgroundColor = .clear
        
        mainCard.backgroundColor = .systemBackground
        mainCard.layer.cornerRadius = 16
        mainCard.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(mainCard)
        
        profileImage.tintColor = .systemGray4
        profileImage.contentMode = .scaleAspectFit
        
        nameLabel.font = .systemFont(ofSize: 13, weight: .bold)
        
        timeLabel.font = .systemFont(ofSize: 11)
        timeLabel.textColor = .tertiaryLabel
        
        bodyLabel.font = .systemFont(ofSize: 14)
        bodyLabel.numberOfLines = 0
        
        scoreLabel.font = .systemFont(ofSize: 12, weight: .bold)
        scoreLabel.textColor = .secondaryLabel
        
        upBtn.setImage(UIImage(systemName: "hand.thumbsup"), for: .normal)
        upBtn.tintColor = .systemGray2
        upBtn.addTarget(self, action: #selector(handleParentUpvote), for: .touchUpInside)
        
        downBtn.setImage(UIImage(systemName: "hand.thumbsdown"), for: .normal)
        downBtn.tintColor = .systemGray2
        downBtn.addTarget(self, action: #selector(handleParentDownvote), for: .touchUpInside)
        
        replyBtn.setImage(UIImage(systemName: "arrowshape.turn.up.left.fill"), for: .normal)
        replyBtn.setTitle(" Reply", for: .normal)
        replyBtn.titleLabel?.font = .systemFont(ofSize: 12, weight: .bold)
        replyBtn.tintColor = .systemGray2
        replyBtn.addTarget(self, action: #selector(handleParentReply), for: .touchUpInside)
        
        [upBtn, scoreLabel, downBtn, replyBtn].forEach { actionsStack.addArrangedSubview($0) }
        actionsStack.spacing = 16
        actionsStack.alignment = .center
        
        threadLine.backgroundColor = .systemGray5
        
        replyStack.axis = .vertical
        replyStack.spacing = 10
        
        viewMoreBtn.titleLabel?.font = .systemFont(ofSize: 12, weight: .bold)
        viewMoreBtn.setTitleColor(.systemGray, for: .normal)
        viewMoreBtn.addTarget(self, action: #selector(handleExpand), for: .touchUpInside)

        [profileImage, nameLabel, timeLabel, bodyLabel, actionsStack, threadLine, replyStack, viewMoreBtn].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            mainCard.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            mainCard.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            mainCard.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainCard.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mainCard.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            
            profileImage.topAnchor.constraint(equalTo: mainCard.topAnchor, constant: 12),
            profileImage.leadingAnchor.constraint(equalTo: mainCard.leadingAnchor, constant: 12),
            profileImage.widthAnchor.constraint(equalToConstant: 28),
            profileImage.heightAnchor.constraint(equalToConstant: 28),
            
            nameLabel.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 10),
            
            timeLabel.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor),
            timeLabel.trailingAnchor.constraint(equalTo: mainCard.trailingAnchor, constant: -12),
            
            bodyLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 10),
            bodyLabel.leadingAnchor.constraint(equalTo: mainCard.leadingAnchor, constant: 12),
            bodyLabel.trailingAnchor.constraint(equalTo: mainCard.trailingAnchor, constant: -12),
            
            actionsStack.topAnchor.constraint(equalTo: bodyLabel.bottomAnchor, constant: 12),
            actionsStack.leadingAnchor.constraint(equalTo: mainCard.leadingAnchor, constant: 12),
            
            threadLine.topAnchor.constraint(equalTo: actionsStack.bottomAnchor, constant: 12),
            threadLine.leadingAnchor.constraint(equalTo: mainCard.leadingAnchor, constant: 25),
            threadLine.widthAnchor.constraint(equalToConstant: 2),
            threadLine.bottomAnchor.constraint(equalTo: viewMoreBtn.topAnchor, constant: -10),
            
            replyStack.topAnchor.constraint(equalTo: actionsStack.bottomAnchor, constant: 12),
            replyStack.leadingAnchor.constraint(equalTo: threadLine.trailingAnchor, constant: 12),
            replyStack.trailingAnchor.constraint(equalTo: mainCard.trailingAnchor, constant: -12),
            
            viewMoreBtn.topAnchor.constraint(equalTo: replyStack.bottomAnchor, constant: 8),
            viewMoreBtn.leadingAnchor.constraint(equalTo: replyStack.leadingAnchor),
            viewMoreBtn.bottomAnchor.constraint(equalTo: mainCard.bottomAnchor, constant: -12)
        ])
    }

    func configure(with comment: SBMComment) {
        nameLabel.text = comment.userName
        timeLabel.text = comment.timeAgo
        bodyLabel.text = comment.text
        baseLikes = comment.likes
        currentVoteStatus = comment.voteStatus
        updateParentVoteUI()
        
        replyStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        let hasReplies = !comment.nestedReplies.isEmpty
        threadLine.isHidden = !hasReplies
        
        let repliesToShow = comment.isExpanded ? comment.nestedReplies : Array(comment.nestedReplies.prefix(2))
        repliesToShow.forEach { replyStack.addArrangedSubview(createReplyBubble(for: $0)) }
        
        if comment.nestedReplies.count > 2 {
            viewMoreBtn.isHidden = false
            let remaining = comment.nestedReplies.count - 2
            viewMoreBtn.setTitle(comment.isExpanded ? "View less" : "View \(remaining) more replies", for: .normal)
        } else {
            viewMoreBtn.isHidden = true
        }
    }

    @objc private func handleParentUpvote() {
        currentVoteStatus = (currentVoteStatus == .upvoted) ? .none : .upvoted
        updateParentVoteUI()
    }

    @objc private func handleParentDownvote() {
        currentVoteStatus = (currentVoteStatus == .downvoted) ? .none : .downvoted
        updateParentVoteUI()
    }
    
    @objc private func handleParentReply() {
        onReplyTriggered?(nameLabel.text ?? "")
    }

    private func updateParentVoteUI() {
        upBtn.setImage(UIImage(systemName: currentVoteStatus == .upvoted ? "hand.thumbsup.fill" : "hand.thumbsup"), for: .normal)
        downBtn.setImage(UIImage(systemName: currentVoteStatus == .downvoted ? "hand.thumbsdown.fill" : "hand.thumbsdown"), for: .normal)
        upBtn.tintColor = currentVoteStatus == .upvoted ? .systemBlue : .systemGray2
        downBtn.tintColor = currentVoteStatus == .downvoted ? .systemRed : .systemGray2
        
        var score = baseLikes
        if currentVoteStatus == .upvoted { score += 1 }
        else if currentVoteStatus == .downvoted { score -= 1 }
        scoreLabel.text = "\(score)"
    }

    private func createReplyBubble(for reply: SBMComment) -> UIView {
        let container = UIView()
        container.backgroundColor = .systemGray6
        container.layer.cornerRadius = 10
        
        let user = UILabel()
        user.text = reply.userName
        user.font = .systemFont(ofSize: 11, weight: .bold)
        
        let time = UILabel()
        time.text = reply.timeAgo
        time.font = .systemFont(ofSize: 10)
        time.textColor = .tertiaryLabel
        
        let body = UILabel()
        body.text = reply.text
        body.font = .systemFont(ofSize: 12)
        body.numberOfLines = 0
        
        // Voting controls
        let rUp = UIButton()
        rUp.setImage(UIImage(systemName: "hand.thumbsup"), for: .normal)
        rUp.tintColor = .systemGray2
        
        let rScore = UILabel()
        rScore.text = "\(reply.likes)"
        rScore.font = .systemFont(ofSize: 11, weight: .bold)
        rScore.textColor = .secondaryLabel
        
        let rDown = UIButton()
        rDown.setImage(UIImage(systemName: "hand.thumbsdown"), for: .normal)
        rDown.tintColor = .systemGray2
        
        let rReply = UIButton()
        rReply.setImage(UIImage(systemName: "arrowshape.turn.up.left.fill"), for: .normal)
        rReply.setTitle(" Reply", for: .normal)
        rReply.titleLabel?.font = .systemFont(ofSize: 11, weight: .bold)
        rReply.tintColor = .systemGray2
        
        // Vote state management
        var bubbleVote: VoteStatus = reply.voteStatus
        let bubbleBase = reply.likes
        
        // Update UI based on initial vote status
        if bubbleVote == .upvoted {
            rUp.setImage(UIImage(systemName: "hand.thumbsup.fill"), for: .normal)
            rUp.tintColor = .systemBlue
            rScore.text = "\(bubbleBase + 1)"
        } else if bubbleVote == .downvoted {
            rDown.setImage(UIImage(systemName: "hand.thumbsdown.fill"), for: .normal)
            rDown.tintColor = .systemRed
            rScore.text = "\(bubbleBase - 1)"
        }

        rUp.addAction(UIAction(handler: { _ in
            bubbleVote = (bubbleVote == .upvoted) ? .none : .upvoted
            rUp.setImage(UIImage(systemName: bubbleVote == .upvoted ? "hand.thumbsup.fill" : "hand.thumbsup"), for: .normal)
            rDown.setImage(UIImage(systemName: "hand.thumbsdown"), for: .normal)
            rUp.tintColor = bubbleVote == .upvoted ? .systemBlue : .systemGray2
            rDown.tintColor = .systemGray2
            
            var score = bubbleBase
            if bubbleVote == .upvoted { score += 1 }
            else if bubbleVote == .downvoted { score -= 1 }
            rScore.text = "\(score)"
        }), for: .touchUpInside)

        rDown.addAction(UIAction(handler: { _ in
            bubbleVote = (bubbleVote == .downvoted) ? .none : .downvoted
            rDown.setImage(UIImage(systemName: bubbleVote == .downvoted ? "hand.thumbsdown.fill" : "hand.thumbsdown"), for: .normal)
            rUp.setImage(UIImage(systemName: "hand.thumbsup"), for: .normal)
            rDown.tintColor = bubbleVote == .downvoted ? .systemRed : .systemGray2
            rUp.tintColor = .systemGray2
            
            var score = bubbleBase
            if bubbleVote == .upvoted { score += 1 }
            else if bubbleVote == .downvoted { score -= 1 }
            rScore.text = "\(score)"
        }), for: .touchUpInside)
        
        rReply.addAction(UIAction(handler: { [weak self] _ in
            self?.onReplyTriggered?(reply.userName)
        }), for: .touchUpInside)

        let rStack = UIStackView(arrangedSubviews: [rUp, rScore, rDown, rReply])
        rStack.axis = .horizontal
        rStack.spacing = 14
        rStack.alignment = .center
        
        [user, time, body, rStack].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            container.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            user.topAnchor.constraint(equalTo: container.topAnchor, constant: 8),
            user.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 10),
            
            time.centerYAnchor.constraint(equalTo: user.centerYAnchor),
            time.leadingAnchor.constraint(equalTo: user.trailingAnchor, constant: 6),
            
            body.topAnchor.constraint(equalTo: user.bottomAnchor, constant: 4),
            body.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 10),
            body.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -10),
            
            rStack.topAnchor.constraint(equalTo: body.bottomAnchor, constant: 8),
            rStack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 10),
            rStack.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -8)
        ])
        return container
    }

    @objc private func handleExpand() { onToggleExpansion?() }
}
