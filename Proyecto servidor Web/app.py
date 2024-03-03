from flask import Flask, render_template, request, redirect, url_for
import utils

app = Flask(__name__)

@app.route('/')
def home():
    server_status = utils.get_server_status()
    return render_template('home.html', status=server_status)

@app.route('/console')
def console():
    return render_template('console.html')

@app.route('/console_cmd', methods=['POST'])
def execute_cmd():
    cmd = request.form['cmd']
    output = utils.execute_command(cmd)
    return output 

@app.route('/files')
def files():
    files = utils.list_files()
    return render_template('files.html', files=files)

@app.route('/tasks')
def tasks():
    tasks = utils.get_cron_tasks()
    return render_template('tasks.html', tasks=tasks)
  
# ...more routes   

if __name__ == '__main__':
  app.run(host='0.0.0.0', port=5000)