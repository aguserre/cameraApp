//
//  DniModel.swift
//  RenaperPoC
//
//  Created by AGUSTIN ERRECALDE on 27/02/2020.
//  Copyright © 2020 AGUSTIN ERRECALDE. All rights reserved.
//

struct DniModel {
    
    var processNumber: String?
    var lastName: String?
    var name: String?
    var sex: String?
    var dniNumber: String?
    var copy: String?
    var birthDate: String?
    var createDate: String?
    
    func convertToDictionary(processNumber: String?, lastName: String?, name:String?, sex:String?, dniNumber:String?, copy:String?, birthDate:String?, createDate:String?) -> [String:String]{
        
        var dictionary: [String:String] = [:]
        dictionary.updateValue(processNumber ?? "", forKey: "processNumber")
        dictionary.updateValue(lastName ?? "", forKey: "lastName")
        dictionary.updateValue(name ?? "", forKey: "name")
        dictionary.updateValue(sex ?? "", forKey: "sex")
        dictionary.updateValue(dniNumber ?? "", forKey: "dniNumber")
        dictionary.updateValue(copy ?? "", forKey: "copy")
        dictionary.updateValue(birthDate ?? "", forKey: "birthDate")
        dictionary.updateValue(createDate ?? "", forKey: "createDate")

        return dictionary
    }
    
}
