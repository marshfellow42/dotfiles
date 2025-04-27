#!/usr/bin/env python3

import urllib.request
import json

# Mapping of condition text to emoji / nerd font icon
WEATHER_ICONS = {
    "Clear": "☀️",
    "Sunny": "☀️",
    "Partly cloudy": "⛅",
    "Cloudy": "☁️",
    "Overcast": "☁️",
    "Mist": "🌫️",
    "Fog": "🌫️",
    "Freezing fog": "🌫️",
    "Patchy rain nearby": "🌧️",
    "Patchy rain possible": "🌧️",
    "Rain": "🌧️",
    "Light rain": "🌦️",
    "Patchy light rain": "🌦️",
    "Moderate rain at times": "🌧️",
    "Moderate rain": "🌧️",
    "Heavy rain at times": "🌧️",
    "Heavy rain": "🌧️",
    "Patchy snow possible": "❄️",
    "Snow": "❄️",
    "Light snow": "🌨️",
    "Patchy light snow": "🌨️",
    "Moderate snow": "🌨️",
    "Heavy snow": "❄️",
    "Patchy sleet possible": "🌨️",
    "Sleet": "🌨️",
    "Light sleet": "🌨️",
    "Moderate or heavy sleet": "🌨️",
    "Patchy freezing drizzle possible": "🧊",
    "Freezing drizzle": "🧊",
    "Light freezing rain": "🧊",
    "Moderate or heavy freezing rain": "🧊",
    "Ice pellets": "🧊",
    "Thundery outbreaks in nearby": "⛈️",
    "Thundery outbreaks possible": "⛈️",
    "Light rain shower": "🌦️",
    "Moderate or heavy rain shower": "🌧️",
    "Torrential rain shower": "🌧️",
    "Light sleet showers": "🌨️",
    "Moderate or heavy sleet showers": "🌨️",
    "Light snow showers": "🌨️",
    "Moderate or heavy snow showers": "🌨️",
    "Patchy light rain with thunder": "⛈️",
    "Moderate or heavy rain with thunder": "⛈️",
    "Moderate or heavy rain in area with thunder": "⛈️",
    "Patchy light snow with thunder": "🌩️",
    "Moderate or heavy snow with thunder": "🌩️",
    "Moderate or heavy snow in area with thunder": "🌩️",
    "default": "🌈"
}

DEFAULT_ICON = "🌈"

def fetch(url):
    try:
        with urllib.request.urlopen(url, timeout=5) as response:
            return response.read().decode('utf-8').strip()
    except Exception:
        return None

def main():
    temperature_url = "https://wttr.in/?format=%t"
    condition_text_url = "https://wttr.in/?format=%C"  # Get readable condition

    temperature = fetch(temperature_url)
    condition_text = fetch(condition_text_url)

    if temperature is None or condition_text is None:
        output = {
            "text": "N/A",
            "icon": DEFAULT_ICON
        }
    else:
        icon = WEATHER_ICONS.get(condition_text, DEFAULT_ICON)
        output = {
            "text": temperature,
            "icon": icon
        }

    print(json.dumps(output))

if __name__ == "__main__":
    main()
