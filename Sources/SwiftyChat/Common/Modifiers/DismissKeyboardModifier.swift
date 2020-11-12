//
//  DismissKeyboardModifier.swift
//  
//
//  Created by Enes Karaosman on 28.08.2020.
//

import SwiftUI

// Use below approach, when handle pushing content up when keyboard appears.
// Investigate keyboardAwarePadding() modifier, it does actually its job
// But some how its broken with current as-is

extension UIApplication {
    func addTapGestureRecognizer() {
        guard let window = windows.first else { return }
        let tapGesture = AnyGestureRecognizer(target: window, action:#selector(UIView.endEditing))
        tapGesture.requiresExclusiveTouchType = false
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self //I don't use window as delegate to minimize possible side effects
        window.addGestureRecognizer(tapGesture)
    }
}

extension UIApplication: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true // set to `false` if you don't want to detect tap during other gestures
    }
}

class AnyGestureRecognizer: UIGestureRecognizer {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        if let touchedView = touches.first?.view, touchedView is UIControl {
            state = .cancelled

        } else if let touchedView = touches.first?.view as? UITextView, touchedView.isEditable {
            state = .cancelled
        } else if let touchedView = touches.first?.view as? UIButton, touchedView.isSelected {
            state = .cancelled
        } else {
            state = .began
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
       state = .ended
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        state = .cancelled
    }
}

// -----

internal extension View {
    dynamic func dismissKeyboardOnTappingOutside() -> some View {
        return ModifiedContent(content: self, modifier: DismissKeyboardOnTappingOutside())
    }
}

public struct DismissKeyboardOnTappingOutside: ViewModifier {
    public func body(content: Content) -> some View {
        content
            .onTapGesture {
                let keyWindow = UIApplication.shared.connectedScenes
                        .filter({$0.activationState == .foregroundActive})
                        .map({$0 as? UIWindowScene})
                        .compactMap({$0})
                        .first?.windows
                        .filter({$0.isKeyWindow}).first
                keyWindow?.endEditing(true)
        }
    }
}
