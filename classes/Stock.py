from googlefinance.get import get_code
from googlefinance.get import get_datum
from googlefinance.get import get_data
from classes.api_requests import API
from classes.Algs import Algs
import json

# Stock has:
# -Name
# -Price
# -Historical Data
class Stock:

    def __init__(self, Name="", data=[], Symbol=""):
        self.data = data
        self.Name = Name
        self.Symbol = Symbol

    # @params: String interval
    # @returns: Total Returns of given interval
    # Set outputsize to "full" for most details
    def GetIntraDay(self, interval, outputsize):
        api = API()
        data = api.IntraDay(self.Symbol, interval, outputsize)

        return data

    def GetPrice(self):
        api = API()
        if (self.Name is not ""):
            self.Symbol = api.Search(self.Name).bestMatches[0]
            quote = api.GetQuote(self.Symbol)

            return quote["Global Quote"]['05. price']
        elif (self.Symbol is not ""):
            quote = api.GetQuote(self.Symbol)
            return quote["Global Quote"]['05. price']
        return "No Price Found"
    
    def GetTotalReturnsXMonths(self, months):
        api = API()
        data = api.MonthlyAdjusted(self.Symbol)        

        return Algs().TotalReturn(data, months)

    def GetPrevClose(self):
        api = API()
        if (self.Name is not ""):
            self.Symbol = api.Search(self.Name).bestMatches[0]
            quote = api.GetQuote(self.Symbol)

            return quote["Global Quote"]['08. previous close']
        elif (self.Symbol is not ""):
            quote = api.GetQuote(self.Symbol)
            return quote["Global Quote"]['08. previous close']
        return "No Price Found"
