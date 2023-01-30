from flask import Flask, Response
from datetime import datetime

app = Flask(__name__)

def change_text_file():
    # Get current day of the week and date with EU format
    day_of_week = datetime.today().strftime('%A')
    current_date = datetime.today().strftime('%d/%m/%Y')

    # Open the original file to r its contents
    with open("template.txt", "r") as file:
        text = file.read()
        text = text.replace("[DAY_OF_WEEK]", day_of_week)
        text = text.replace("[CURRENT_DATE]", current_date)
    # write log access at EOF
    with open("log.txt", "a+") as log:
            log.write(text)
    with open("log.txt", "r") as log:
            log_text = log.read()
    return log_text


#flask
@app.route('/')
def index():
    log_text = change_text_file()
    return Response(log_text, mimetype='text/plain')

#trigger app
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)