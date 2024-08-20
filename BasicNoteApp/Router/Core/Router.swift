//
//  Router.swift
//  BasicNoteApp
//
//  Created by Serkan Erkan on 18.07.2024.
//

import UIKit

protocol RouterProtocol: AnyObject {
    func open(_ storyboardName: String, _ viewControllerID: String, transition: Transition, extraParams: [String: Any]?)
    func close()
}

public class Router: RouterProtocol {
    
    weak var viewController: UIViewController?
    var openTransition: Transition?

    func open(_ storyboardName: String, _ viewControllerID: String, transition: Transition, extraParams: [String: Any]? = nil) {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: viewControllerID)
        
        if let params = extraParams, let noteListVC = viewController as? NoteListViewController {
            noteListVC.accessToken = params["access_token"] as? String
        }
        
        if let params = extraParams, let noteDetailVC = viewController as? NoteDetailViewController {
            noteDetailVC.noteID = params["noteID"] as? Int
            noteDetailVC.accessToken = params["access_token"] as? String
        }
        
        if let params = extraParams, let editNoteVC = viewController as? EditNoteViewController {
            editNoteVC.noteID = params["noteID"] as? Int
            editNoteVC.accessToken = params["access_token"] as? String
        }
        
        if let params = extraParams, let profileVC = viewController as? ProfileViewController {
            profileVC.accessToken = params["access_token"] as? String
        }
        
        if let params = extraParams, let changePasswordVC = viewController as? ChangePasswordViewController {
            changePasswordVC.accessToken = params["access_token"] as? String
        }
        
        transition.viewController = self.viewController
        transition.open(viewController)
    }

    func close() {
        guard let openTransition = openTransition else {
            assertionFailure("You should specify an open transition in order to close a module.")
            return
        }
        guard let viewController = viewController else {
            assertionFailure("Nothing to close.")
            return
        }
        openTransition.close(viewController)
    }
    
    deinit {
        debugPrint("deinit \(self)")
    }
}
