//
//  RosterForceNavigationController.swift
//  TableTopListBuilder
//
//  Created by Craig Appleton on 13/11/2020.
//

import UIKit

class RosterForceNavigationController: UINavigationController {
    
    typealias Handler = (_ game: Game, _ force: RosterForce) -> Void
    
    private var game: Game?
    private var catalogue: Catalogue?
    private var detachment: Detachment?
    
    var handler: Handler?
    
    convenience init() {
        
        let vc = CachedGamesTableViewController()
        
        self.init(rootViewController: vc)
        
        vc.rowSelectionHandler = { (game) in
            self.gameSelected(game)
        }
    }
    
    convenience init(game: Game?) {
        
        guard let game = game else  {
            self.init()
            return
        }
        
        let vc = CataloguesTableViewController()
        vc.catalogues = game.catalogues
        
        self.init(rootViewController: vc)
        
        vc.rowSelectionHandler = { (catalogue) in
            self.catalogueSelected(catalogue, game: game)
        }
    }
    
    
    // MARK: View Controller Transition Methods
    
    private func gameSelected(_ game: Game) {
        
        self.game = game
        
        let vc = CataloguesTableViewController()
        vc.catalogues = game.catalogues
        vc.rowSelectionHandler = { (catalogue) in
            self.catalogueSelected(catalogue, game: game)
        }
        
        self.pushViewController(vc, animated: true)
    }
    
    
    private func catalogueSelected(_ catalogue: Catalogue, game: Game) {
        
        self.catalogue = catalogue
        
        let vc = DetachmentsTableViewController()
        vc.detachments = game.detachments
        vc.rowSelectionHandler = { (detachment) in
            self.detachmentSelected(detachment, catalogue: catalogue, game: game)
        }
        
        self.pushViewController(vc, animated: true)
    }
    
    private func detachmentSelected(_ detachment: Detachment, catalogue: Catalogue, game: Game) {
        
        self.detachment = detachment
        
        self.handler?(game, RosterForce(detachment: detachment, catalogue: catalogue))
    }
}
