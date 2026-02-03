//
//  EditProfileViewController.swift
//  Insiderfinal
//
//  Created by user@1 on 01/02/26.
//

import UIKit
import PhotosUI
internal import Auth
import Supabase

class EditProfileViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    private let contentView = UIStackView()
    private let loadingIndicator = UIActivityIndicatorView(style: .medium)
    
    private var selectedImage: UIImage?
    private var currentUser: User?
    
    // MARK: - UI Components
    
    private let profileImageContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "person.circle.fill")
        iv.tintColor = .systemGray4
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 60
        iv.clipsToBounds = true
        iv.layer.borderWidth = 3
        iv.layer.borderColor = UIColor.systemBlue.cgColor
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let changePhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Change Photo", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let removePhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Remove Photo", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .regular)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // Full Name Section
    private let fullNameLabel: UILabel = {
        let label = UILabel()
        label.text = "FULL NAME"
        label.font = .systemFont(ofSize: 11, weight: .bold)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let fullNameContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemGroupedBackground
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let fullNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter your full name"
        textField.font = .systemFont(ofSize: 16, weight: .regular)
        textField.textColor = .label
        textField.autocorrectionType = .no
        textField.returnKeyType = .done
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    // Bio Section
    private let bioLabel: UILabel = {
        let label = UILabel()
        label.text = "ABOUT"
        label.font = .systemFont(ofSize: 11, weight: .bold)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let bioContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemGroupedBackground
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let bioTextView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 16, weight: .regular)
        textView.textColor = .label
        textView.backgroundColor = .clear
        textView.textContainerInset = UIEdgeInsets(top: 14, left: 12, bottom: 14, right: 12)
        textView.isScrollEnabled = false
        textView.returnKeyType = .default
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private let bioPlaceholderLabel: UILabel = {
        let label = UILabel()
        label.text = "iOS Developer | Tech Enthusiast | Love building amazing apps"
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .placeholderText
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let characterCountLabel: UILabel = {
        let label = UILabel()
        label.text = "0/150"
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Email Section (Read-only)
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "EMAIL"
        label.font = .systemFont(ofSize: 11, weight: .bold)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emailContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemGroupedBackground
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let emailValueLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emailLockIcon: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "lock.fill"))
        iv.tintColor = .tertiaryLabel
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        setupActions()
        setupKeyboardHandling()
        loadUserData()
    }
    
    // MARK: - Setup
    
    private func setupNavigationBar() {
        title = "Edit Profile"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Cancel",
            style: .plain,
            target: self,
            action: #selector(cancelTapped)
        )
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Save",
            style: .done,
            target: self,
            action: #selector(saveTapped)
        )
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .black
        appearance.titleTextAttributes = [
            .foregroundColor: UIColor.label,
            .font: UIFont.systemFont(ofSize: 17, weight: .semibold)
        ]
        
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = .systemBlue
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
        
        // Profile Image Section
        profileImageContainer.addSubview(profileImageView)
        profileImageContainer.addSubview(changePhotoButton)
        profileImageContainer.addSubview(removePhotoButton)
        contentView.addArrangedSubview(profileImageContainer)
        
        // Full Name Section
        contentView.addArrangedSubview(fullNameLabel)
        fullNameContainer.addSubview(fullNameTextField)
        contentView.addArrangedSubview(fullNameContainer)
        
        // Bio Section
        contentView.addArrangedSubview(bioLabel)
        bioContainer.addSubview(bioTextView)
        bioContainer.addSubview(bioPlaceholderLabel)
        bioContainer.addSubview(characterCountLabel)
        contentView.addArrangedSubview(bioContainer)
        
        // Email Section
        contentView.addArrangedSubview(emailLabel)
        emailContainer.addSubview(emailValueLabel)
        emailContainer.addSubview(emailLockIcon)
        contentView.addArrangedSubview(emailContainer)
        
        // Loading Indicator
        loadingIndicator.hidesWhenStopped = true
        view.addSubview(loadingIndicator)
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        setupConstraints()
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
            
            // Profile Image
            profileImageContainer.heightAnchor.constraint(equalToConstant: 200),
            
            profileImageView.centerXAnchor.constraint(equalTo: profileImageContainer.centerXAnchor),
            profileImageView.topAnchor.constraint(equalTo: profileImageContainer.topAnchor, constant: 20),
            profileImageView.widthAnchor.constraint(equalToConstant: 120),
            profileImageView.heightAnchor.constraint(equalToConstant: 120),
            
            changePhotoButton.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 16),
            changePhotoButton.centerXAnchor.constraint(equalTo: profileImageContainer.centerXAnchor),
            
            removePhotoButton.topAnchor.constraint(equalTo: changePhotoButton.bottomAnchor, constant: 8),
            removePhotoButton.centerXAnchor.constraint(equalTo: profileImageContainer.centerXAnchor),
            
            // Full Name
            fullNameContainer.heightAnchor.constraint(equalToConstant: 50),
            
            fullNameTextField.leadingAnchor.constraint(equalTo: fullNameContainer.leadingAnchor, constant: 16),
            fullNameTextField.trailingAnchor.constraint(equalTo: fullNameContainer.trailingAnchor, constant: -16),
            fullNameTextField.centerYAnchor.constraint(equalTo: fullNameContainer.centerYAnchor),
            
            // Bio
            bioContainer.heightAnchor.constraint(greaterThanOrEqualToConstant: 100),
            
            bioTextView.topAnchor.constraint(equalTo: bioContainer.topAnchor),
            bioTextView.leadingAnchor.constraint(equalTo: bioContainer.leadingAnchor),
            bioTextView.trailingAnchor.constraint(equalTo: bioContainer.trailingAnchor),
            bioTextView.bottomAnchor.constraint(equalTo: characterCountLabel.topAnchor, constant: -8),
            
            bioPlaceholderLabel.topAnchor.constraint(equalTo: bioTextView.topAnchor, constant: 14),
            bioPlaceholderLabel.leadingAnchor.constraint(equalTo: bioTextView.leadingAnchor, constant: 16),
            bioPlaceholderLabel.trailingAnchor.constraint(equalTo: bioTextView.trailingAnchor, constant: -16),
            
            characterCountLabel.trailingAnchor.constraint(equalTo: bioContainer.trailingAnchor, constant: -16),
            characterCountLabel.bottomAnchor.constraint(equalTo: bioContainer.bottomAnchor, constant: -12),
            
            // Email
            emailContainer.heightAnchor.constraint(equalToConstant: 50),
            
            emailValueLabel.leadingAnchor.constraint(equalTo: emailContainer.leadingAnchor, constant: 16),
            emailValueLabel.centerYAnchor.constraint(equalTo: emailContainer.centerYAnchor),
            
            emailLockIcon.trailingAnchor.constraint(equalTo: emailContainer.trailingAnchor, constant: -16),
            emailLockIcon.centerYAnchor.constraint(equalTo: emailContainer.centerYAnchor),
            emailLockIcon.widthAnchor.constraint(equalToConstant: 16),
            emailLockIcon.heightAnchor.constraint(equalToConstant: 16),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func setupActions() {
        changePhotoButton.addTarget(self, action: #selector(changePhotoTapped), for: .touchUpInside)
        removePhotoButton.addTarget(self, action: #selector(removePhotoTapped), for: .touchUpInside)
        
        bioTextView.delegate = self
        fullNameTextField.delegate = self
    }
    
    private func setupKeyboardHandling() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        scrollView.contentInset.bottom = keyboardFrame.height
        scrollView.verticalScrollIndicatorInsets.bottom = keyboardFrame.height
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset.bottom = 0
        scrollView.verticalScrollIndicatorInsets.bottom = 0
    }
    
    // MARK: - Data Loading
    
    private func loadUserData() {
        loadingIndicator.startAnimating()
        
        Task {
            do {
                if let user = try await SupabaseManager.shared.getCurrentUser() {
                    currentUser = user
                    
                    await MainActor.run {
                        let metadata = user.userMetadata
                        let fullName = metadata["full_name"]?.description.replacingOccurrences(of: "\"", with: "") ?? ""
                        let bio = metadata["bio"]?.description.replacingOccurrences(of: "\"", with: "") ?? ""
                        
                        fullNameTextField.text = fullName
                        bioTextView.text = bio
                        bioPlaceholderLabel.isHidden = !bio.isEmpty
                        updateCharacterCount()
                        
                        emailValueLabel.text = user.email
                        
                        loadingIndicator.stopAnimating()
                    }
                }
            } catch {
                await MainActor.run {
                    loadingIndicator.stopAnimating()
                    showAlert(title: "Error", message: "Failed to load user data")
                }
            }
        }
    }
    
    // MARK: - Actions
    
    @objc private func cancelTapped() {
        if hasUnsavedChanges() {
            let alert = UIAlertController(
                title: "Discard Changes?",
                message: "You have unsaved changes. Are you sure you want to discard them?",
                preferredStyle: .alert
            )
            alert.addAction(UIAlertAction(title: "Keep Editing", style: .cancel))
            alert.addAction(UIAlertAction(title: "Discard", style: .destructive) { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            })
            present(alert, animated: true)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @objc private func saveTapped() {
        guard validateInputs() else { return }
        
        let fullName = fullNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let bio = bioTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        loadingIndicator.startAnimating()
        navigationItem.rightBarButtonItem?.isEnabled = false
        view.isUserInteractionEnabled = false
        
        Task {
            do {
                // Update user metadata in Supabase
                try await updateUserProfile(fullName: fullName, bio: bio)
                
                await MainActor.run {
                    loadingIndicator.stopAnimating()
                    navigationItem.rightBarButtonItem?.isEnabled = true
                    view.isUserInteractionEnabled = true
                    
                    // Show success and pop
                    let alert = UIAlertController(
                        title: "Success",
                        message: "Your profile has been updated",
                        preferredStyle: .alert
                    )
                    alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
                        self?.navigationController?.popViewController(animated: true)
                    })
                    present(alert, animated: true)
                }
            } catch {
                await MainActor.run {
                    loadingIndicator.stopAnimating()
                    navigationItem.rightBarButtonItem?.isEnabled = true
                    view.isUserInteractionEnabled = true
                    
                    showAlert(title: "Error", message: "Failed to update profile. Please try again.")
                }
            }
        }
    }
    
    private func updateUserProfile(fullName: String, bio: String) async throws {
        // Update user metadata
        try await SupabaseManager.shared.client.auth.update(
            user: UserAttributes(
                data: [
                    "full_name": .string(fullName),
                    "bio": .string(bio)
                ]
            )
        )
    }
    
    @objc private func changePhotoTapped() {
        var configuration = PHPickerConfiguration()
        configuration.filter = .images
        configuration.selectionLimit = 1
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @objc private func removePhotoTapped() {
        let alert = UIAlertController(
            title: "Remove Photo",
            message: "Are you sure you want to remove your profile photo?",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Remove", style: .destructive) { [weak self] _ in
            self?.profileImageView.image = UIImage(systemName: "person.circle.fill")
            self?.profileImageView.tintColor = .systemGray4
            self?.selectedImage = nil
        })
        present(alert, animated: true)
    }
    
    // MARK: - Validation
    
    private func validateInputs() -> Bool {
        let fullName = fullNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        if fullName.isEmpty {
            showAlert(title: "Error", message: "Please enter your full name")
            return false
        }
        
        if fullName.count < 2 {
            showAlert(title: "Error", message: "Full name must be at least 2 characters")
            return false
        }
        
        return true
    }
    
    private func hasUnsavedChanges() -> Bool {
        guard let user = currentUser else { return false }
        
        let metadata = user.userMetadata
        let currentFullName = metadata["full_name"]?.description.replacingOccurrences(of: "\"", with: "") ?? ""
        let currentBio = metadata["bio"]?.description.replacingOccurrences(of: "\"", with: "") ?? ""
        
        let newFullName = fullNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let newBio = bioTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        return currentFullName != newFullName || currentBio != newBio || selectedImage != nil
    }
    
    private func updateCharacterCount() {
        let count = bioTextView.text.count
        characterCountLabel.text = "\(count)/150"
        characterCountLabel.textColor = count > 150 ? .systemRed : .secondaryLabel
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: - UITextViewDelegate
extension EditProfileViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        bioPlaceholderLabel.isHidden = !textView.text.isEmpty
        updateCharacterCount()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: text)
        
        return updatedText.count <= 150
    }
}

// MARK: - UITextFieldDelegate
extension EditProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - PHPickerViewControllerDelegate
extension EditProfileViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        guard let result = results.first else { return }
        
        if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                DispatchQueue.main.async {
                    if let image = image as? UIImage {
                        self?.profileImageView.image = image
                        self?.profileImageView.tintColor = nil
                        self?.selectedImage = image
                    }
                }
            }
        }
    }
}
