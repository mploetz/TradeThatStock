from googlefinance.get import get_code
from googlefinance.get import get_datum
from googlefinance.get import get_data
from classes.api_requests import API
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

    def getPrice(self):
        api = API()
        if (self.Name is not ""):
            self.Symbol = api.Search(self.Name).bestMatches[0]
            quote = api.GetQuote(self.Symbol)

            return quote["Global Quote"]['05. price']
        elif (self.Symbol is not ""):
            quote = api.GetQuote(self.Symbol)
            return quote["Global Quote"]['05. price']
        return "No Price Found"
    
    def getPrevClose(self):
        api = API()
        if (self.Name is not ""):
            self.Symbol = api.Search(self.Name).bestMatches[0]
            quote = api.GetQuote(self.Symbol)

            return quote["Global Quote"]['08. previous close']
        elif (self.Symbol is not ""):
            quote = api.GetQuote(self.Symbol)
            return quote["Global Quote"]['08. previous close']
        return "No Price Found"
