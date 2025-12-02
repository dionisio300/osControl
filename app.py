from flask import Flask, render_template, url_for
from dotenv import load_dotenv
import mysql.connector
import os

load_dotenv()

def conectar_banco():
    return mysql.connector.connect(
        host=os.getenv("DB_HOST"),
        user=os.getenv("DB_USER"),
        password=os.getenv("DB_PASSWORD"),
        database=os.getenv("DB_NAME"),
        auth_plugin="mysql_native_password"
    )

app = Flask(__name__)
app.secret_key = os.getenv("FLASK_SECRET_KEY", "1234")

@app.route("/")
def index():
    return render_template('index.html')

@app.route('/login')
def login():
    return render_template('login.html')

if __name__ == "__main__":
    app.run(debug=True)
