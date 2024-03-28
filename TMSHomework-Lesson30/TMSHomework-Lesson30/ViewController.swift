//
//  ViewController.swift
//  TMSHomework-Lesson30
//
//  Created by Наталья Мазур on 22.03.24.
//

import UIKit

class ViewController: UIViewController {
    var randomNumber = Int.random(in: 0..<101)
    
    var bottomStackViewYAxisAnchor = NSLayoutYAxisAnchor()
    var bottomStackViewConstraint = NSLayoutConstraint()
    
    private enum Constants {
        static let numberOfAttemptsFrameWidth: CGFloat = 110
        static let guessedNumbersLabelFrameWidth: CGFloat = 300
        static let gameLabelFrameWidth: CGFloat = 280
        static let gameDescriptionFrameWidth: CGFloat = 300
        
        static let guessNumberTextFieldFrameWidth: CGFloat = 300
        static let guessNumberTextFieldFrameHeight: CGFloat = 50
        
        static let checkButtonFrameWidth: CGFloat = 300
        static let checkButtonFrameHeight: CGFloat = 50
        
        static let resultLabelWidth: CGFloat = 300
    }
    
    private var numberOfAttempts: Int = 7
    
    // MARK: - UI
    private var numberOfAttemptsLabel = UILabel()
    private var guessedNumbersLabel = UILabel()
    private var leadingAlignmentStackView = UIStackView()
    
