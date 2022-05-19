配置：
sympy
numpy
pymongo
flask
翻墙

脚本介绍：
爬虫： 
typhoon_crawler.py
typhoon_grab.py

typhoon_crawler调用typhoon_grab从JTWC网站抓数据，存入mongodb

计算与发送数据：
typhoon_main.py:台风路径计算主程序
typhoon_global_forecast_mongo.py:调用typhoon_main,并从mongodb中读数据存到内存
typhoon_forecast_api_backend.py:获取用户位置并将经纬度信息传送给typhoon_global_forecast_mongo.py
typhoon_forecast_api_foreend.py:flask封装typhoon_forecast_api_foreend.py

从网页端获取用户经纬度信息并将计算结果返回给用户
