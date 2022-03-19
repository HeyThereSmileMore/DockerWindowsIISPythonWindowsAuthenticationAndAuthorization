from flask import Flask
from flask import request

app = Flask(__name__)

@app.route("/")
def home():
    username = request.environ.get('REMOTE_USER')
    return username

@app.route('/hello')
def hello():
    return 'Hello, World'

if __name__=='__main__':
    app.run(debug=True)