    private var gameLabel: UILabel {
        let label = UILabel()
        
        label.text = "УГАДАЙ ЧИСЛО"
        label.textColor = .white
        label.font = UIFont(name: "Swanston-Bold", size: 45)
        label.textAlignment = .center
        
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.widthAnchor.constraint(equalToConstant: Constants.gameLabelFrameWidth),
        ])
        
        return label
    }
    
    private var gameDescriptionTextView = UITextView()
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
    
    let userDefaults = UserDefaults.standard
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupNumberOfAttemptsLabel()
        setupGuessedNumbersLabel()
        setupTextView()
        setupTextField()
        setupResultLabel()
        setupStackView()
        loadFromUserDefaults()
    }
    
    // MARK: - Setup views
    private func setupNumberOfAttemptsLabel() {
        numberOfAttemptsLabel.text = "Попыток: \(numberOfAttempts)"
        numberOfAttemptsLabel.textColor = .white
        numberOfAttemptsLabel.font = UIFont(name: "Swanston", size: 20)
        numberOfAttemptsLabel.textAlignment = .left
        
        numberOfAttemptsLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            numberOfAttemptsLabel.widthAnchor.constraint(equalToConstant: Constants.numberOfAttemptsFrameWidth),
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
        ])
    }
    
    private func setupTextView() {
        gameDescriptionTextView.isEditable = false
        gameDescriptionTextView.text = ""
        let text = "Привет! Тут загадано число от 0 до 100.\n\nТвоя задача - отгадать это число, и сделать это максимум за 7 попыток.\n\nЯ скажу тебе, если число будет больше или меньше загаданного.\n\nУдачи!"
        
        var charIndex = 0.0
        for char in text {
            Timer.scheduledTimer(withTimeInterval: 0.05 * charIndex, repeats: false) { (timer) in
                self.gameDescriptionTextView.text?.append(char)
            }
            charIndex += 1
        }
        
        gameDescriptionTextView.backgroundColor = .black
        gameDescriptionTextView.textColor = .white
        gameDescriptionTextView.font = UIFont(name: "Swanston", size: 20)
        gameDescriptionTextView.textAlignment = .justified
        
        gameDescriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            gameDescriptionTextView.widthAnchor.constraint(equalToConstant: Constants.gameDescriptionFrameWidth),
        ])
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
    
    private func setupResultLabel() {
        resultLabel.text = ""
        resultLabel.font = UIFont(name: "Swanston", size: 20)
        resultLabel.textColor = .white
        resultLabel.textAlignment = .center
        resultLabel.numberOfLines = 3
        
        resultLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            resultLabel.widthAnchor.constraint(equalToConstant: Constants.resultLabelWidth)
        ])
    }
    
    private func setupStackView() {
        leadingAlignmentStackView.axis = .vertical
        leadingAlignmentStackView.alignment = .leading
        leadingAlignmentStackView.distribution = .fill
        leadingAlignmentStackView.spacing = 10
        
        leadingAlignmentStackView.addArrangedSubview(numberOfAttemptsLabel)
        leadingAlignmentStackView.addArrangedSubview(guessedNumbersLabel)
        
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 20
        
        stackView.addArrangedSubview(leadingAlignmentStackView)
        stackView.addArrangedSubview(gameLabel)
        stackView.addArrangedSubview(gameDescriptionTextView)
        stackView.addArrangedSubview(guessNumberTextField)
        stackView.addArrangedSubview(checkButton)
        stackView.addArrangedSubview(resultLabel)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(stackView)
        
        bottomStackViewConstraint = stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bottomStackViewConstraint
        ])
        
        bottomStackViewYAxisAnchor = stackView.bottomAnchor
    }
    
    // MARK: - Core Methods
    private func saveToUserDefaults() {
        userDefaults.setValue(numberOfAttemptsLabel.text, forKey: .numberOfAttemptsLabelText)
        userDefaults.setValue(numberOfAttempts, forKey: .numberOfAttempts)
        userDefaults.setValue(guessedNumbersLabel.text, forKey: .guessedNumbers)
        userDefaults.setValue(randomNumber, forKey: .randomNumber)
        userDefaults.setValue(resultLabel.text, forKey: .resultLabelText)
    }
    
    private func loadFromUserDefaults() {
        if let numberOfAttemptsLabelTextUD = userDefaults.value(forKey: .numberOfAttemptsLabelText) {
            numberOfAttemptsLabel.text = numberOfAttemptsLabelTextUD as? String
        }
        
        if let numberOfAttemptsUD = userDefaults.value(forKey: .numberOfAttempts) as? Int {
            numberOfAttempts = numberOfAttemptsUD
        }
        
        if let guessedNumbersUD = userDefaults.value(forKey: .guessedNumbers) {
            guessedNumbersLabel.text = guessedNumbersUD as? String
        }
        
        if let randomNumberUD = userDefaults.value(forKey: .randomNumber) as? Int {
            randomNumber = randomNumberUD
        }
        
        if let resultLabelTextUD = userDefaults.value(forKey: .resultLabelText) {
            resultLabel.text = resultLabelTextUD as? String
        }
    }
    
    private func resetGame() {
        randomNumber = Int.random(in: 0..<101)
        numberOfAttempts = 7
        guessedNumbersLabel.text = "Числа:"
        numberOfAttemptsLabel.text = "Попыток: \(numberOfAttempts)"
    }
    
    private func compareRandomNumberWithInput() {
        if let inputFromTextField = Int(guessNumberTextField.text!) {
            if guessedNumbersLabel.text != "Числа:" {
                guessedNumbersLabel.text! += ","
            }
            guessedNumbersLabel.text! += " \(inputFromTextField)"
            
            if inputFromTextField < randomNumber {
                resultLabel.text = "Число \(inputFromTextField) меньше загаданного"
                guessNumberTextField.text = ""
                
                numberOfAttempts -= 1
                numberOfAttemptsLabel.text = "Попыток: \(numberOfAttempts)"
            } else if inputFromTextField > randomNumber {
                resultLabel.text = "Число \(inputFromTextField) больше загаданного"
                guessNumberTextField.text = ""
                
                numberOfAttempts -= 1
                numberOfAttemptsLabel.text = "Попыток: \(numberOfAttempts)"
            } else if inputFromTextField == randomNumber {
                resultLabel.text = "Вы отгадали число. Это \(randomNumber)\nЗагадываю новое число"
                guessNumberTextField.text = ""
                resetGame()
            }
            
            if numberOfAttempts < 1 {
                resultLabel.text = "Попытки закончились!\nЭто было число \(randomNumber)\nЗагадываю новое число"
                resetGame()
            }
        }
    }
    
    @objc func checkButtonTapped() {
        guessNumberTextField.resignFirstResponder()
        compareRandomNumberWithInput()
        saveToUserDefaults()
    }
    
    @objc func keyboardAppeared(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            
            bottomStackViewConstraint.isActive = false
            bottomStackViewConstraint = stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -keyboardHeight-20)
            bottomStackViewConstraint.isActive = true
            
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardDisappeared(_ notification: Notification) {
        bottomStackViewConstraint.isActive = false
        bottomStackViewConstraint = stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40)
        bottomStackViewConstraint.isActive = true
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
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
        saveToUserDefaults()
        return true
    }
}
