//
//  ViewController.swift
//  TicTacToe
//
//  Created by Nikunj Mewada on 07/02/24.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var collView: UICollectionView!
    @IBOutlet weak var playerImgView: UIImageView!
    @IBOutlet weak var resetButton: UIButton!
    
    // MARK: - Properties
    private var states = Array(repeating: ButtonState.empty, count: 9)
    private var timer = Timer()
    private var isPlayer1Playing = true {
        didSet {
            playerImgView.image = UIImage(named: "player\(isPlayer1Playing ? 1 : 2)")
        }
    }
    
    private var hasMatchEnded = false {
        didSet {
            if hasMatchEnded {
                timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] timer in
                    guard let self else { return }
                    self.resetButton.alpha = self.resetButton.alpha == 1 ? 0 : 1
                }
            }
        }
    }
    
    // MARK: - View Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupView()
    }
    
    private func setupView() {
        collView.backgroundColor = .black
        view.backgroundColor = .black
        isPlayer1Playing = true
        collView.register(UINib(nibName: "TicTacCVC", bundle: nil), forCellWithReuseIdentifier: "TicTacCVC")
    }
    
    @IBAction func resetBtnPressed(_ sender: UIButton) {
        states = Array(repeating: ButtonState.empty, count: 9)
        isPlayer1Playing = true
        hasMatchEnded = false
        timer.invalidate()
        collView.reloadData()
    }

    // MARK: - Game Logic
    private func shouldEndMatch(_ index: Int) -> Bool {
        switch index {
        case 0:
            return getFrontDiagonalValues() || getFirstRowResult() || getFirstColumnResult()
            
        case 1:
            return getFirstRowResult() || getFirstColumnResult()
            
        case 2:
            return getBackDiagonalValues() || getFirstRowResult() || getThirdColumnResult()
            
        case 3:
            return getSecondRowResult() || getFirstColumnResult()
            
        case 4:
            return getSecondRowResult() || getSecondColumnResult() || getFrontDiagonalValues() || getBackDiagonalValues()

        case 5:
            return getSecondRowResult() || getThirdColumnResult()
            
        case 6:
            return getThirdRowResult() || getFirstColumnResult() || getBackDiagonalValues()

        case 7:
            return getThirdRowResult() || getSecondColumnResult()
            
        case 8:
            return getThirdRowResult() || getThirdColumnResult() || getFrontDiagonalValues()

        default: return false
        }
        
    }
    
    private func getFirstColumnResult() -> Bool {
        let turnState: ButtonState = isPlayer1Playing ? .circle : .cross
        return states[0] == turnState && states[3] == turnState && states[6] == turnState
    }
    
    private func getSecondColumnResult() -> Bool {
        let turnState: ButtonState = isPlayer1Playing ? .circle : .cross
        return states[1] == turnState && states[4] == turnState && states[7] == turnState
    }
    
    private func getThirdColumnResult() -> Bool {
        let turnState: ButtonState = isPlayer1Playing ? .circle : .cross
        return states[2] == turnState && states[5] == turnState && states[8] == turnState
    }
    
    private func getFirstRowResult() -> Bool {
        let turnState: ButtonState = isPlayer1Playing ? .circle : .cross
        return states[0] == turnState && states[1] == turnState && states[2] == turnState
    }
    
    private func getSecondRowResult() -> Bool {
        let turnState: ButtonState = isPlayer1Playing ? .circle : .cross
        return states[3] == turnState && states[4] == turnState && states[5] == turnState
    }
    
    private func getThirdRowResult() -> Bool {
        let turnState: ButtonState = isPlayer1Playing ? .circle : .cross
        return states[6] == turnState && states[7] == turnState && states[8] == turnState
    }
    
    private func getFrontDiagonalValues() -> Bool {
        let turnState: ButtonState = isPlayer1Playing ? .circle : .cross
        return states[0] == turnState && states[4] == turnState && states[8] == turnState
    }
    
    private func getBackDiagonalValues() -> Bool {
        let turnState: ButtonState = isPlayer1Playing ? .circle : .cross
        return states[2] == turnState && states[4] == turnState && states[6] == turnState
    }
}

//MARK: - Delegate
extension ViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    private func updateViewAtTap(_ index: Int) {
        if states[index] == .empty && !(hasMatchEnded) {
            states[index] = isPlayer1Playing ? .circle : .cross
            
            if shouldEndMatch(index) == false {
                isPlayer1Playing.toggle()
            } else {
                hasMatchEnded = true
                playerImgView.image = UIImage(named: "player\(isPlayer1Playing ? 1 : 2)_wins")
            }
            collView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        updateViewAtTap(indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collView.frame.width / 3.2
        
        return CGSize(width: size, height: size)
    }
}

//MARK: - Data Source
extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collView.dequeueReusableCell(withReuseIdentifier: "TicTacCVC", for: indexPath) as? TicTacCVC {
            cell.configureCell(state: states[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
}
