import UIKit

class CommunityPostCell: UITableViewCell {
    
    private let titleLabel = UILabel()
    private let descLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        titleLabel.font = .boldSystemFont(ofSize: 16)
        descLabel.font = .systemFont(ofSize: 14)
        descLabel.numberOfLines = 2
        descLabel.textColor = .secondaryLabel
        
        [titleLabel, descLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            descLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            descLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            descLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            descLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    func configure(with post: CommunityPost) {
        titleLabel.text = post.title
        descLabel.text = post.desc
    }
}
