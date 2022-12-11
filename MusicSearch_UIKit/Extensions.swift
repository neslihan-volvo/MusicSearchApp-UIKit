import Foundation
import UIKit

extension String {
    func makeSearchString() -> String {
        let trimmed = trimmingCharacters(in: .whitespacesAndNewlines)
        let mapped = String(trimmed.map {
            $0 == " " || $0 == "\n" ? "+" : $0
        })
        return mapped
    }
}

extension UIImageView {
    func applyShadow(containerView : UIView, coefficient: CGFloat){
        let cornerRadius = self.frame.height * coefficient
        containerView.clipsToBounds = false
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 1
        containerView.layer.shadowOffset = CGSize.zero
        containerView.layer.shadowRadius = 5
        containerView.layer.cornerRadius = cornerRadius
        containerView.layer.shadowPath = UIBezierPath(roundedRect: containerView.bounds, cornerRadius: cornerRadius).cgPath
        self.clipsToBounds = true
        self.layer.cornerRadius = cornerRadius
        self.contentMode = .scaleToFill
    }
}
