//
//  AddServiceViewController.swift
//  BikeCheck
//
//  Created by Роман Пичугин on 23.11.2026.
//

import UIKit

final class AddServiceViewController: UIViewController {
    
    //MARK: - Private Properties
    private let addServiceView = AddServiceView()
    private let viewModel: AddServiceViewModel
    
    //MARK: - Callbacks
    var onServiceCreated: (() -> Void)?
    
    //MARK: - Initializers
    init(viewModel: AddServiceViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Override Methods
    override func loadView() {
        view = addServiceView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        bind()
    }
    
    //MARK: - Actions
    @objc private func tapCancelOnNavBar() {
        dismiss(animated: true)
    }
    
    //MARK: - Private Methods
    private func bind() {
        addServiceView.onCreateTapped = { [weak self] in
            self?.viewModel.create()
        }
        
        addServiceView.onDateChange = { [weak self] date in
            self?.viewModel.doneAt = date
        }
        
        addServiceView.onMileageChange = { [weak self] mileage in
            self?.viewModel.mileageText = mileage
        }
        
        addServiceView.onNoteChange = { [weak self] text in
            self?.viewModel.noteText = text
        }
        
        viewModel.onCreated = { [weak self] in
            self?.onServiceCreated?()
        }
        
        viewModel.onLoading = { isLoading in
            //TODO: - спинер
        }
        
        viewModel.onSaveEnabledChange = { [weak self] isEnabled in
            self?.addServiceView.setCreateButtonEnabled(isEnabled: isEnabled)
        }
        
        viewModel.onError = { [weak self] message in
            let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "ОК", style: .cancel)
            alert.addAction(action)
            self?.present(alert, animated: true)
        }
    }
    
    private func setupNavigationBar() {
        title = "Новое обслуживание"
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Отмена",
            style: .plain,
            target: self,
            action: #selector(tapCancelOnNavBar)
        )
    }
}
