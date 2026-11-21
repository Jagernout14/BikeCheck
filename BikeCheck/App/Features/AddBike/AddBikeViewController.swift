//
//  AddBikeViewController.swift
//  BikeCheck
//
//  Created by Роман Пичугин on 21.11.2026.
//

import UIKit

final class AddBikeViewController: UIViewController {
    
    //MARK: - Private Properties
    private let viewModel: AddBikeViewModel
    private let addBikeView = AddBikeView()
    
    //MARK: - Callbacks
    var onBikeCreated: ((Int) -> Void)?
    
    //MARK: - Initializers
    init(viewModel: AddBikeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Override Methods
    override func loadView() {
        view = addBikeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        bind()
    }
    
    //MARK: - Actions
    @objc private func tapCancelButton() {
        dismiss(animated: true)
    }
    
    //MARK: - Private Methods
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Отмена",
            style: .plain,
            target: self,
            action: #selector(tapCancelButton)
        )
        title = "Новый велосипед"
        navigationItem.largeTitleDisplayMode = .never
    }
    
    private func bind() {
        addBikeView.onCreateTapped = { [weak self] in
            self?.viewModel.create()
        }
        
        addBikeView.onNameChange = { [weak self] text in
            self?.viewModel.newBikeName = text
        }
        
        viewModel.onError = { [weak self] message in
            let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel)
            alert.addAction(action)
            self?.present(alert, animated: true)
        }
        
        viewModel.onLoading = { isLoading in
            //TODO: - добавить тут спиннер
            print("Loading: \(isLoading)")
        }
        
        viewModel.onCreated = { [weak self] newBikeId in
            self?.onBikeCreated?(newBikeId)
        }
        
        viewModel.onSaveEnabledChange = { [weak self] isEnabled in
            self?.addBikeView.setCreateButtonEnabled(isEnabled: isEnabled)
        }
    }
}
