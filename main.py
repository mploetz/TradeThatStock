from classes.Stock import Stock
from classes.Algs import Algs

stock = Stock(Symbol='MFST')
Avg = Algs().AverageReturns(stock)
print(Avg)