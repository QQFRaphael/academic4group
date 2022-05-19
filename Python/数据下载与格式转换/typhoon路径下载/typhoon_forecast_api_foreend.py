# -*- coding: utf-8 -*-
"""
Created on Wed Jul 22 15:49:21 2015
test
@author: qzhang
"""
import numpy as np
from typhoon_forecast_api_backend import typhoon_api
from flask import Flask
from flask import jsonify
app = Flask(__name__)
@app.route('/<float:lat>,<float:lon>')
def typhoon(lat,lon):
        userlocation=np.asarray([lat,lon])
        return jsonify(typhoon_api(userlocation))
if __name__ == '__main__':
    app.run(debug=True)
