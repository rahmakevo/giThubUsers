//
//  CustomElementType.swift
//  GithubUsers
//
//  Created by Kevin Siundu on 10/05/2021.
//  Copyright © 2021 Kevin Siundu. All rights reserved.
//

import Foundation

enum CustomElementType: String {
    case normal
    case inverted
    case note
}

protocol CustomElementModel: class {
    var tpye: CustomElementType { get }
}

protocol CustomElementCell: class {
    func configure(withModel: CustomElementModel)
}
