import UIKit
import PDFKit

public struct InvoiceRowItem {
    let sno:String
    let description:String
    let quantity:String
    let rate: String
    let total:String
    
    public init(sno: String, description: String, quantity: String, rate: String, total: String) {
        self.sno = sno
        self.description = description
        self.quantity = quantity
        self.rate = rate
        self.total = total
    }
}

public struct InvoiceOrder {
    let customerName:String
    let orderId:String
    let date:String
    let totalAmount:String
    
    public init(customerName: String, orderId: String, date: String, totalAmount: String) {
        self.customerName = customerName
        self.orderId = orderId
        self.date = date
        self.totalAmount = totalAmount
    }
}

public struct InvoiceMeta {
    let businessName:String
    let businessEmail:String
    let businessContact:String
    let businessAddress:String
    let author:String
    let title:String
    let orderInfo:InvoiceOrder
    
    public init(businessName: String, businessEmail: String, businessContact: String, businessAddress: String, author: String, title: String, order: InvoiceOrder) {
        self.businessName = businessName
        self.businessEmail = businessEmail
        self.businessContact = businessContact
        self.businessAddress = businessAddress
        self.author = author
        self.title = title
        self.orderInfo = order
    }
}

public class PDFInvoice: NSObject {
    
    // MARK: Constants
    private let pageWidth = 8 * 72.0
    private var contentWidth:CGFloat {
        return pageWidth - 2 * marginLeftRight
    }
    private let pageHeight = 10 * 72.0
    private let marginTop:CGFloat = 100
    private let marginBottom:CGFloat = 150.0
    private let marginLeftRight:CGFloat = 30.0
    
    // For header and bottom (Total) line
    private let lineSize:CGFloat = 30.0
    private let rowItemPadding:CGFloat = 16
    private let rowSpacing:CGFloat = 8
    
    // MARK: Computed Properties
    private var minX: CGFloat { return pageRect.minX }
    private var minY:CGFloat { return pageRect.minY }
    private var maxX: CGFloat { return pageRect.maxX }
    private var maxY: CGFloat { return pageRect.maxY }
    private var width: CGFloat { return pageRect.width }
    private var height: CGFloat { return pageRect.height }
    
    private var columnWidth0:CGFloat {
        return contentWidth * 0.10
    }
    private var columnWidth1:CGFloat {
        return contentWidth * 0.20
    }
    
    private var columnWidth2:CGFloat {
        return contentWidth * 0.40
    }
    
    private var columnWidths:[CGFloat] {
        return [columnWidth0, columnWidth2, columnWidth0, columnWidth1, columnWidth1]
    }
    
    private var columnXPositions:[CGFloat] {
        return [0,
                columnWidth0, columnWidth0 + columnWidth2 ,
                2 * columnWidth0 + columnWidth2,
                2 * columnWidth0 + columnWidth2 + columnWidth1]
    }
    
    func getXPosition(position:Int) -> CGFloat {
        return columnXPositions[position] + marginLeftRight
    }
    
    private var contentRect:CGRect = .zero
    private var pageRect:CGRect = .zero
    
    // MARK: Dependencies
    var rowItems:[InvoiceRowItem]
    var metaInfo:InvoiceMeta
    
   public init(rowItems:[InvoiceRowItem], metaInfo:InvoiceMeta) {
        self.rowItems = rowItems
        self.metaInfo = metaInfo
    }
    
   public func createInvoice() -> Data {
        let pdfMetaData = [
            kCGPDFContextCreator: metaInfo.businessName,
            kCGPDFContextAuthor: metaInfo.author,
            kCGPDFContextTitle: metaInfo.title
        ]
        
        let format = UIGraphicsPDFRendererFormat()
        format.documentInfo = pdfMetaData as [String: Any]
        
        let widthOfDescription = columnWidth2 - rowItemPadding
        let attributes = getAttributes()
        var height = 0.0
        
        // Calculate height of whole PDF document
        for item in rowItems {
            let string = NSMutableAttributedString(string: item.description,
                                                   attributes: attributes)
            let h = string.height(containerWidth: widthOfDescription) + rowSpacing
            height += h
        }
        height += rowSpacing
        
        // Margin - LineSize (Header) - ContentArea - LineSize (Total) - Margin
        contentRect =   CGRect(x: 0,
                               y: 0,
                               width: pageWidth,
                               height: height + marginTop + marginBottom + (2 * lineSize))
        pageRect = CGRect(x: marginLeftRight,
                          y: marginTop,
                          width: pageWidth - marginLeftRight * 2,
                          height: contentRect.height - marginTop - marginBottom)
        
        let renderer = UIGraphicsPDFRenderer(bounds: contentRect, format: format)
        let data = renderer.pdfData { (context) in
            context.beginPage()
            drawLines(context.cgContext, pageRect: pageRect)
            addHeaderText()
            addRows(items: rowItems)
            addTotal(total: metaInfo.orderInfo.totalAmount)
            addTopContent()
            addBottomContent()
        }
        return data
    }
    
