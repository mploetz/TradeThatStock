from classes.Stock import Stock
from classes.Algs import Algs

stock = Stock(Symbol="MSFT")

print(stock.GetTotalReturnsXMonths(5))