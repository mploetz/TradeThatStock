import json
import requests
import os
# This file will handle the parsing and sending of api_requests called when getting data or searching for a specific Stock

class API:
    def __init__(self):
        # Load in our api keys
        cwd = os.getcwd()
        apiFile = open(cwd + '\\classes\\api_keys.json')
        self.data = apiFile.read()