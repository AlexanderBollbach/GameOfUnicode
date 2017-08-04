//
//  GridView2.swift
//  UnicodeGOL
//
//  Created by Alexander Bollbach on 8/2/17.
//  Copyright © 2017 Alexander Bolesxzddlbach. All rights reserved.
//

import UIKit

class GridView2: UIView {
    
    var labels = [UILabel]()
    var tapAction: ((_ row: Int, _ col: Int) -> Void)?
    
    let rowSize: Int
    let colSize: Int
    
    var currentlyTouchedView: UIView?
    
    init(numRows: Int, numColumns: Int) {
        
        self.rowSize = numColumns // because row size (or numCellsInRow) is really how many columns there are
        self.colSize = numRows // vice versa
        
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        backgroundColor = .blue
        
        var counter = 0

        for r in 0..<numRows {
            for c in 0..<numColumns {
                
                let l = UILabel()
                l.text = String(counter)
                l.font = UIFont.systemFont(ofSize: 20)
                l.textAlignment = .center
                l.textColor = .red
                l.translatesAutoresizingMaskIntoConstraints = false
                labels.append(l)
                addSubview(l)
                
//                let widthMultiplier = CGFloat(1 / Double(rows))
//                let heightMultiplier = CGFloat(1 / Double(rows))
                l.widthAnchor.constraint(equalToConstant: 25).isActive = true
                l.heightAnchor.constraint(equalToConstant: 25).isActive = true
                
                if c == 0 {
                    l.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
                } else {
                    l.leftAnchor.constraint(equalTo: labels[c - 1].rightAnchor, constant: 5).isActive = true
                }
                
                if c == numColumns - 1 {
                    l.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
                }
                
                
                
                if r == 0 {
                    l.topAnchor.constraint(equalTo: topAnchor).isActive = true
                } else {
                    let thisCellIndex = ((numColumns * (r - 1)) + numColumns + c)
                    let prevCellIndex = thisCellIndex - numColumns
                    let arbitraryPreviousRowLabel = labels[prevCellIndex]
                    l.topAnchor.constraint(equalTo: arbitraryPreviousRowLabel.bottomAnchor, constant: 5).isActive = true
                }
                
                if r == numRows - 1 {
                    l.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
                }
                
                
                
                
                counter += 1
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let point = touches.first?.location(in: self) else { return }
        toggle(at: point, shouldDebounce: true)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let point = touches.first?.location(in: self) else { return }
        toggle(at: point, shouldDebounce: false)
    }
    
    
    
    func toggle(at point: CGPoint, shouldDebounce: Bool) {
        
        for l in labels {
            if l.frame.contains(point) {
                
                if l == currentlyTouchedView  && shouldDebounce {
                    return
                    
                }
                
                currentlyTouchedView = l
                
                if let index = labels.index(of: l) {
                    
                    let row = index / rowSize
                    let col = (row == 0) ? index : index % rowSize
                    
                    self.tapAction?(row, col)
                    break
                }
            }
        }
    }

    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
