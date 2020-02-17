//
//  ServiceErrors.swift
//  Photo_Albums
//
//  Created by Igor Shelginskiy on 2/17/20.
//  Copyright © 2020 Igor Shelginskiy. All rights reserved.
//

import Foundation

enum ServiceError: Error
{
	case noData
	case invalidURL(Error)
	case noResponse
}
