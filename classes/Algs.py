class Algs:
    def __init__(self):
        self.results = []
    
    def AverageReturns(self, stock):
        todaysPrice = float(stock.getPrice())
        yesterdaysPrice = float(stock.getPrevClose())
        return (todaysPrice - yesterdaysPrice) / yesterdaysPrice