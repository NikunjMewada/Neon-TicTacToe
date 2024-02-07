//
//  TicTacCVC.swift
//  TicTacToe
//
//  Created by Nikunj Mewada on 07/02/24.
//

import UIKit

// MARK: - Cell Button States
enum ButtonState: Int {
    case empty
    case cross
    case circle
}


class TicTacCVC: UICollectionViewCell {
    @IBOutlet weak var imgView: UIImageView!
    
    func configureCell(state: ButtonState) {
        var image = UIImage(named: "")
        switch state {
        case .empty:
            image = UIImage(named: "empty")
        case .cross:
            image = UIImage(named: "cross")
        case .circle:
            image = UIImage(named: "circle")
        }
        
        imgView.image = image
    }
}
