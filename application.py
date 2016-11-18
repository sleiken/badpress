from flask import Flask, current_app
from flask import jsonify, redirect, url_for, escape
from flask import request, session
from flask import render_template
from flask import g as Globals

from utils.twitter import analyze_tweets


app = Flask(__name__)

@app.route('/')
def index():
    return render_template('index.html', tweets = None)

@app.route('/analyze', methods=['POST'])
def analyze():
    term = request.form['term']
    tweets = analyze_tweets(term)
    return render_template('index.html', tweets = tweets)

@app.route('/api', methods=['POST'])
def api():
    blob = request.data
    analysis = analyze_tweets(blob)

    return jsonify({
        'positivity': analysis[0],
        'subjectivity': analysis[1]
    })

# app.secret_key = ''


if __name__ == "__main__":
    app.run(debug=True)
