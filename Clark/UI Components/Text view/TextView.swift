//
//  TextView.swift
//  Clark
//
//  Created by Vladislav Zagorodnyuk on 9/5/17.
//  Copyright © 2017 Clark. All rights reserved.
//

class TextView: UITextView {
    override func caretRect(for position: UITextPosition) -> CGRect {
        var originalRect = super.caretRect(for: position)
        
        if let fontPointSize = font?.pointSize {
            originalRect.size.height = fontPointSize //When increasing line spacing, it increases the caret rect height. This sets it to a more sensible value.
        }
        
        return originalRect
    }
    
    /// Prevents text view from becoming scrollable for some reason. 🙄
    override var contentOffset: CGPoint {
        set {
            super.contentOffset = CGPoint(x: 0, y: 0)
        }
        
        get {
            return CGPoint(x: 0, y: 0)
        }
    }
    
    /// Prevents text view from having a random bottom inset that it sometimes likes to add.
    override var contentInset: UIEdgeInsets {
        set {
            super.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        }
        
        get {
            return UIEdgeInsetsMake(0, 0, 0, 0)
        }
    }
    
    /// Sometimes the text view content size has been incorrect. This should fix that.
    override var contentSize: CGSize {
        set {
            super.contentSize = bounds.size
        }
        
        get {
            return bounds.size
        }
    }
}
