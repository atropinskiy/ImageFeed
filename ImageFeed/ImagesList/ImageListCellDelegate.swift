//
//  ImageListCellDelegate.swift
//  ImageFeed
//
//  Created by alex_tr on 04.10.2024.
//

import Foundation

protocol ImageListCellDelegate : AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}
