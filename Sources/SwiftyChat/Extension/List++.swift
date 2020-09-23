//
//  List++.swift
//  SDWebImage
//
//  Created by Jonathan Willis on 8/31/20.
//

// Code for scrolling List to a row when there is more than one List view in the SwiftUI hierarchy.
// The idea is to have a class that can hold a reference to the table view in question (underlying UITableView of SwiftUI List view).
// Add a TableViewFinder view inside the List, which will find its parent UITableView and set a reference to it to the ScrollManager.
// Then add a ScrollManagerView to the List which will listen to indexPathToSetVisible binding changes and scroll to the correct row.
// This needs to be this way via a binding, we can't just call the `scrollTo(_ indexPath: IndexPath)` method directly, because it should be called when the table view was already updated with the new row.

import SwiftUI

public extension UIView {
    
    func superview<T>(of type: T.Type) -> T? {
        if let result = superview as? T {
            if let scrollView = result as? UIScrollView {
                if scrollView.frame.height < 40 {
                    return superview?.superview(of: type)
                }
            }
            return result
        } else {
            return superview?.superview(of: type)
        }
    }
}

public struct TableViewFinder: UIViewRepresentable {
    
    let scrollManager: ScrollManager
    
    public func makeUIView(context: Context) -> ChildViewOfTableView {
        let view = ChildViewOfTableView()
        view.scrollManager = scrollManager
        
        return view
    }
    
    public func updateUIView(_ uiView: ChildViewOfTableView, context: Context) {}
}

public class ChildViewOfTableView: UIView {
    
    weak var scrollManager: ScrollManager?
    
    public override func didMoveToWindow() {
        super.didMoveToWindow()
        
        if scrollManager?.tableView == nil {
            scrollManager?.tableView = self.superview(of: UITableView.self)
        }
    }
}

public class ScrollManager {
    weak var tableView: UITableView?
    
    public func scrollTo(_ indexPath: IndexPath) {
        guard let tableView = tableView else { return }
        if tableView.numberOfSections > indexPath.section && tableView.numberOfRows(inSection: indexPath.section) > indexPath.row {
            tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
}

public struct ScrollManagerView: UIViewRepresentable {
    let scrollManager: ScrollManager
    
    @Binding var indexPathToSetVisible: IndexPath?
    
    
    public func makeUIView(context: Context) -> UIView {
        let view = UIView()
        
        return view
    }
    
    public func updateUIView(_ uiView: UIView, context: Context) {
        guard let indexPath = indexPathToSetVisible else { return }
        
        // the scrolling has to be inside this method, because it gets called after the table view was already updated with the new row
        scrollManager.scrollTo(indexPath)
        
        DispatchQueue.main.async {
            self.indexPathToSetVisible = nil
        }
    }
    
}