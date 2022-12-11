//
//  PdfViewController.swift
//  PDFDemo
//
//  Created by Prajeet Shrestha on 09/12/2022.
//

import Foundation
import UIKit
import PDFKit


class PdfViewController: UIViewController {
    
    @IBOutlet weak var docViewer: PDFView!
    
    
    var data: Data? = nil
    
    func loadPDF(data:Data) {
        docViewer.document = PDFDocument(data: data)
    }
}
