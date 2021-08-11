import UIKit
import DesignKit

extension CreateCounterViewController {
    
    func setupNavigationController() {
        title = Locale.navigationBarCreateCounter.localized
        let backItem = UIBarButtonItem()
        backItem.title = Locale.navigationBack.localized
        navigationItem.backBarButtonItem = backItem
        navigationItem.largeTitleDisplayMode = .never
        
        setupSaveBarButtonItem()
        setupCancelBarButtonItem()
    }
    
    func setupNavigationBar() {
        navigationController?.navigationBar.barTintColor = Palette.main.uiColor
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    func setupDelegates() {
        innerView.delegate = self
    }
    
    func setupSaveBarButtonItem() {
        let saveBarButtonItem = UIBarButtonItem()
        saveBarButtonItem.title = Locale.buttonItemSave.localized
        saveBarButtonItem.isEnabled = false
        saveBarButtonItem.tintColor = Palette.accent.uiColor
        saveBarButtonItem.style = .done
        saveBarButtonItem.target = self
        saveBarButtonItem.action = #selector(didTapSaveButtonAction(_:))
        navigationItem.rightBarButtonItem = saveBarButtonItem
    }
        
    func setupCancelBarButtonItem() {
        let cancelBarButtonItem = UIBarButtonItem()
        cancelBarButtonItem.title = Locale.buttonItemCancel.localized
        cancelBarButtonItem.tintColor = Palette.accent.uiColor
        cancelBarButtonItem.style = .plain
        cancelBarButtonItem.target = self
        cancelBarButtonItem.action = #selector(didTapCanceButtonAction(_:))
        navigationItem.leftBarButtonItem = cancelBarButtonItem
    }
    
}
