//
//  Transition.swift
//  BasicNoteApp
//
//  Created by Serkan Erkan on 18.07.2024.
//

import Foundation
import UIKit

protocol Transition: AnyObject {
    var viewController: UIViewController? { get set }

    func open(_ viewController: UIViewController)
    func close(_ viewController: UIViewController)
}
