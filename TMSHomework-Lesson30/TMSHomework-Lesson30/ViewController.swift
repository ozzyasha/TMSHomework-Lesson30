//
//  ViewController.swift
//  TMSHomework-Lesson30
//
//  Created by Наталья Мазур on 22.03.24.
//

import UIKit

class ViewController: UIViewController {

    private enum Constants {
        static let gameLabelFrameWidth: CGFloat = 280
        static let gameLabelFrameHeight: CGFloat = 50
        
        static let gameDescriptionFrameWidth: CGFloat = 300
        static let gameDescriptionFrameHeight: CGFloat = 300
        
        static let guessNumberTextFieldFrameWidth: CGFloat = 300
        static let guessNumberTextFieldFrameHeight: CGFloat = 50
        
        static let checkButtonFrameWidth: CGFloat = 300
        static let checkButtonFrameHeight: CGFloat = 50
        
        static let numberOfAttemptsFrameWidth: CGFloat = 110
        static let numberOfAttemptsFrameHeight: CGFloat = 25
        
        static let guessedNumbersLabelFrameWidth: CGFloat = 300
        static let guessedNumbersLabelFrameHeight: CGFloat = 25
    }
    
    var bottomStackConstraint = NSLayoutYAxisAnchor()
    
    var randomNumber = Int(arc4random_uniform(101))
    
    var bottomStackViewConstraint = NSLayoutConstraint()
    
    private var hStackView = UIStackView()
    
    private var numberOfAttempts = 7
    private var numberOfAttemptsLabel = UILabel()
    
    private var guessedNumbersLabel = UILabel()
    
