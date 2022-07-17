//
//  LoadingIndicatorView.swift
//  LilPictures
//
//  Created by Малиль Дугулюбгов on 17.07.2022.
//

import UIKit

class LoadingIndicatorView: UIActivityIndicatorView {
    override init(style: UIActivityIndicatorView.Style) {
        super.init(style: style)
        self.hidesWhenStopped = true
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
