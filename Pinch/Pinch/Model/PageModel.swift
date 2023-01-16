//
//  PageModel.swift
//  Pinch
//
//  Created by Vikas Vaish on 16/01/23.
//

import Foundation


struct Page : Identifiable{
    let id : Int
    let imageName : String
    
}

extension Page{
    var thumbNailName:String{
        return "thumb-" + imageName
    }
}
