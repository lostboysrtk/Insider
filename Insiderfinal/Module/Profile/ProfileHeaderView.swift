import UIKit

class ProfileHeaderView: UIView {
    
    weak var parentViewController: UIViewController?
    
    private let cardContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemGroupedBackground
        view.layer.cornerRadius = 28
        return view
    }()
    
    private let avatarImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "person.circle.fill")
        iv.tintColor = .systemGray4
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 50
        iv.layer.borderWidth = 4
        iv.layer.borderColor = UIColor.secondarySystemGroupedBackground.cgColor
        iv.clipsToBounds = true
        return iv
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "User"
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .systemBlue
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private let editButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "Edit Profile"
        config.baseBackgroundColor = .systemBlue
        config.baseForegroundColor = .white
        config.cornerStyle = .capsule
        let button = UIButton(configuration: config)
        return button
    }()
    
    private let bioHeaderLabel: UILabel = {
        let label = UILabel()
        label.text = "ABOUT"
        label.font = .systemFont(ofSize: 11, weight: .bold)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let bioLabel: UILabel = {
        let label = UILabel()
        label.text = "iOS Developer | Tech Enthusiast | Love building amazing apps"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    
    private let divider: UIView = {
        let view = UIView()
        view.backgroundColor = .separator
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        setupActions()
    }
    
    required init?(coder: NSCoder) { fatalError() }
    
    func configure(name: String?, email: String?) {
        if let name = name, !name.isEmpty { nameLabel.text = name }
        emailLabel.text = email
    }
    
    func configure(name: String?, email: String?, bio: String?) {
        if let name = name, !name.isEmpty { nameLabel.text = name }
        emailLabel.text = email
        if let bio = bio, !bio.isEmpty {
            bioLabel.text = bio
        }
    }
    
    private func setupActions() {
        editButton.addTarget(self, action: #selector(editProfileTapped), for: .touchUpInside)
    }
    
    @objc private func editProfileTapped() {
        let editVC = EditProfileViewController()
        parentViewController?.navigationController?.pushViewController(editVC, animated: true)
    }
    
    private func setupLayout() {
        backgroundColor = .clear
        addSubview(cardContainer)
        cardContainer.translatesAutoresizingMaskIntoConstraints = false
        
        let identityStack = UIStackView(arrangedSubviews: [avatarImageView, nameLabel, emailLabel, editButton])
        identityStack.axis = .vertical
        identityStack.alignment = .center
        identityStack.spacing = 10
        identityStack.setCustomSpacing(15, after: emailLabel)
        
        [identityStack, divider, bioHeaderLabel, bioLabel].forEach {
            cardContainer.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            cardContainer.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            cardContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            cardContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            cardContainer.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            
            avatarImageView.widthAnchor.constraint(equalToConstant: 100),
            avatarImageView.heightAnchor.constraint(equalToConstant: 100),
            
            identityStack.topAnchor.constraint(equalTo: cardContainer.topAnchor, constant: 25),
            identityStack.centerXAnchor.constraint(equalTo: cardContainer.centerXAnchor),
            
            divider.topAnchor.constraint(equalTo: identityStack.bottomAnchor, constant: 25),
            divider.leadingAnchor.constraint(equalTo: cardContainer.leadingAnchor, constant: 30),
            divider.trailingAnchor.constraint(equalTo: cardContainer.trailingAnchor, constant: -30),
            divider.heightAnchor.constraint(equalToConstant: 0.5),
            
            bioHeaderLabel.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 20),
            bioHeaderLabel.leadingAnchor.constraint(equalTo: cardContainer.leadingAnchor, constant: 25),
            
            bioLabel.topAnchor.constraint(equalTo: bioHeaderLabel.bottomAnchor, constant: 8),
            bioLabel.leadingAnchor.constraint(equalTo: cardContainer.leadingAnchor, constant: 25),
            bioLabel.trailingAnchor.constraint(equalTo: cardContainer.trailingAnchor, constant: -25),
            bioLabel.bottomAnchor.constraint(equalTo: cardContainer.bottomAnchor, constant: -25)
        ])
    }
}
