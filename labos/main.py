from flask import Flask, Response
from datetime import datetime

app = Flask(__name__)

def change_text_file():
    # Get current day of the week and date with EU format
    day_of_week = datetime.today().strftime('%A')
    current_date = datetime.today().strftime('%d/%m/%Y')

    # Open the original file to rw its contents
    with open("output.txt", "r+") as file:
        text = file.read()
        text = text.replace("[DAY_OF_WEEK]", day_of_week)
        text = text.replace("[CURRENT_DATE]", current_date)
        file.seek(0)
        file.write(text)

    return text

#flask
@app.route('/')
def index():
    text = change_text_file()
    return Response(text, mimetype='text/plain')

#trigger app
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
