// NewsCardCell.swift
// Complete code for the discussion header cell, updated for API live images.

import UIKit

// NOTE: This code assumes the 'ImageLoader' class is available in your project.

class NewsCardCell: UITableViewCell {
    
    // Your existing IBOutlets:
    @IBOutlet weak var image2: UIImageView! // News Image
    @IBOutlet weak var titleLabel: UITextView! // News Headline/Title
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dislikeButton: UIButton!
    @IBOutlet weak var bookmarkButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        
        // Style the image view
        image2.contentMode = .scaleAspectFill
        image2.layer.cornerRadius = 8 // Example styling
        image2.clipsToBounds = true
        
        // Optional: Ensure text views are non-editable
        titleLabel.isEditable = false
        titleLabel.isScrollEnabled = false
    }
    
    // MARK: - Configuration (Updated for API/Live Data)
    
    func configure(with item: NewsItem) {
        
        // Set the title
        titleLabel.text = item.title
        
        // Set button counts (using API placeholders)
        likeButton.setTitle(item.likes, for: .normal)
        dislikeButton.setTitle(item.dislikes, for: .normal)
        bookmarkButton.setTitle(item.bookmarks, for: .normal)
        
        // ⭐️ API/DYNAMIC IMAGE LOAD ⭐️
        
        // Use the ImageLoader service to asynchronously fetch the image from the URL
        ImageLoader.shared.loadImage(from: item.imageURL, into: image2)
        
        // Optional: Reset tint color if needed
        likeButton.tintColor = .systemGray
        dislikeButton.tintColor = .systemGray
        bookmarkButton.tintColor = .systemGray
    }
}
