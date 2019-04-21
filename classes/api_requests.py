import json
import requests
import os
# This file will handle the parsing and sending of api_requests called when getting data or searching for a specific Stock

class API:
    def __init__(self):
        # Load in our api keys
        cwd = os.getcwd()
        file = open(cwd + '\\classes\\api_keys.json')
        apiFile = json.load(file)
        self.data = apiFile
        self.url = apiFile["alphaVantage"]["url"]
        self.endpoints = apiFile["alphaVantage"]["endPoints"]

    # @params String symbol, String interval, String outputsize
    # @returns JSON of intraday values for stock
    def IntraDay(self, symbol, interval, outputsize):
        payload = {'function': self.endpoints["IntraDay"], 'symbol': symbol, 'interval': interval, 'apikey': self.data["alphaVantage"]["apiKey"], 'datatype': 'json'}
        r = requests.get(self.url, params=payload)

        return r.json()


    def MonthlyAdjusted(self, symbol):
        payload = {'function': self.endpoints['MonthlyAdjusted'], 'symbol': symbol, 'apikey': self.data["alphaVantage"]["apiKey"], 'datatype': 'json'}
        r = requests.get(self.url, params=payload)

        return r.json()

    # Takes a string to search a stock by and returns an array of JSON best matches
    def Search(self, name):
        payload = { 'function': self.endpoints["Search"], 'keywords': name, 'apikey': self.data["alphaVantage"]["apiKey"], 'datatype': 'json'}
        r = requests.get(self.url, params=payload)
        return r.json()

    # @params: String symbol
    # @returns: JSON containing Stock information like closing price, yesterday price, high, low etc
    def GetQuote(self, symbol):
        payload = {'function': self.endpoints['Quote'], 'symbol': symbol, 'apikey': self.data["alphaVantage"]["apiKey"], 'datatype': 'json'}
        r = requests.get(self.url, params=payload)
        return r.json()