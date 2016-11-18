from flask import Flask, current_app
from flask import jsonify, redirect, url_for, escape
from flask import request, session
from flask import render_template
from flask import g as Globals

from utils.twitter import analyze_tweets


app = Flask(__name__, static_url_path='')

@app.route('/')
def index():
    return render_template('index.html', tweets = None)

@app.route('/analyze', methods=['POST'])
def analyze():
    term = request.form['term']
    tweets = analyze_tweets(term)
    return render_template('index.html', tweets = tweets)

@app.route('/api', methods=['GET', 'POST'])
def api():
    # blob = request.get_json()

    return jsonify({
        'name': 'chris'
    })

# app.secret_key = ''


if __name__ == "__main__":
    app.run(debug=True)
