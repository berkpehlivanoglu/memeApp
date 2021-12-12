//
//  HomeView.swift
//  MemeMe
//
//  Created by BerkPehlivanoğlu on 15.11.2021.
//

import UIKit

final class HomeView: UIView & Layoutable {
    
    //MARK: - Properties
    lazy var chooseFromPhotosButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "photo", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30)), for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    lazy var chooseCameraButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "camera", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30)), for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    lazy var shareButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "square.and.arrow.up", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30)), for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    
    lazy var imagePickerView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor: UIColor.white,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth: -3.0
    ]
    
    lazy var topTextField: UITextField = {
        let textField = UITextField()
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        return textField
    }()
    
    lazy var bottomTextField: UITextField = {
        let textField = UITextField()
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center
        return textField
    }()
    
    lazy var topStackView: UIStackView = {
        let view = UIStackView()
        view.backgroundColor = .gray
        view.addSubview(shareButton)
        view.addSubview(cancelButton)
        return view
    }()
    
    lazy var bottomStackView: UIStackView = {
        let view = UIStackView()
        view.backgroundColor = .gray
        view.addSubview(chooseFromPhotosButton)
        view.addSubview(chooseCameraButton)
        return view
    }()
    //MARK: - Setups
    func setupViews() {
        self.backgroundColor = .black
        
        addSubview(topStackView)
        addSubview(imagePickerView)
        addSubview(topTextField)
        addSubview(bottomTextField)
        addSubview(bottomStackView)
    }
    
    func setupLayout() {
        
        topStackView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        
        shareButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(preferredSpacing)
            make.top.equalToSuperview().inset(preferredSpacing / 1.8)
        }
        
        cancelButton.snp.makeConstraints { make in
            make.centerY.equalTo(shareButton.snp.centerY)
            make.trailing.equalToSuperview().inset(preferredSpacing)
        }
        
        bottomStackView.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        
        chooseFromPhotosButton.snp.makeConstraints { make in
            make.centerY.equalTo(bottomStackView.snp.centerY)
            make.leading.equalToSuperview().inset(preferredSpacing * 6)
            
        }
        
        chooseCameraButton.snp.makeConstraints { make in
            make.centerY.equalTo(bottomStackView.snp.centerY)
            make.trailing.equalToSuperview().inset(preferredSpacing * 6)
        }
        
        imagePickerView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.top.equalTo(topStackView.snp.bottom)
            make.bottom.equalTo(bottomStackView.snp.top)
        }
        
        topTextField.snp.makeConstraints { make in
            make.top.equalTo(imagePickerView.snp.top).inset(preferredSpacing)
            make.width.equalTo(preferredSpacing * 10)
            make.centerX.equalToSuperview()
        }
        
        bottomTextField.snp.makeConstraints { make in
            make.bottom.equalTo(imagePickerView.snp.bottom).inset(preferredSpacing)
            make.width.equalTo(preferredSpacing * 10)
            make.centerX.equalToSuperview()
        }
    }
}




