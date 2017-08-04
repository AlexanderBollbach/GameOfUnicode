//
//  World.swift
//  UnicodeGOL
//
//  Created by Alexander Bollbach on 8/1/17.
//  Copyright © 2017 Alexander Bollbach. All rights reserved.
//

import Foundation



class Cell: CustomStringConvertible {
    let row: Int, column: Int
    var state: State
    
    init (row: Int, column: Int) {
        self.row = row
        self.column = column
        state = .neutral
    }
    
    var description: String {
        return state.rawValue
    }
}

enum State: String {
    case happy = "happy"
    case sad = "sad"
    case neutral = "neutral"
}


class World {
    
    var cells = [Cell]()
    
    let rows: Int
    let columns: Int
    
    init(rows: Int, columns: Int) {
        self.rows = rows
        self.columns = columns
        
        for row in 0..<rows {
            for column in 0..<columns {
                cells.append(Cell(row: row, column: column))
            }
        }
    }
    
    subscript (row: Int, column: Int) -> Cell? { return cells.filter { $0.row == row && $0.column == column }.first }
    
    func toggle(row: Int, col: Int) {
        
        guard let state = self[row,col]?.state else { return }
        
        switch state {
        case .happy:
            self[row,col]?.state = .sad
        case .sad:
            self[row,col]?.state = .neutral
        case .neutral:
            self[row,col]?.state = .happy
        
        }
        
    }
    
    func iterate() {
        
        let cellsAreNeighbours = {
            (op1: Cell, op2: Cell) -> Bool in
            let delta = (abs(op1.row - op2.row), abs(op1.column - op2.column))
            switch (delta) {
            case (1,1), (1,0), (0,1):
                return true
            default:
                return false
            }
        }
        let neighboursForCell = { (cell: Cell) -> [Cell] in
            return self.cells.filter { cellsAreNeighbours($0, cell)}
        }
        let happyNeighborsForCell = { (cell: Cell) -> Int in
            neighboursForCell(cell).filter{ $0.state == State.happy }.count
        }
        
        let sadNeighborsForCell = { (cell: Cell) -> Int in
            neighboursForCell(cell).filter{ $0.state == State.sad }.count
        }
        
        // rules of life
        let happyCells = cells.filter {
            $0.state == .happy
            
        }
        let sadCells = cells.filter {
            $0.state != .sad
            
        }
        
        let nowHappyCells = sadCells.filter { happyNeighborsForCell($0) > 3 }
        let nowSadCells =  happyCells.filter { happyNeighborsForCell($0) > 4 }
        
        
        // updating the world state
        nowHappyCells.forEach { $0.state = .happy }
        nowSadCells.forEach { $0.state = .sad }
        
    }
    
    func clear() { for cell in cells { cell.state = .neutral } }
}
