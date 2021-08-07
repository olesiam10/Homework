from flask import Flask, render_template
from flask_pymongo import PyMongo

app = Flask(__name__)

#setup mongo connection
app.config["MONGO_URI"] = "mongodb://localhost:27017/shows_db"
mongo = PyMongo(app)

#connect to collection
tv_shows = mongo.db.tv_shows

#READ
@app.route("/")
def index():
    #find all items in db and save to variable
    all_shows = list(tv_shows.find())
    print(all_shows)

    return render_template("index.html",data=all_shows)


@app.route("/create")
def create_records():
    show_name = input('What is the show name? ')
    seasons = input('Number of Seasons: ')
    duration = input('How long is each show? ')
    year = input('What year did the show start? ')
    post_data = {'name':show_name,
             'seasons':seasons,
             'duration':duration,
             'year':year,
             #'date_added':datetime.datetime.utcnow()
            }
    tv_shows.insert_one(post_data)
    return render_template('index.html',data=post_data)

@app.route("/delete")
def delete_show():
    all_shows = list(tv_shows.find())
    to_delete = input('Which record would you like to delete?')
    tv_shows.delete_one({'name': to_delete})

    return render_template("index.html",data=all_shows)


@app.route("/update")
def update_seasons():
    all_shows = list(tv_shows.find())
    key=input('Which record would you like to update?')
    newValue = input('Enter a new # of seasons')
    newvalues = { "$set": { "seasons": newValue } }

    tv_shows.update_one({ "name" : key }, newvalues)

    return render_template("index.html",data=all_shows)




if __name__ == "__main__":
    app.run(debug=True)