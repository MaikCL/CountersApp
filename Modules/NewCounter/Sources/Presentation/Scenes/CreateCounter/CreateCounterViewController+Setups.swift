import UIKit
import Design

extension CreateCounterViewController {
    
    func setupNavigationController() {
        title = Locale.navigationBarTitle.localized
        let backItem = UIBarButtonItem()
        backItem.title = Locale.navigationBack.localized
        navigationItem.largeTitleDisplayMode = .never
        
        setupSaveBarButtonItem()
        setupCancelBarButtonItem()
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
        saveBarButtonItem.action = #selector(saveNewCounter(_:))
        navigationItem.rightBarButtonItem = saveBarButtonItem
    }
        
    func setupCancelBarButtonItem() {
        let cancelBarButtonItem = UIBarButtonItem()
        cancelBarButtonItem.title = Locale.buttonItemCancel.localized
        cancelBarButtonItem.tintColor = Palette.accent.uiColor
        cancelBarButtonItem.style = .plain
        cancelBarButtonItem.target = self
        cancelBarButtonItem.action = #selector(cancelNewCounter(_:))
        navigationItem.leftBarButtonItem = cancelBarButtonItem
    }
    
}
