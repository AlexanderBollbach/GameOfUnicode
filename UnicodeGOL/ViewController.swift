import UIKit

extension Array {
    func each<T>(fn: (T) -> ()) {
        for item in self {
            let itemAsT = item as! T
            fn(itemAsT)
        }
    }
}

class ViewController: UIViewController {
    
    var world: World!
    var gridView: GridView2!
    var mainTimer: Timer?

    var mainTimerSpeed = 0.01 {
        didSet {
            if mainTimerSpeed < 0.001 { mainTimerSpeed = 0.001
            } else if mainTimerSpeed > 0.9 { mainTimerSpeed = 0.9 } // lota chars to clamp huh
            
            print(mainTimerSpeed)
        }
    }
    
    var timerAccumulator = 0.0
    
    let rowSize = 5
    let colSize = 5
    
    let happyChar = "😀"
    let sadChar = "😥"
    let neutralChar = "😑"
    
    var isRunning = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        world = World(rows: rowSize, columns: colSize)
        
        let gv = GridView2(numRows: rowSize, numColumns: colSize)
        view.addSubview(gv)
        gv.translatesAutoresizingMaskIntoConstraints = false
        gv.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        gv.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        mainTimerSpeed = 0.1
        
        gv.tapAction = { (row, col) in self.world.toggle(row: row, col: col) }
        
        self.gridView = gv
        
        let controls = ABControlPanel(names: ["start", "stop", "clear", "s+", "s-"], where: .bottomLeft) { buttonName in
            switch buttonName {
            case "start":
                self.isRunning = true
            case "stop":
                self.isRunning = false
            case "clear":
                self.world.clear()
            case "s+":
                self.mainTimerSpeed += 0.001
            case "s-":
                self.mainTimerSpeed -= 0.001
            default: break
            }
        }
        view.addSubview(controls)
        
        startTimer()
    }
    
    
    func startTimer() {
        
        func update() {
  
            if self.isRunning { self.world.iterate() }
            
            for (index, cell) in self.world.cells.enumerated() {
                
                if cell.state == .happy {
                    gridView.labels[index].text = happyChar
                    
                } else if cell.state == .sad {
                    gridView.labels[index].text = sadChar
                    
                } else if cell.state == .neutral {
                    gridView.labels[index].text = neutralChar
                }
                
            }
        }
        
        mainTimer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { timer in
            
            self.timerAccumulator += self.mainTimerSpeed
            if self.timerAccumulator > 1.0 {
                self.timerAccumulator = 0.0
                update()
                
            }
        }
    }
}
