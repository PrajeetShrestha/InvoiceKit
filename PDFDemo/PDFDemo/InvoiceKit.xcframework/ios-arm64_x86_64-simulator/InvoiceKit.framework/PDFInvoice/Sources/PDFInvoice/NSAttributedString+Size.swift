//
//  File.swift
//  
//
//  Created by Prajeet Shrestha on 09/12/2022.
//

import Foundation

extension NSAttributedString {
    
    func height(containerWidth: CGFloat) -> CGFloat {
        
        let rect = self.boundingRect(with: CGSize.init(width: containerWidth, height: CGFloat.greatestFiniteMagnitude),
                                     options: [.usesLineFragmentOrigin],
                                     context: nil)
        return ceil(rect.size.height)
    }
    
    func width(containerHeight: CGFloat) -> CGFloat {
        
        let rect = self.boundingRect(with: CGSize.init(width: CGFloat.greatestFiniteMagnitude, height: containerHeight),
                                     options: [.usesLineFragmentOrigin],
                                     context: nil)
        return ceil(rect.size.width)
    }
}
