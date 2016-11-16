from flask import Flask, current_app
from flask import jsonify, redirect, url_for, escape
from flask import request, session
from flask import render_template
from flask import g as Globals


app = Flask(__name__, static_url_path='')
app.model = 0

@app.route('/')
def index():
    return render_template('index.html', name="Sam")


@app.route('/api', methods=['POST'])
def api():
    blob = request.get_json()
    app.model = update(blob, app.model)

    return jsonify({
        'model': app.model
    })


app.secret_key = ''


if __name__ == "__main__":
    app.run(debug=True)
