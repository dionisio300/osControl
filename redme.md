Passos da aula
Confirma o deslog do github dos outros
logar no proprio
baixar o repositório do projeto final
baixar o meu repositório
copiar os arquivos para o deles
atualizar o deles
subir as atualizações para o PA
fazer o .env do PA e colocar no wsgi
e comemorar




PASSO 1 — Criar o arquivo .env no PythonAnywhere

O .env NÃO vai automático pelo GitHub, porque ele está (ou deve estar) no .gitignore.

Então os alunos precisam criar o .env manualmente no PA:

No painel do PythonAnywhere:

Vá em “Files”

Entre na pasta do projeto

Clique em “New File”

Nomeie como .env

Cole as variáveis (ajustando para o banco deles):

Exemplo:

FLASK_SECRET_KEY=qualquercoisa
DB_HOST=seu_usuario.mysql.pythonanywhere-services.com
DB_USER=seu_usuario
DB_PASSWORD=sua_senha_mysql
DB_NAME=oscontrol
FLASK_DEBUG=False


Obs:
DB_HOST sempre segue o formato:
seuusuario.mysql.pythonanywhere-services.com

========================================
PASSO 2 — Configurar o WSGI para carregar o dotenv

O PA não carrega automaticamente o dotenv como no terminal local.
Então tem que colocar isso no arquivo WSGI.

No painel:
Web → Vá até o arquivo wsgi.py → editar.

Adicionar logo no topo:

import os
from dotenv import load_dotenv

project_folder = os.path.expanduser('~/seu_repositorio/projeto')  # ajustar caminho
load_dotenv(os.path.join(project_folder, '.env'))


Troque seu_repositorio/projeto pelo caminho real onde o app está.

(O PA mostra o caminho no próprio painel “Files”.)

========================================
PASSO 3 — Configurar a rota do Flask no Web tab

Também na aba Web:

– WSGI configuration file: apontar para o arquivo que você acabou de editar
– Working directory: colocar a pasta onde está o app.py
– Python version: 3.10 ou 3.11
– No campo "WSGI file", garantir que from app import app as application esteja correto
(ou o nome do seu arquivo principal)

========================================
PASSO 4 — Instalar dependências no Bash Console

No console do PythonAnywhere:

pip install -r requirements.txt

========================================
PASSO 5 — Reiniciar o site

Sempre que mudar algo, clicar no botão:

"Reload"