    private func drawLines(_ drawContext: CGContext, pageRect: CGRect) {
        func drawVerticalLine(context drawContext:CGContext, xPosition:CGFloat) {
            drawContext.saveGState()
            drawContext.setStrokeColor(UIColor.lightGray.cgColor)
            drawContext.move(to: CGPoint(x: xPosition, y: minY))
            drawContext.addLine(to: CGPoint(x: xPosition, y:  maxY - lineSize))
            drawContext.strokePath()
            drawContext.restoreGState()
        }
        drawContext.saveGState()
        // Inner Rect
        drawContext.setLineWidth(1.0)
        drawContext.setStrokeColor(UIColor.darkGray.cgColor)
        drawContext.move(to: CGPoint(x: minX, y: minY))
        drawContext.addRect(pageRect)
        drawContext.strokePath()
        
        // Horizontal Top Line
        drawContext.move(to: CGPoint(x: minX, y: minY + lineSize))
        drawContext.addLine(to: CGPoint(x: maxX, y: minY + lineSize))
        drawContext.strokePath()
        
        // Horizontal Bottom Line
        drawContext.move(to: CGPoint(x: minX, y: maxY - lineSize))
        drawContext.addLine(to: CGPoint(x: maxX, y: maxY - lineSize))
        drawContext.strokePath()
        
        for index in 0..<5 {
            // drawVerticalLine(context: drawContext, rect: pageRect, percent: m)
            drawVerticalLine(context: drawContext, xPosition: getXPosition(position: index))
        }
        drawContext.saveGState()
    }
    
    private func addHeaderText() {
        let titles = ["S.No", "Description" , "Qty", "Rate", "Amount"]
        for (index, title) in titles.enumerated() {
            let attString = NSMutableAttributedString(string: title, attributes: getAttributes())
            let height = attString.height(containerWidth: columnWidths[index])
            attString.draw(in: CGRect(x: getXPosition(position: index) + rowItemPadding / 2,
                                      y: minY + rowItemPadding / 2 ,
                                      width:columnWidths[index] - rowItemPadding ,
                                      height: height))
        }
    }
    
    private func addTotal(total:String) {
        let modified = "Total: \(total)"
        let attString = NSMutableAttributedString(string: modified, attributes: getAttributes())
        let width = attString.width(containerHeight: 15)
        attString.draw(at: CGPoint(x: maxX - width - 16, y: pageRect.maxY - lineSize + rowSpacing / 2))
    }
    
    private func addRows(items:[InvoiceRowItem]) {
        
        var cumulatedHeight = 8.0
        for (_, item) in items.enumerated() {
            let values = [item.sno, item.description , item.quantity, item.rate, item.total]
            
            var tempHeightStorage:CGFloat = 0
            for (index, title) in values.enumerated() {
                
                let attString = NSMutableAttributedString(string: title, attributes: getAttributes())
                let height = attString.height(containerWidth: columnWidths[index] - rowItemPadding)
                
                let rect  = CGRect(x: getXPosition(position: index) + rowItemPadding/2 ,
                                   y: (minY + lineSize + cumulatedHeight),
                                   width:columnWidths[index] - rowItemPadding ,
                                   height: height)
                attString.draw(in: rect)
                
                if index == 1 {
                    tempHeightStorage += height + rowSpacing
                }
                if index == 4 {
                    cumulatedHeight += tempHeightStorage
                }
            }
        }
    }
    
    private func addTopContent() {
        
        let content = """
    Invoice
    Customer Name: \(metaInfo.orderInfo.customerName)
    Date: \(metaInfo.orderInfo.date)
    Order Id: \(metaInfo.orderInfo.orderId)
    """
        let attString = NSMutableAttributedString(string: content, attributes: getAttributes(fontSize: 14.0))
        // let width = attString.width(containerHeight: 15)
        attString.draw(at: CGPoint(x: marginLeftRight, y: 20))
    }
    
    private func addBottomContent() {
        
        let content = """
    ----------------
    \(metaInfo.businessName)
    Contact: \(metaInfo.businessContact)
    Email: \(metaInfo.businessEmail)
    Address: \(metaInfo.businessAddress)
    ----------------
    Powered by CodeKunda, Kathmandu Nepal
    Author: prajeet.shrestha@gmail.com
    """
        let attString = NSMutableAttributedString(string: content, attributes: getAttributes(fontSize: 11.0))
        // let width = attString.width(containerHeight: 15)
        attString.draw(at: CGPoint(x: marginLeftRight, y: maxY + 8))
    }
    // Attribute of row items
    private func getAttributes(fontSize: CGFloat = 14.0) -> [NSAttributedString.Key : Any] {
        let contactTextFont = UIFont.systemFont(ofSize: fontSize, weight: .regular)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .natural
        paragraphStyle.lineBreakMode = .byWordWrapping
        let attribute = [
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            NSAttributedString.Key.font: contactTextFont
        ]
        return attribute
    }
}

