//
//  XMLParserNews.swift
//  Hammer-Systems-Test-Task
//
//  Created by Admin on 27.10.2022.
//

import Foundation

final class XMLParserNews: NSObject, XMLParserDelegate {
	
    private var tempNewsElementModel: NewsElementModel?
    private var tempElement: String?
    private var posts: [NewsElementModel]?
    private let itemElementName = "item"
    
	override init() {
		posts = [NewsElementModel]()
		super.init()
	}

	deinit {
		posts = nil
	}

	func parseData(data: Data) -> [NewsElementModel]? {

		let xmlParser = XMLParser.init(data: data)
		xmlParser.delegate = self
		xmlParser.parse()

		return posts
    }
    
    // MARK: - XMLParserDelegate
    
    var urlImage: String?
    func parser(_ parser: XMLParser,
                didStartElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?,
                attributes attributeDict: [String: String] = [:]) {
        tempElement = elementName
        if elementName == self.itemElementName {
            tempNewsElementModel = NewsElementModel(url: "", title: "", description: "")
        }
        if elementName == "enclosure" {
            if let urlString = attributeDict["url"] {
                tempNewsElementModel?.url = urlString
            }
        }
    }
    
    func parser(_ parser: XMLParser,
                didEndElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?) {
        if elementName == self.itemElementName {
            
            if let post = tempNewsElementModel {
                var modifiedPost = post
                modifiedPost.description = modifiedPost.description.trimmingCharacters(in: .whitespacesAndNewlines)
                modifiedPost.title = modifiedPost.title.trimmingCharacters(in: .whitespacesAndNewlines)
                posts?.append(modifiedPost)
            }
            tempNewsElementModel = nil
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if let post = tempNewsElementModel {
            if tempElement == "title" {
                tempNewsElementModel?.title = post.title + string
            }
            if tempElement == "description" {
                tempNewsElementModel?.description = post.description + string
            }
        }
    }
    
    private func parser(parser: XMLParser, parseErrorOccurred parseError: NSError) {
        NSLog("failure error: %@", parseError)
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        
    }
}
