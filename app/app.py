from flask import Flask, request, jsonify, render_template
import requests
import os
from dotenv import load_dotenv

load_dotenv()

app = Flask(__name__)

API_KEY = os.getenv('OPENWEATHERMAP')
BASE_URL = "http://api.openweathermap.org/data/2.5/forecast"


@app.route('/', methods=['GET'])
def index():
    return render_template('index.html')

@app.route('/onecall', methods=['GET'])

def get_weather():
    lat = request.args.get('lat')
    long = request.args.get('lon')
    
    if not lat or not long:
        return jsonify({"error": "Latitud y Longitud es un campo obligatorio"}), 400
    
    params = {
        'lat': lat,
        'lon': long,
        'appid': API_KEY,
        'units': 'metric'
    }
    
    try:
        
        response = requests.get(BASE_URL, params=params)
        data = response.json()
        LastForecast = data['list'][0]
        
        if response.status_code != 200:
            return jsonify({"error": data.get("message", "ERROR fetching data")}),response.status_code
    
        weather_data= {
            'city': data['city']['name'],
            'temperature': LastForecast['main']['temp'],
            'humidity': LastForecast['main']['humidity'],
            'weather': LastForecast['weather'][0]['description'],
            'wind_speed': LastForecast['wind']['speed']
        }
    
        return render_template('index.html', weather=weather_data)

    except requests.exceptions.RequestException as err:
        return jsonify({"error": str(err)}), 500
    
if __name__ == 'main':
    app.run(debug=True)