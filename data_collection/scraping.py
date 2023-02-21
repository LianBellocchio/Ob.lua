import requests
from bs4 import BeautifulSoup
import csv
import time


def get_data(champion_name):
    url = f'https://u.gg/lol/champions/{champion_name}/build'
    page = requests.get(url)
    soup = BeautifulSoup(page.content, 'html.parser')
    
    # Obtener el nombre del campeón
    champion_name = soup.find('h1', class_='champion-name').text.strip()

    # Obtener la tabla de win rate
    table = soup.find('table', class_='champion-overview__table champion-overview__table--all')
    
    rows = table.find_all('tr')
    
    data = []
    for row in rows[1:]:
        cols = row.find_all('td')
        role = cols[0].text.strip()
        pick_rate = cols[1].text.strip()
        ban_rate = cols[2].text.strip()
        win_rate = cols[3].text.strip()
        data.append((champion_name, role, pick_rate, ban_rate, win_rate))
    
    return data


def save_data(data):
    with open('data.csv', 'a', newline='', encoding='utf-8') as f:
        writer = csv.writer(f)
        writer.writerows(data)


if __name__ == '__main__':
    champion_names = ["Aatrox", "Ahri", "Akali", "Alistar", "Amumu", "Anivia", "Annie", "Aphelios", "Ashe", "AurelionSol","Azir", "Bard", "Blitzcrank", "Brand", "Braum", "Caitlyn", "Camille", "Cassiopeia", "ChoGath", "Corki", "Darius", "Diana", "DrMundo", "Draven", "Ekko", "Elise", "Evelynn", "Ezreal", "Fiddlesticks","Fiora", "Fizz", "Galio", "Gangplank", "Garen", "Gnar", "Gragas", "Graves", "Hecarim", "Heimerdinger", "Illaoi", "Irelia", "Ivern", "Janna", "JarvanIV", "Jax", "Jayce", "Jhin", "Jinx", "KaiSa", "Kalista","Karma", "Karthus", "Kassadin", "Katarina", "Kayle", "Kayn", "Kennen", "KhaZix", "Kindred", "Kled","KogMaw", "LeBlanc", "LeeSin", "Leona", "Lillia", "Lissandra", "Lucian", "Lulu", "Lux", "Malphite","Malzahar", "Maokai", "MasterYi", "MissFortune", "Mordekaiser", "Morgana", "Nami", "Nasus", "Nautilus","Neeko", "Nidalee", "Nocturne", "Nunu", "Olaf", "Orianna", "Ornn", "Pantheon", "Poppy", "Pyke", "Qiyana", "Quinn", "Rakan", "Rammus", "RekSai", "Rell", "Renekton", "Rengar", "Riven", "Rumble","Ryze", "Samira", "Sejuani", "Senna", "Seraphine", "Sett", "Shaco", "Shen", "Shyvana", "Singed","Sion", "Sivir", "Skarner", "Sona", "Soraka", "Swain", "Sylas", "Syndra", "TahmKench", "Taliyah","Talon", "Taric", "Teemo", "Thresh", "Tristana", "Trundle", "Tryndamere", "TwistedFate", "Twitch","Udyr", "Urgot", "Varus", "Vayne", "Veigar", "VelKoz", "Vi", "Viego", "Viktor", "Vladimir", "Volibear","Warwick", "Wukong", "Xayah", "Xerath", "XinZhao", "Yasuo", "Yone", "Yorick", "Yuumi""Zac", "Zed", "Zeri", "Ziggs", "Zilean", "Zoe", "Zyra"]
    scraper = Scraper()
    df = pd.DataFrame(columns=['Champion', 'Role', 'Winrate', 'Pickrate', 'Banrate'])

    # Collect data for each champion
    for champion_name in champion_names:
        # Scrape data from u.gg
        champion_data = scraper.scrape(champion_name)

        # Add data to the dataframe
        for role_data in champion_data:
            df = df.append({'Champion': champion_name,
                            'Role': role_data['role'],
                            'Winrate': role_data['winrate'],
                            'Pickrate': role_data['pickrate'],
                            'Banrate': role_data['banrate']}, ignore_index=True)

    # Preprocess the data
    preprocessor = Preprocessor()
    X, y = preprocessor.preprocess(df)

    # Train the model
    model_trainer = ModelTrainer()
    model = model_trainer.train(X, y)

    # Save the model
    model_trainer.save_model(model, 'orbwalker_model.pkl')