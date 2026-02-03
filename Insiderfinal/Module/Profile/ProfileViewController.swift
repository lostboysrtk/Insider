import UIKit
internal import Auth

class ProfileViewController: UIViewController {

    private let scrollView = UIScrollView()
    private let contentView = UIStackView()
    private let loadingIndicator = UIActivityIndicatorView(style: .medium)
    
    private let headerView = ProfileHeaderView()
    private let statsView = ProfileStatsView()
    
    private let accentBlue = UIColor(red: 0.05, green: 0.45, blue: 0.95, alpha: 1.0)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Changed to .always to allow scrolling under navigation bar while keeping it visible
        scrollView.contentInsetAdjustmentBehavior = .always
        setupUI()
        // Set parent view controller for navigation
        headerView.parentViewController = self
        loadUserData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
        // Reload user data when returning from edit screen
        loadUserData()
    }
    
    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .black
        
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.label,
            .font: UIFont.systemFont(ofSize: 15, weight: .semibold)
        ]
        
        // Set all appearances to the same configuration to prevent hiding on scroll
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.compactScrollEdgeAppearance = appearance
        
        navigationController?.navigationBar.tintColor = .label
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.title = "Profile"
    }

    private func loadUserData() {
        Task {
            do {
                if let user = try await SupabaseManager.shared.getCurrentUser() {
                    await MainActor.run {
                        let metadata = user.userMetadata
                        let fullName = metadata["full_name"]?.description.replacingOccurrences(of: "\"", with: "") ?? "User"
                        let email = user.email ?? ""
                        let bio = metadata["bio"]?.description.replacingOccurrences(of: "\"", with: "")
                        headerView.configure(name: fullName, email: email, bio: bio)
                    }
                }
            } catch {
                print("Error loading user data: \(error)")
            }
        }
    }

    @objc private func handleSavedLibraryTap() {
        let libraryVC = InsiderSavedLibraryController()
        self.navigationController?.pushViewController(libraryVC, animated: true)
    }
    
    @objc private func handleAccountSettingsTap() {
        let settingsVC = AccountSettingsViewController()
        let navController = UINavigationController(rootViewController: settingsVC)
        navController.modalPresentationStyle = .pageSheet
        present(navController, animated: true)
    }
    
    @objc private func handleSignOutTap() {
        let alert = UIAlertController(title: "Sign Out", message: "Are you sure?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Sign Out", style: .destructive) { [weak self] _ in
            self?.performSignOut()
        })
        present(alert, animated: true)
    }
    
    private func performSignOut() {
        showLoadingIndicator()
        Task {
            do {
                try await SupabaseManager.shared.signOut()
                await MainActor.run {
                    hideLoadingIndicator()
                    navigateToSignIn()
                }
            } catch {
                await MainActor.run {
                    hideLoadingIndicator()
                    showErrorAlert(message: "Failed to sign out.")
                }
            }
        }
    }
    
    private func navigateToSignIn() {
        guard let window = view.window else { return }
        let signInVC = SignInViewController()
        signInVC.modalPresentationStyle = .fullScreen
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve) {
            window.rootViewController = signInVC
            window.makeKeyAndVisible()
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .black
        
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.axis = .vertical
        contentView.spacing = 16
        // Adjusted top margin since navigation bar will now be opaque
        contentView.layoutMargins = UIEdgeInsets(top: 20, left: 16, bottom: 40, right: 16)
        contentView.isLayoutMarginsRelativeArrangement = true
        
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addArrangedSubview(headerView)
        contentView.addArrangedSubview(statsView)
        
        addSectionLabel("PREFERENCES")
        contentView.addArrangedSubview(createGroupedCard(items: [
            (icon: "sparkles", title: "Personalize Feed", color: .systemPurple, type: .arrow, action: nil),
            (icon: "bell.fill", title: "Daily Drop Alerts", color: .systemPink, type: .toggle, action: nil)
        ]))
        
        addSectionLabel("ACCOUNT")
        contentView.addArrangedSubview(createGroupedCard(items: [
            (icon: "bookmark.fill", title: "Saved Library", color: accentBlue, type: .arrow, action: #selector(handleSavedLibraryTap)),
            (icon: "gearshape.fill", title: "Account Settings", color: .systemGray, type: .arrow, action: #selector(handleAccountSettingsTap)),
            (icon: "rectangle.portrait.and.arrow.right", title: "Sign Out", color: .systemRed, type: .arrow, action: #selector(handleSignOutTap))
        ]))
        
        loadingIndicator.hidesWhenStopped = true
        view.addSubview(loadingIndicator)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        setupConstraints()
    }

    private func createGroupedCard(items: [(icon: String, title: String, color: UIColor, type: RowType, action: Selector?)]) -> UIView {
        let container = UIView()
        container.backgroundColor = .secondarySystemGroupedBackground
        container.layer.cornerRadius = 24
        let stack = UIStackView()
        stack.axis = .vertical
        container.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: container.topAnchor, constant: 6),
            stack.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            stack.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -6)
        ])
        for (index, item) in items.enumerated() {
            let row = createRow(icon: item.icon, title: item.title, color: item.color, type: item.type, action: item.action)
            stack.addArrangedSubview(row)
            if index < items.count - 1 {
                let divider = UIView()
                divider.backgroundColor = .separator
                stack.addArrangedSubview(divider)
                divider.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
            }
        }
        return container
    }

    enum RowType { case arrow, toggle }
    
    private func createRow(icon: String, title: String, color: UIColor, type: RowType, action: Selector?) -> UIView {
        let rowView = UIView()
        rowView.heightAnchor.constraint(equalToConstant: 54).isActive = true
        if let action = action {
            rowView.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: action)
            rowView.addGestureRecognizer(tap)
        }
        let iconView = UIImageView(image: UIImage(systemName: icon))
        iconView.tintColor = color
        iconView.contentMode = .scaleAspectFit
        let label = UILabel()
        label.text = title
        label.font = .systemFont(ofSize: 15, weight: .semibold)
        label.textColor = (title == "Sign Out") ? .systemRed : .label
        [iconView, label].forEach {
            rowView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            iconView.leadingAnchor.constraint(equalTo: rowView.leadingAnchor, constant: 16),
            iconView.centerYAnchor.constraint(equalTo: rowView.centerYAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 20),
            label.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 14),
            label.centerYAnchor.constraint(equalTo: rowView.centerYAnchor)
        ])
        if type == .arrow {
            let arrow = UIImageView(image: UIImage(systemName: "chevron.right"))
            arrow.tintColor = .tertiaryLabel
            rowView.addSubview(arrow)
            arrow.translatesAutoresizingMaskIntoConstraints = false
            arrow.trailingAnchor.constraint(equalTo: rowView.trailingAnchor, constant: -16).isActive = true
            arrow.centerYAnchor.constraint(equalTo: rowView.centerYAnchor).isActive = true
            arrow.widthAnchor.constraint(equalToConstant: 10).isActive = true
        } else if type == .toggle {
            let toggle = UISwitch()
            toggle.onTintColor = accentBlue
            toggle.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            rowView.addSubview(toggle)
            toggle.translatesAutoresizingMaskIntoConstraints = false
            toggle.trailingAnchor.constraint(equalTo: rowView.trailingAnchor, constant: -16).isActive = true
            toggle.centerYAnchor.constraint(equalTo: rowView.centerYAnchor).isActive = true
        }
        return rowView
    }

    private func addSectionLabel(_ text: String) {
        let label = UILabel()
        label.text = "  " + text
        label.font = .systemFont(ofSize: 10, weight: .black)
        label.textColor = .secondaryLabel
        contentView.addArrangedSubview(label)
    }

    private func showLoadingIndicator() { loadingIndicator.startAnimating(); view.isUserInteractionEnabled = false }
    private func hideLoadingIndicator() { loadingIndicator.stopAnimating(); view.isUserInteractionEnabled = true }
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
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
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
