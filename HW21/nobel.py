#!/usr/bin/env python

#import necessary libraries
# pip install flask 
#export FLASK_APP=flask-app
#flask run
from flask import Flask, json, render_template, request
import os

#create instance of Flask app
app = Flask(__name__)

#decorator 
@app.route("/")
def echo_hello():
    return "<p>Hello World!</p>"

@app.route("/all")
def nobel():
    json_url = os.path.join(app.static_folder,"","nobel.json")
    data_json = json.load(open(json_url))
    #render_template is always looking in templates folder
    return render_template('index.html',data=data_json)

@app.route("/<year>", methods=['GET', 'POST'])
def nobel_year(year):
    json_url = os.path.join(app.static_folder,"","nobel.json")
    data_json = json.load(open(json_url))
    data=data_json.items()
    for key, value in data:
        output_data = [x for x in value if x['year']==year]
    return render_template('index.html',data=output_data)


@app.route('/add', methods = ['POST'])
def add():
    req_data=request.get_json()
    year = req_data["year"]
    category = req_data["category"]
    my_id = req_data["laureauts"]["id"]
    firstname = req_data["laureauts"]["firstname"]
    surname = req_data["laureauts"]["surname"]
    motivation = req_data["laureauts"]["motivation"]

    with open('nobel.json', 'r+') as file:
        file_data=json.load(file)
        file_data['prizes'].append(req_data)
        
        with open(filename, "w") as file:
            json.dump(data, file)
        

    
#I was just trying different things in all these other functions

@app.route("/data")
def data():
    name=request.args.get('name')
    #return '<h1> The new element is {} </h1>'.format(name)
    return name


@app.route("/new", methods=['POST'])
def addnew():
    if request.method == 'POST':
        category = request.form["category"]
        id = request.form["id"]
        first_name=request.form["firstname"]
        last_name=request.form["lastname"]
        share=request.form["share"]
        
        return request.form

@app.route('/form-example', methods=['GET', 'POST'])
def form_example():
    return '''
              <form method="POST">
                  <div><label>year: <input type="text" name="year"></label></div>
                  <div><label>category: <input type="text" name="category"></label></div>
                  <input type="submit" value="Submit">
              </form>'''


@app.route('/add_data', methods=['POST', 'GET'])
def add_data():
    json_url = os.path.join(app.static_folder,"","nobel.json")
    data_json = json.load(open(json_url))
    # force=True, above, is necessary if another developer 
    # forgot to set the MIME type to 'application/json'
    #print ('data from client:', input_json)
    # dictToReturn = {'name': 32}
    data=data_json.items()
    #print (type(data))
    # print(data)
    for key, value in data:
        for element in value:
            element['new_value'] = 'balto'
        # output_data = [(x['new_value']=='loop de doop') for x in value]

        # new_dict = {'hello': 4}
        # print(value[0])
        # new = value[0][(new_dict)]
    return data_json



if __name__ == "__main__":
    app.run(debug=True)