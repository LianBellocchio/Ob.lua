import requests
from bs4 import BeautifulSoup

def scrape_champion_data(champion_name):
    """
    Scrapes data for a specific champion from u.gg.

    Parameters:
        champion_name (str): The name of the champion to scrape data for.

    Returns:
        champion_data (dict): A dictionary containing the scraped data for the champion.
    """
    # Construct the URL for the champion's page on u.gg
    url = f"https://u.gg/lol/champions/{champion_name}/build"
    
    # Make a request to the URL and get the HTML response
    response = requests.get(url)
    html = response.content
    
    # Parse the HTML with BeautifulSoup
    soup = BeautifulSoup(html, "html.parser")
    
    # Extract the relevant data from the page and store it in a dictionary
    champion_data = {}
    # TODO: add code to extract data from the page and store it in champion_data
    
    return champion_data
