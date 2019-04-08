from googlefinance.get import get_code
from googlefinance.get import get_datum
from googlefinance.get import get_data
from api_requests import API

# Stock has:
# -Name
# -Price
# -Historical Data
class Stock:

    def __init__(self, Name, data):
        self.data = []
        self.Name = ""
        self.Symbol = API().search(Name)

    def getPrice(self):
        api = API().data
        return 10