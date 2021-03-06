//
//  WebServiceConfig.swift
//  TrueWeight Task
//
//  Created by Suresh Kumar Linganathan on 30/12/20.
//  Copyright © 2020 SureshKumar. All rights reserved.
//

import UIKit

enum HttpMethod : String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum UrlVersionType: String{
    case firstVersion = "v1"
    case secondVersion = "v2"
}

enum ActionType : String {
    
    case fetchRepo = "search/repositories"
    case fetchContributor = "/contributors"
    case fetchIssues = "/issues"
    case fetchComments = "/comments"
}

struct ApiUrl {
    mutating func getBaseUrl(type: UrlVersionType)->String{
        switch type {
        case .firstVersion:
            return ApiIP.appIP_v1
        default:
            return ApiIP.appIP_v2
        }
    }
}

struct ApiIP {
    static let appIP_v1 = "https://api.github.com/"
    static let appIP_v2 = "https://api.github.com/repos/"
}

enum APIHeadersType {
    case basic
}

class WebServiceConfig {
    
    static let shared : WebServiceConfig = WebServiceConfig.init()
    
    class func requestHeaders(type: APIHeadersType) -> [String: String]? {
        switch type {
        case .basic:
            return ["Content-Type": "application/json"]
        }
    }
    
    class  func getUrlWithHeaders(forActionType type: ActionType, forHeaderType htype: APIHeadersType, queryString:[String:String], apiType: UrlVersionType,paths:[String]?) -> (String, [String: String]?) {
        let headerDict = WebServiceConfig.requestHeaders(type: htype)
        var apiUrl = ApiUrl()
        var baseUrl = apiUrl.getBaseUrl(type: apiType)
       
        if let arrPaths = paths{
            baseUrl += createPath(array:arrPaths)
        }
        baseUrl += type.rawValue
        if queryString.count > 0{
         baseUrl += WebServiceConfig.createQueryString(dict:queryString)
        }
        return (baseUrl,headerDict)
    }
    
    class func createQueryString(dict:[String:String])->String{
        var queryStr = "?"
        var count = 0
        for (key, value) in dict{
            if count >= 1{
                queryStr += "&"
            }
            queryStr = queryStr+key+"="+value
            count = count+1
        }
        return queryStr
    }
    
    class func createPath(array:[String])->String{
        
        var pathStr = ""
        var count = 0
        for str in array{
            
            if count >= 1{
                pathStr += "/"
            }
            pathStr += str
            count += 1
        }
        return pathStr
    }
}


