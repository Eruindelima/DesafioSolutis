


//teste@test.com.br
//abc123@

import UIKit
import SVProgressHUD

class LoginViewController: UIViewController, AcessDelegate {
    
    
    @IBOutlet weak var userField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var warningLabel: UILabel!
    
    var service = Service()
    var user: AcessModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.layer.cornerRadius = 25
    
        service.delegateLogInto = self
        userField.delegate = self
        passwordField.delegate = self
        
        
    }
    
    
    @IBAction func fieldUserPressed(_ sender: UITextField) {
        userField.endEditing(true)
    }
    
    @IBAction func fieldPsswordPressed(_ sender: UITextField) {
        passwordField.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == userField {
            
            if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
                nextField.resignFirstResponder()
            }
            else {
                textField.becomeFirstResponder()
            }
            return false
        } else {
            textField.endEditing(true)
            guard let user = userField.text else { return true }
            guard let password = passwordField.text else { return true }
            validateFileds(userFiled: user, passwordField: password)
            return true
        }
    }
}
// MARK: - VALIDATION LOGIN

extension LoginViewController: UITextFieldDelegate {
    
    func validateFileds( userFiled: String, passwordField: String) {
        let acessModel = ValidationAcessModel(userField: userFiled, passwordfField: passwordField)
        
        if acessModel.validateUserField(userFiled) || acessModel.validateCPF(userFiled){
            if acessModel.validatePasswordField(passwordField) {
                SVProgressHUD.show()
                service.requestLogin(userName: userFiled, password: passwordField)
            } else {
                warningLabel.text = "User or Password Invalid"
            }
        } else {
            warningLabel.text = "User or Password Invalid"
        }
    }
    
    func logInto(user: AcessModel) {
        DispatchQueue.main.async {
            self.loginButton.isUserInteractionEnabled = true
            self.user = user
            self.performSegue(withIdentifier: "Informations", sender: self)
        }
    }
}
// MARK: - FINISH VALIDATION LOGIN


// MARK: - TRANSITION VIEW
extension LoginViewController {
    @IBAction func loginButton(_ sender: UIButton) {
        
        self.loginButton.isUserInteractionEnabled = true
        
        guard let userField = userField.text else {return }
        guard let passwordField = passwordField.text else {return }
        
        validateFileds(userFiled: userField, passwordField: passwordField)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Informations" {
            let login = segue.destination as! ExtractViewController
            login.user = user
            SVProgressHUD.dismiss()
            self.dismiss(animated: false, completion: nil)
        }
    }
}
// MARK: - FINISH TRASITION VIEW


// MARK: - RESET TEXT FIELD
extension LoginViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        setupLogin()
    }
    
    func setupLogin() {
        self.userField.text = ""
        self.passwordField.text = ""
    }
}
// MARK: - FINISH RESET FIELD
