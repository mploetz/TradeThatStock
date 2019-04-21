from datetime import datetime
import json
class Algs:
    def __init__(self):
        self.results = []
    
    def AverageReturns(self, stock):
        todaysPrice = float(stock.getPrice())
        yesterdaysPrice = float(stock.getPrevClose())
        return (todaysPrice - yesterdaysPrice) / yesterdaysPrice

    def TotalReturn(self, stockData, months):
        # Parse the JSON data to get the adjusted closing prices for the past @months
        # Get current query date
        queryDate = stockData["Meta Data"]["3. Last Refreshed"][:7] # grab only year and month (yyyy-mm)
        monthlyAdjustedData = stockData["Monthly Adjusted Time Series"]
        currentMonth = queryDate[6:] if "0" in queryDate[5:] else queryDate[5:]
        monthKeys = list(stockData["Monthly Adjusted Time Series"].keys())[:months]

        dataSet = []

        for month in monthKeys:
            dataSet.append(monthlyAdjustedData[month])

        print(dataSet)
        print(dataSet[0]["5. adjusted close"])
        P1 = float(dataSet[0]["5. adjusted close"])
        P0 = float(dataSet[len(dataSet)-1]["5. adjusted close"])
        print(P1)
        print(P0)

        return (P1 - P0) / P0