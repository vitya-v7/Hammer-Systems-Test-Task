//
//  NewsAPIService.swift
//  Hammer-Systems-Test-Task
//
//  Created by Admin on 27.10.2022.
//

import Foundation

final class NewsAPIService {
    
    private lazy var xmlParserNews: XMLParserNews = XMLParserNews()
	
	func getNews(successCallback: @escaping ([NewsElementModel]?) -> Void, errorCallback: @escaping (Error) -> Void) {
        APIService.shared.getRequest(path: APIService.shared.host, successCallback: { [weak self] (data: Data?) in
			guard let strongSelf = self else { return }
			strongSelf.xmlParserNews = XMLParserNews()
			if let data = data {
				let news = strongSelf.xmlParserNews.parseData(data: data)
				successCallback(news)
			}
			
		}, errorCallback: errorCallback)
	}
}
