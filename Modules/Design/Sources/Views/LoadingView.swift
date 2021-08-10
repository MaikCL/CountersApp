import UIKit
import AltairMDKCommon

public final class LoadingView: UIView {
    
    lazy var activityIndicator: UIActivityIndicatorView = {
       setupActivityIndicator()
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupSubViews()
        setupConstraints()
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension LoadingView {
    
    func setupView() {
        backgroundColor = Palette.background.uiColor
    }
    
    func setupSubViews() {
        addSubview(activityIndicator)
        setSubviewForAutoLayout(activityIndicator)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: safeAreaLayoutGuide.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: safeAreaLayoutGuide.centerXAnchor)
        ])
    }
    
}

private extension LoadingView {
    
    func setupActivityIndicator() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.startAnimating()
        return activityIndicator
    }
    
}
