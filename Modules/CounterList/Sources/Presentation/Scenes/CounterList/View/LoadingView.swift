import UIKit
import Design
import AltairMDKCommon

final class LoadingView: UIView {
    
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
            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    
}

private extension LoadingView {
    
    func setupActivityIndicator() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        activityIndicator.startAnimating()
        return activityIndicator
    }
    
}
