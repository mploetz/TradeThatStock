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
        self.endpoints = apiFile["alphaVantage"]["endPoints"]

    # Takes a string to search a stock by and returns an array of JSON best matches
    def Search(self, name):
        url = "https://www.alphavantage.co/query?"
        payload = { 'function': self.endpoints["Search"], 'keywords': name, 'apikey': self.data["alphaVantage"]["apiKey"], 'datatype': 'json'}
        r = requests.get(url, params=payload)
        return r.json()

print(API().Search("microsoft"))