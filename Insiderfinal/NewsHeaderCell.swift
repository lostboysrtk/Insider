// NewsHeaderCell.swift
// Complete code, updated for live API image loading.

import UIKit

// NOTE: This code assumes the 'ImageLoader' class is available in your project.

/// Cell to display news summary at the top of Discussion screen
class NewsHeaderCell: UITableViewCell {
    
    // MARK: - Outlets (Connect these in Storyboard to your UI elements)
    @IBOutlet weak var newsImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var tagsLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var discussionCountLabel: UILabel!
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        print("🔧 NewsHeaderCell awakeFromNib")
        
        // Style the cell
        selectionStyle = .none
        backgroundColor = .clear
        
        // Round image corners
        newsImageView?.layer.cornerRadius = 12
        newsImageView?.clipsToBounds = true
        newsImageView?.contentMode = .scaleAspectFill
        
        // Round profile button
        profileButton?.layer.cornerRadius = 20
        profileButton?.clipsToBounds = true
        profileButton?.isUserInteractionEnabled = false
        
        // Style labels (unchanged)
        titleLabel?.font = .boldSystemFont(ofSize: 20)
        titleLabel?.numberOfLines = 0
        titleLabel?.textColor = .label
        
        descriptionLabel?.font = .systemFont(ofSize: 15)
        descriptionLabel?.numberOfLines = 0
        descriptionLabel?.textColor = .secondaryLabel
        
        userNameLabel?.font = .boldSystemFont(ofSize: 14)
        userNameLabel?.textColor = .label
        
        timeLabel?.font = .systemFont(ofSize: 12)
        timeLabel?.textColor = .secondaryLabel
        
        tagsLabel?.font = .systemFont(ofSize: 12)
        tagsLabel?.textColor = .systemBlue
        tagsLabel?.numberOfLines = 0
        
        sourceLabel?.font = .systemFont(ofSize: 12)
        sourceLabel?.textColor = .systemGray
        
        likeCountLabel?.font = .systemFont(ofSize: 14)
        likeCountLabel?.textColor = .label
        
        discussionCountLabel?.font = .systemFont(ofSize: 14)
        discussionCountLabel?.textColor = .label
        
        // Add card-like appearance
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = true
        contentView.backgroundColor = .systemBackground
        
        // Add shadow to cell
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 8
        layer.shadowOpacity = 0.1
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // Clear all dynamic content to prevent recycling issues
        newsImageView?.image = nil
        titleLabel?.text = nil
        descriptionLabel?.text = nil
        userNameLabel?.text = nil
        timeLabel?.text = nil
        tagsLabel?.text = nil
        sourceLabel?.text = nil
    }
    
    // MARK: - Configuration (Updated for API/Live Data)
    
    /// Configure the cell with a NewsItem
    func configure(with newsItem: NewsItem) {
        print("🔧 Configuring NewsHeaderCell with: \(newsItem.title)")
        
        // Set text content
        titleLabel?.text = newsItem.title
        descriptionLabel?.text = newsItem.description
        userNameLabel?.text = newsItem.userName
        timeLabel?.text = newsItem.timeAgo
        sourceLabel?.text = "Source: \(newsItem.source)"
        tagsLabel?.text = newsItem.tags.joined(separator: " ")
        
        // Set counts (these are Strings in your NewsItem)
        likeCountLabel?.text = "👍 \(newsItem.likes)"
        discussionCountLabel?.text = "💬 \(newsItem.discussions)"
        
        // ⭐️ API/DYNAMIC IMAGE LOAD ⭐️
        newsImageView?.contentMode = .scaleAspectFill
        // Use the ImageLoader service to fetch the image from the URL
        ImageLoader.shared.loadImage(from: newsItem.imageURL, into: newsImageView)
        
        // Set profile color
        profileButton?.backgroundColor = newsItem.profileColor
        profileButton?.setTitle("", for: .normal)
        
        print("   ✅ NewsHeaderCell configured successfully")
    }
}
