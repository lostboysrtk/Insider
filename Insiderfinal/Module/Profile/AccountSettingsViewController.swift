//
//  AccountSettingsViewController.swift
//  Insiderfinal
//
//  Created by user@1 on 01/02/26.
//

import UIKit

class AccountSettingsViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let contentView = UIStackView()
    private let accentBlue = UIColor(red: 0.05, green: 0.45, blue: 0.95, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        title = "Account Settings"
        
        // Close button
        let closeButton = UIButton(type: .system)
        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.tintColor = .label
        closeButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        closeButton.layer.cornerRadius = 15
        closeButton.backgroundColor = UIColor.systemGray5.withAlphaComponent(0.5)
        closeButton.addTarget(self, action: #selector(closeTapped), for: .touchUpInside)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: closeButton)
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .black
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.label,
            .font: UIFont.systemFont(ofSize: 17, weight: .semibold)
        ]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
    }
    
    @objc private func closeTapped() {
        dismiss(animated: true)
    }
    
    private func setupUI() {
        view.backgroundColor = .black
        
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.axis = .vertical
        contentView.spacing = 20
        contentView.layoutMargins = UIEdgeInsets(top: 20, left: 16, bottom: 40, right: 16)
        contentView.isLayoutMarginsRelativeArrangement = true
        
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        // Account Info Card
        let accountEmail = "kl8868@srmist.edu.in" // You can pass this dynamically
        contentView.addArrangedSubview(createAccountCard(email: accountEmail))
        
        addInfoLabel("Editing your account and password will take you to your account management page.")
        
        // Account Management Section
        contentView.addArrangedSubview(createGroupedCard(items: [
            (title: "Edit Profile", subtitle: nil, type: .arrow, action: #selector(handleEditProfile)),
            (title: "Change Password", subtitle: nil, type: .arrow, action: #selector(handleChangePassword)),
            (title: "Email Preferences", subtitle: nil, type: .arrow, action: #selector(handleEmailPreferences)),
            (title: "Privacy Settings", subtitle: nil, type: .arrow, action: #selector(handlePrivacySettings))
        ]))
        
        // About Section
        addSectionLabel("ABOUT")
        contentView.addArrangedSubview(createGroupedCard(items: [
            (title: "Terms of Service", subtitle: nil, type: .arrow, action: #selector(handleTerms)),
            (title: "Privacy Policy", subtitle: nil, type: .arrow, action: #selector(handlePrivacy)),
            (title: "Help & Support", subtitle: nil, type: .arrow, action: #selector(handleSupport)),
            (title: "App Version", subtitle: "1.0.0", type: .none, action: nil)
        ]))
        
        // Delete Account Button
        let deleteButton = createDeleteAccountButton()
        contentView.addArrangedSubview(deleteButton)
        contentView.setCustomSpacing(30, after: deleteButton)
        
        setupConstraints()
    }
    
    private func createAccountCard(email: String) -> UIView {
        let container = UIView()
        container.backgroundColor = .secondarySystemGroupedBackground
        container.layer.cornerRadius = 16
        
        let label = UILabel()
        label.text = "Account"
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textColor = .label
        
        let emailLabel = UILabel()
        emailLabel.text = email
        emailLabel.font = .systemFont(ofSize: 15, weight: .regular)
        emailLabel.textColor = .secondaryLabel
        emailLabel.lineBreakMode = .byTruncatingMiddle
        
        let arrow = UIImageView(image: UIImage(systemName: "chevron.right"))
        arrow.tintColor = .tertiaryLabel
        arrow.contentMode = .scaleAspectFit
        
        [label, emailLabel, arrow].forEach {
            container.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleAccountTapped))
        container.addGestureRecognizer(tapGesture)
        container.isUserInteractionEnabled = true
        
        NSLayoutConstraint.activate([
            container.heightAnchor.constraint(equalToConstant: 54),
            
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
            label.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            
            arrow.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
            arrow.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            arrow.widthAnchor.constraint(equalToConstant: 10),
            
            emailLabel.trailingAnchor.constraint(equalTo: arrow.leadingAnchor, constant: -12),
            emailLabel.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            emailLabel.leadingAnchor.constraint(greaterThanOrEqualTo: label.trailingAnchor, constant: 12)
        ])
        
        return container
    }
    
    private func createGroupedCard(items: [(title: String, subtitle: String?, type: RowType, action: Selector?)]) -> UIView {
        let container = UIView()
        container.backgroundColor = .secondarySystemGroupedBackground
        container.layer.cornerRadius = 16
        
        let stack = UIStackView()
        stack.axis = .vertical
        container.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: container.topAnchor),
            stack.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        for (index, item) in items.enumerated() {
            let row = createRow(title: item.title, subtitle: item.subtitle, type: item.type, action: item.action)
            stack.addArrangedSubview(row)
            
            if index < items.count - 1 {
                let divider = UIView()
                divider.backgroundColor = .separator
                stack.addArrangedSubview(divider)
                divider.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
                
                NSLayoutConstraint.activate([
                    divider.leadingAnchor.constraint(equalTo: stack.leadingAnchor, constant: 16)
                ])
            }
        }
        
        return container
    }
    
    enum RowType { case arrow, toggle, none }
    
    private func createRow(title: String, subtitle: String?, type: RowType, action: Selector?) -> UIView {
        let rowView = UIView()
        rowView.heightAnchor.constraint(equalToConstant: 54).isActive = true
        
        if let action = action {
            rowView.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: action)
            rowView.addGestureRecognizer(tap)
        }
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = .systemFont(ofSize: 15, weight: .regular)
        titleLabel.textColor = .label
        
        rowView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: rowView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: rowView.centerYAnchor)
        ])
        
        if type == .arrow {
            if let subtitle = subtitle {
                let subtitleLabel = UILabel()
                subtitleLabel.text = subtitle
                subtitleLabel.font = .systemFont(ofSize: 15, weight: .regular)
                subtitleLabel.textColor = .secondaryLabel
                rowView.addSubview(subtitleLabel)
                subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
                
                let arrow = UIImageView(image: UIImage(systemName: "chevron.right"))
                arrow.tintColor = .tertiaryLabel
                rowView.addSubview(arrow)
                arrow.translatesAutoresizingMaskIntoConstraints = false
                
                NSLayoutConstraint.activate([
                    arrow.trailingAnchor.constraint(equalTo: rowView.trailingAnchor, constant: -16),
                    arrow.centerYAnchor.constraint(equalTo: rowView.centerYAnchor),
                    arrow.widthAnchor.constraint(equalToConstant: 10),
                    
                    subtitleLabel.trailingAnchor.constraint(equalTo: arrow.leadingAnchor, constant: -8),
                    subtitleLabel.centerYAnchor.constraint(equalTo: rowView.centerYAnchor)
                ])
            } else {
                let arrow = UIImageView(image: UIImage(systemName: "chevron.right"))
                arrow.tintColor = .tertiaryLabel
                rowView.addSubview(arrow)
                arrow.translatesAutoresizingMaskIntoConstraints = false
                
                NSLayoutConstraint.activate([
                    arrow.trailingAnchor.constraint(equalTo: rowView.trailingAnchor, constant: -16),
                    arrow.centerYAnchor.constraint(equalTo: rowView.centerYAnchor),
                    arrow.widthAnchor.constraint(equalToConstant: 10)
                ])
            }
        } else if type == .toggle {
            let toggle = UISwitch()
            toggle.onTintColor = accentBlue
            toggle.isOn = true
            toggle.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            rowView.addSubview(toggle)
            toggle.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                toggle.trailingAnchor.constraint(equalTo: rowView.trailingAnchor, constant: -16),
                toggle.centerYAnchor.constraint(equalTo: rowView.centerYAnchor)
            ])
        } else if type == .none {
            if let subtitle = subtitle {
                let subtitleLabel = UILabel()
                subtitleLabel.text = subtitle
                subtitleLabel.font = .systemFont(ofSize: 15, weight: .regular)
                subtitleLabel.textColor = .secondaryLabel
                rowView.addSubview(subtitleLabel)
                subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
                
                NSLayoutConstraint.activate([
                    subtitleLabel.trailingAnchor.constraint(equalTo: rowView.trailingAnchor, constant: -16),
                    subtitleLabel.centerYAnchor.constraint(equalTo: rowView.centerYAnchor)
                ])
            }
        }
        
        return rowView
    }
    
    private func createDeleteAccountButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("Delete Account", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        button.backgroundColor = .secondarySystemGroupedBackground
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(handleDeleteAccount), for: .touchUpInside)
        
        button.heightAnchor.constraint(equalToConstant: 54).isActive = true
        
        return button
    }
    
    private func addSectionLabel(_ text: String) {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 11, weight: .bold)
        label.textColor = .secondaryLabel
        contentView.addArrangedSubview(label)
    }
    
    private func addInfoLabel(_ text: String) {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        contentView.addArrangedSubview(label)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    // MARK: - Actions
    
    @objc private func handleAccountTapped() {
        showAlert(title: "Account", message: "Navigate to account management")
    }
    
    @objc private func handleEditProfile() {
        showAlert(title: "Edit Profile", message: "Navigate to profile editing screen")
    }
    
    @objc private func handleChangePassword() {
        let changePasswordVC = ChangePasswordViewController()
        navigationController?.pushViewController(changePasswordVC, animated: true)
    }
    
    @objc private func handleEmailPreferences() {
        showAlert(title: "Email Preferences", message: "Manage email notification preferences")
    }
    
    @objc private func handlePrivacySettings() {
        showAlert(title: "Privacy Settings", message: "Manage privacy settings")
    }
    
    @objc private func handleTerms() {
        showAlert(title: "Terms of Service", message: "View terms of service")
    }
    
    @objc private func handlePrivacy() {
        showAlert(title: "Privacy Policy", message: "View privacy policy")
    }
    
    @objc private func handleSupport() {
        let helpVC = HelpViewController()
        navigationController?.pushViewController(helpVC, animated: true)
    }
    
    @objc private func handleDeleteAccount() {
        let alert = UIAlertController(
            title: "Delete Account",
            message: "Are you sure you want to permanently delete your account? This action cannot be undone.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.showAlert(title: "Account Deleted", message: "Your account has been deleted")
        })
        present(alert, animated: true)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
