from flask import Flask, jsonify
import requests
from bs4 import BeautifulSoup

app = Flask(__name__)

def fetch_bridge_status(url):
    response = requests.get(url)
    if response.status_code == 200:
        soup = BeautifulSoup(response.text, 'html.parser')
        # Find the first bridge-item
        first_bridge_item = soup.find('div', class_='bridge-item')
        if first_bridge_item:
            # Extract all h1 tags with the class 'status-title' within the first bridge-item
            status_titles = [h1.get_text(strip=True) for h1 in first_bridge_item.find_all('h1', class_='status-title')]
            first_item_data = first_bridge_item.find('p', class_='item-data').get_text(strip=True) if first_bridge_item.find('p', class_='item-data') else 'No item data found'
            item_title_banner = first_bridge_item.find('div', class_='item-title-banner')
            if item_title_banner and 'style' in item_title_banner.attrs:
                # Extracting the style attribute
                style = item_title_banner['style']
                # Splitting the style attribute to find the background-color value
                background_color = next((s.split(':')[1].strip() for s in style.split(';') if 'background-color' in s), None)
            else:
                background_color = None
            return status_titles, first_item_data, background_color
    return None, None

@app.route('/get_bridge_status')
def get_bridge_status_api():
    url = "https://www.seaway-greatlakes.com/bridgestatus/detailsmai2?key=BridgeSBS"
    status_titles, first_item_data, background_color = fetch_bridge_status(url)

    if status_titles is not None and first_item_data is not None:
        return jsonify({
            'status_titles': status_titles,
            'first_item_data': first_item_data,
            'background_color': background_color
        })
    else:
        return jsonify({'error': 'Failed to retrieve content'}), 500

if __name__ == '__main__':
    app.run(debug=True)  # Set debug=False in a production environment
