//
//  ViewController.swift
//  PDFDemo
//
//  Created by Prajeet Shrestha on 09/12/2022.
//

import UIKit
import InvoiceKit
import PDFKit

class ViewController: UIViewController {
    
    @IBOutlet weak var pdfView: PDFView!
    var controller:PdfViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pdfView.autoScales = true
        pdfView.document = PDFDocument(data: getPdfData())
        
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .action,
                                            target: self,
                                            action: #selector(self.presentShare))
        barButtonItem.tintColor = .black
        self.navigationItem.rightBarButtonItem = barButtonItem
        
    }
    
    @objc func presentShare(_ sender: Any) {
        // Do any additional setup after loading the view.
        
        let vc = UIActivityViewController(activityItems: [getPdfData()], applicationActivities: [])
        present(vc, animated: true, completion: nil)
    }
    
    
    private func getRowData() -> [InvoiceRowItem] {
        var items = [InvoiceRowItem]()
        for num in 0..<20 {
            items.append(InvoiceRowItem(sno: "\(num)", remarks: "Description \(num)", quantity: String(num), rate: String(num * 100), total: String(num * (num * 100))))
        }
        return items
    }
    
    private func getMeta() -> InvoiceMeta {
        let meta = InvoiceMeta(businessName: "Cloud Mart",
                               businessEmail: "cloudmart@gmail.com",
                               businessContact: "9865997309",
                               businessAddress: "Kathmandu, Nepal",
                               author: "Prajeet",
                               title: "Account",
                               order: InvoiceOrder(customerName: "Hari Khadka", orderId: "AE109", date: "2022/03/03", totalAmount: "1000"))
        return meta
    }
    
    
    private func getPdfData() -> Data {
        let pdfCreator = PDFInvoice(rowItems: getRowData(), metaInfo: getMeta())
        return pdfCreator.createInvoice()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination.isKind(of: PdfViewController.self) {
            controller = segue.destination as? PdfViewController
        }
    }
}

