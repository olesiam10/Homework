#!/usr/bin/env python

#import necessary libraries
# pip install flask 
#export FLASK_APP=flask-app
#flask run
from flask import Flask, json, render_template, request
import os
from bs4 import BeautifulSoup as bs
import requests

app = Flask(__name__)

@app.route("/")
def echo_hello():
    return "<p>Hello World!</p>"

@app.route("/all")
def scrape():
    url = 'https://www.yelp.com/search?find_desc=restaurants&find_loc=63110'
    response = requests.get(url)
    soup = bs(response.text, 'html.parser')
    results_list={}
    for item in soup.select('[class*=container]'):
        try:
            if item.find('h4'):
        
                for i in range(5):
                    name = item.find('h4').get_text()
                    #print(name)
                    reviews = soup.select('[class*=reviewCount]')[i].get_text()
                    rating=soup.select('[aria-label*=rating]')[i]['aria-label']
                    #print(rating)
                    snippet = soup.select('[class*= snippetTag]')[i].get_text()
                    #print(snippet)
                    price = soup.select('[class*=priceRange]')[i].get_text()
                    #print(price)
                    results={"name": name,
                    "reviews":reviews,
                    "rating":rating,
                    "snippet":snippet,
                    "price":price}
        
                    results_list.update(results)
        
        
        except AttributeError as e:
            print(e)

    return results




if __name__ == "__main__":
    app.run(debug=True)
