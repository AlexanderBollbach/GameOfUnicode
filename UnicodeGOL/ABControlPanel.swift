//
//  ABControlPanel.swift
//  UnicodeGOL
//
//  Created by Alexander Bollbach on 8/2/17.
//  Copyright © 2017 Alexander Bollbach. All rights reserved.
//

import UIKit

enum Position {
    case bottomLeft
}

class ABControlPanel: UIView {
 
    var callback: (_ name: String) -> Void
    
    var position: Position
    
    init(names: [String], `where`: Position, callback: @escaping (_ name: String) -> Void) {
        
        self.callback = callback
        self.position = `where`
        
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        configure(names: names)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func didMoveToSuperview() {
        
        guard let sv = superview else { fatalError("you (the implementor) dont understand view lifecycles") }
        
        switch self.position {
        case .bottomLeft:
            leftAnchor.constraint(equalTo: sv.leftAnchor).isActive = true
            bottomAnchor.constraint(equalTo: sv.bottomAnchor).isActive = true
        }
    }
 
    private func configure(names: [String]) {
        
        var buttons = [UIButton]()
        
        for (n,c) in names.enumerated() {
            
            let button = UIButton()
            button.backgroundColor = .blue
            button.setTitle(names[n], for: .normal)
            buttons.append(button)
            button.tag = Int(n)
            button.addAction(for: .touchUpInside, action: { self.callback(c) })
        }
        
        let sv = UIStackView(arrangedSubviews: buttons)
        addSubview(sv)
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        sv.spacing = 5
        
        sv.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        sv.topAnchor.constraint(equalTo: topAnchor).isActive = true
        sv.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        sv.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    }
}


class ClosureSleeve {
    let closure: () -> ()
    
    init(attachTo: AnyObject, closure: @escaping () -> ()) {
        self.closure = closure
        objc_setAssociatedObject(attachTo, "[\(arc4random())]", self, .OBJC_ASSOCIATION_RETAIN)
    }
    @objc func invoke() { closure() }
}

extension UIControl {
    func addAction(for controlEvents: UIControlEvents, action: @escaping () -> ()) {
        let sleeve = ClosureSleeve(attachTo: self, closure: action)
        addTarget(sleeve, action: #selector(ClosureSleeve.invoke), for: controlEvents)
    }
}
