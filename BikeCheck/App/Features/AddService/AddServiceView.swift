//
//  AddServiceView.swift
//  BikeCheck
//
//  Created by Роман Пичугин on 22.11.2026.
//

import UIKit

final class AddServiceView: UIView {
    
    //MARK: - Private Properties
    private let mileageTextField = UITextField()
    private let datePicker = UIDatePicker()
    private let mileageTitleLabel = UILabel()
    private let dateTitleLabel = UILabel()
    private let createButton = UIButton(type: .system)
    private let tapGesture = UITapGestureRecognizer()
    
    //MARK: - Callbacks
    var onMileageChange: ((String) -> Void)?
    var onDateChange: ((Date) -> Void)?
    var onCreateTapped: (() -> Void)?
    
    //MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Actions
    @objc private func tapCreateButton() {
        onCreateTapped?()
    }
    
    @objc private func mileageChanged() {
        onMileageChange?(mileageTextField.text ?? "")
    }
    
    @objc private func dateChanged() {
        onDateChange?(datePicker.date)
    }
    
    @objc private func hideKeyboard() {
        endEditing(true)
    }
    
    //MARK: - Public Methods
    func setCreateButtonEnabled(isEnabled: Bool) {
        createButton.isEnabled = isEnabled
        createButton.alpha = isEnabled ? 1 : 0.5
    }
    
    
    //MARK: - Private Methods
    private func setupUI() {
        self.backgroundColor = .bcBackground
        setupMileageTitleLabel()
        setupMileageTextField()
        setupDateTitleLabel()
        setupDatePicker()
        setupCreateButton()
        setupTapGesture()
    }
    
    private func setupMileageTitleLabel() {
        mileageTitleLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        mileageTitleLabel.textColor = .bcTextSecondary
        mileageTitleLabel.text = "Пробег".uppercased()
        mileageTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(mileageTitleLabel)
        
        NSLayoutConstraint.activate([
            mileageTitleLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 32),
            mileageTitleLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16)
        ])
    }
    
    private func setupMileageTextField() {
        mileageTextField.backgroundColor = .bcCard
        mileageTextField.layer.cornerRadius = 10
        mileageTextField.clipsToBounds = true
        mileageTextField.font = .systemFont(ofSize: 17)
        mileageTextField.textColor = .bcTextMain
        mileageTextField.attributedPlaceholder = NSAttributedString(string: "Введите пробег", attributes: [.foregroundColor: UIColor.bcTextSecondary])
        mileageTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 0))
        mileageTextField.leftViewMode = .always
        mileageTextField.keyboardType = .numberPad
        mileageTextField.tintColor = .bcAccent
        mileageTextField.autocorrectionType = .no
        mileageTextField.addTarget(self, action: #selector(mileageChanged), for: .editingChanged)
        
        mileageTextField.translatesAutoresizingMaskIntoConstraints = false
        addSubview(mileageTextField)
        
        NSLayoutConstraint.activate([
            mileageTextField.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            mileageTextField.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            mileageTextField.topAnchor.constraint(equalTo: mileageTitleLabel.bottomAnchor, constant: 8),
            mileageTextField.heightAnchor.constraint(equalToConstant: 48)
        ])
    }
    
    private func setupDateTitleLabel() {
        dateTitleLabel.font = .systemFont(ofSize: 13, weight: .semibold)
        dateTitleLabel.textColor = .bcTextSecondary
        dateTitleLabel.text = "Дата обслуживания".uppercased()
        dateTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(dateTitleLabel)
        
        NSLayoutConstraint.activate([
            dateTitleLabel.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 32),
            dateTitleLabel.topAnchor.constraint(equalTo: mileageTextField.bottomAnchor, constant: 24)
        ])
    }
    
    private func setupDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.maximumDate = Date()
        datePicker.locale = Locale(identifier: "ru_RU")
        datePicker.overrideUserInterfaceStyle = .dark
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        addSubview(datePicker)
        
        NSLayoutConstraint.activate([
            datePicker.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            datePicker.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            datePicker.topAnchor.constraint(equalTo: dateTitleLabel.bottomAnchor, constant: 8)
        ])
    }
    
    private func setupCreateButton() {
        createButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        createButton.setTitle("Сохранить", for: .normal)
        createButton.setTitleColor(.bcTextOnAccent, for: .normal)
        createButton.backgroundColor = .bcAccent
        createButton.layer.cornerRadius = 12
        createButton.clipsToBounds = true
        setCreateButtonEnabled(isEnabled: false)
        createButton.addTarget(self, action: #selector(tapCreateButton), for: .touchUpInside)
        
        createButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(createButton)
        
        NSLayoutConstraint.activate([
            createButton.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: 16),
            createButton.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -16),
            createButton.bottomAnchor.constraint(equalTo: keyboardLayoutGuide.topAnchor, constant: -8),
            createButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupTapGesture() {
        tapGesture.cancelsTouchesInView = false
        tapGesture.addTarget(self, action: #selector(hideKeyboard))
        addGestureRecognizer(tapGesture)
    }
}
