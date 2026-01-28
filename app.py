from flask import Flask, redirect, render_template, url_for, request
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

@app.route('/login',methods = ['POST','GET'])
def login():
    if request.method == 'POST':
        print('Post funcionou')
        email = request.form.get('email')
        senha = request.form.get('senha')
        print(email,senha)

        conexao = conectar_banco()
        cursor = conexao.cursor(dictionary=True)
        sql = "SELECT * FROM usuarios WHERE email = %s"

        cursor.execute(sql, (email,))
        usuario = cursor.fetchone()

        if usuario:
            if senha == usuario['senha_hash']:
                print('Email e senha corretos')
                return redirect(url_for('dashboard'))
            else:
                print('Senha errada')
        else:
            print('email errado')
        cursor.close()
        conexao.close()

    return render_template('login.html')

@app.route('/dashboard')
def dashboard():
    return 'Página do dashboard'

if __name__ == "__main__":
    app.run(debug=True)
