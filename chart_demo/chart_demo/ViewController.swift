import UIKit
import Charts

class ViewController: UIViewController {
    
    @IBOutlet weak var barChart: BarChartView!
    @IBOutlet weak var txtTextBox: UITextField!
    @IBOutlet weak var chtChart: LineChartView!
    
    var months: [String]!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        
        setChart()
    }
    
    //bar_graph
    func setChart()
    {
        let unitsSold = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0, 4.0, 18.0, 2.0, 4.0, 5.0, 4.0]
        
        let test = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
        
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<months.count
        {
            let dataEntry = BarChartDataEntry(x: Double(test[i]), y: Double(unitsSold[i]))
            
            dataEntries.append(dataEntry)
        }
        
        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "Visitor count")
        let chartData = BarChartData(dataSet: chartDataSet)
        
        barChart.data = chartData
    }
    
    //linechart
    @IBAction func btnbutton(_ sender: Any) {
        let input  = Double(txtTextBox.text!) //gets input from the textbox - expects input as double/int
        
        numbers.append(input!) //here we add the data to the array.
        updateGraph()
    }
    
    var numbers : [Double] = []
    var duration = 30
    
    func updateGraph(){
        var lineChartEntry  = [ChartDataEntry]() //this is the Array that will eventually be displayed on the graph.
        var display_length  = 0
        if (self.numbers.count > duration)
            {
            display_length = self.numbers.count - duration
            }
        //here is the for loop
        for i in display_length..<numbers.count {
            
            let value = ChartDataEntry(x: Double(i), y: numbers[i]) // here we set the X and Y status in a data chart entry
            lineChartEntry.append(value) // here we add it to the data set
        }
        
        let line1 = LineChartDataSet(entries: lineChartEntry, label: "Number") //Here we convert lineChartEntry to a LineChartDataSet
        line1.colors = [NSUIColor.blue] //Sets the colour to blue
        
        let data = LineChartData() //This is the object that will be added to the chart
        data.addDataSet(line1) //Adds the line to the dataSet
        
        
        chtChart.data = data //finally - it adds the chart data to the chart and causes an update
        chtChart.chartDescription?.text = "My awesome chart" // Here we set the description for the graph
    }

}
