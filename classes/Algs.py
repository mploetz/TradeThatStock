class Algs:
    def __init__(self):
        self.results = []
    
    def AverageReturns(self, stock):
        todaysPrice = stock.currentPrice
        yesterdaysPrice = stock.prevClose
        return (todaysPrice - yesterdaysPrice) / yesterdaysPrice