    private var gameLabel: UILabel {
        let label = UILabel()
        
        label.text = "УГАДАЙ ЧИСЛО"
        label.textColor = .white
        label.font = UIFont(name: "Swanston-Bold", size: 45)
        label.textAlignment = .center
        
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.widthAnchor.constraint(equalToConstant: Constants.gameLabelFrameWidth),
            label.heightAnchor.constraint(equalToConstant: Constants.gameLabelFrameHeight)
        ])
        
        return label
    }
    
    private var gameDescriptionTextView: UITextView {
        let textView = UITextView()
    
        textView.isEditable = false
        textView.text = ""
        let text = "Привет! Тут загадано число от 0 до 100.\n\nТвоя задача - отгадать это число, и сделать это максимум за 7 попыток.\n\nЯ скажу тебе, если число будет больше или меньше загаданного.\n\nУдачи!"
        
        var charIndex = 0.0
        for char in text {
            Timer.scheduledTimer(withTimeInterval: 0.05 * charIndex, repeats: false) { (timer) in
                textView.text?.append(char)
            }
            charIndex += 1
        }
        
        textView.backgroundColor = .black
        textView.textColor = .white
        textView.font = UIFont(name: "Swanston", size: 20)
        textView.textAlignment = .justified
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textView.widthAnchor.constraint(equalToConstant: Constants.gameDescriptionFrameWidth),
            textView.heightAnchor.constraint(equalToConstant: Constants.gameDescriptionFrameHeight)
        ])
        
        return textView
    }
    
    private var guessNumberTextField = UITextField()
    
    var checkButton: UIButton {
        let button = UIButton()
        button.backgroundColor = .white
        let buttonAttributedTitle = NSAttributedString(string: "Проверить число", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black, NSAttributedString.Key.font: UIFont(name: "Swanston", size: 25)!])
        button.setAttributedTitle(buttonAttributedTitle, for: .normal)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: Constants.checkButtonFrameWidth),
            button.heightAnchor.constraint(equalToConstant: Constants.checkButtonFrameHeight),
        ])
        
        button.addTarget(self, action: #selector(checkButtonTapped), for: .touchUpInside)
        
        return button
    }
    
    var resultLabel = UILabel()
    
    var stackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupTextField()
        setupResultLabel()
        setupNumberOfAttemptsLabel()
        setupGuessedNumbersLabel()
        setupStackView()
    }
    
    private func setupNumberOfAttemptsLabel() {
        numberOfAttemptsLabel.text = "Попыток: \(numberOfAttempts)"
        numberOfAttemptsLabel.textColor = .white
        numberOfAttemptsLabel.font = UIFont(name: "Swanston", size: 20)
        numberOfAttemptsLabel.textAlignment = .left
        
        numberOfAttemptsLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            numberOfAttemptsLabel.widthAnchor.constraint(equalToConstant: Constants.numberOfAttemptsFrameWidth),
            numberOfAttemptsLabel.heightAnchor.constraint(equalToConstant: Constants.numberOfAttemptsFrameHeight)
        ])
        
    }
    
    private func setupGuessedNumbersLabel() {
        guessedNumbersLabel.text = "Числа:"
        guessedNumbersLabel.textColor = .white
        guessedNumbersLabel.font = UIFont(name: "Swanston", size: 20)
        guessedNumbersLabel.textAlignment = .left
        
        guessedNumbersLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            guessedNumbersLabel.widthAnchor.constraint(equalToConstant: Constants.guessedNumbersLabelFrameWidth),
            guessedNumbersLabel.heightAnchor.constraint(equalToConstant: Constants.guessedNumbersLabelFrameHeight)
        ])
    }
    
    private func setupStackView() {
        hStackView.axis = .vertical
        hStackView.alignment = .leading
        hStackView.distribution = .fill
        hStackView.spacing = 10
        
        hStackView.addArrangedSubview(numberOfAttemptsLabel)
        hStackView.addArrangedSubview(guessedNumbersLabel)
        
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 20
        
        stackView.addArrangedSubview(hStackView)
        stackView.addArrangedSubview(gameLabel)
        stackView.addArrangedSubview(gameDescriptionTextView)
        stackView.addArrangedSubview(guessNumberTextField)
        stackView.addArrangedSubview(checkButton)
        stackView.addArrangedSubview(resultLabel)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        bottomStackConstraint = stackView.bottomAnchor
    }
    
    private func setupTextField() {
        guessNumberTextField.delegate = self
        guessNumberTextField.keyboardType = .numberPad
        guessNumberTextField.layer.borderWidth = 5
        guessNumberTextField.layer.borderColor = UIColor.white.cgColor
        
        guessNumberTextField.placeholder = "Введите число"
        if let placeholder = guessNumberTextField.placeholder {
            guessNumberTextField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray])
        }
        
        guessNumberTextField.font = UIFont(name: "Swanston-Bold", size: 35)
        guessNumberTextField.textAlignment = .center
        guessNumberTextField.textColor = .white
        
        guessNumberTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            guessNumberTextField.widthAnchor.constraint(equalToConstant: Constants.guessNumberTextFieldFrameWidth),
            guessNumberTextField.heightAnchor.constraint(equalToConstant: Constants.guessNumberTextFieldFrameHeight)
        ])
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardAppeared), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDisappeared), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func resetGame() {
        randomNumber = Int(arc4random_uniform(101))
        numberOfAttempts = 8
        guessedNumbersLabel.text = "Числа:"
    }
    
    private func compareRandomNumberWithInput() {
        if let inputFromTextField = Int(guessNumberTextField.text!) {
            
            guessedNumbersLabel.text! += " \(inputFromTextField)"
            
            if inputFromTextField < randomNumber {
                resultLabel.text = "Число \(inputFromTextField) меньше загаданного"
                guessNumberTextField.text = ""
            } else if inputFromTextField > randomNumber {
                resultLabel.text = "Число \(inputFromTextField) больше загаданного"
                guessNumberTextField.text = ""
            } else if inputFromTextField == randomNumber {
                resultLabel.text = "Вы отгадали число. Это \(randomNumber).\nЗагадываю новое число."
                guessNumberTextField.text = ""
                resetGame()
            }
            
            numberOfAttempts -= 1
            numberOfAttemptsLabel.text = "Попыток: \(numberOfAttempts)"
            
            if numberOfAttempts < 1 {
                resultLabel.text = "Попытки закончились!\nЗагадываю новое число."
                resetGame()
            }
            
        }
        
    }
    
    private func setupResultLabel() {
        resultLabel.text = ""
        resultLabel.font = UIFont(name: "Swanston", size: 20)
        resultLabel.textColor = .white
        resultLabel.textAlignment = .center
        resultLabel.numberOfLines = 2
        
        resultLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            resultLabel.widthAnchor.constraint(equalToConstant: Constants.gameLabelFrameWidth),
            resultLabel.heightAnchor.constraint(equalToConstant: Constants.gameLabelFrameHeight)
        ])
    }
    
    @objc func checkButtonTapped() {
        guessNumberTextField.resignFirstResponder()
        compareRandomNumberWithInput()
    }
    
    @objc func keyboardAppeared(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            
            
            bottomStackViewConstraint.isActive = false
            bottomStackViewConstraint = stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -keyboardHeight-20)
            bottomStackViewConstraint.isActive = true
        }
    }
    
    @objc func keyboardDisappeared(_ notification: Notification) {
        bottomStackViewConstraint.isActive = false
        bottomStackViewConstraint = stackView.bottomAnchor.constraint(equalTo: bottomStackConstraint)
        bottomStackViewConstraint.isActive = true
    }
    
}

extension ViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text as NSString? else {
            return false
        }
        
        let newText = text.replacingCharacters(in: range, with: string)
        if let number = Int(newText), number >= 0, number <= 100 {
            return true
        } else if newText.isEmpty {
            return true
        } else {
            return false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        compareRandomNumberWithInput()
        return true
    }

}

//Создайте проект, который будет имитировать любую мини-игру, например, угадай число.
//Используя UserDefaults, сохраняйте и загружайте игровое состояние, такое как количество очков, уровень и так далее.
