import scraping
import preprocess
import trainingmodel
import os

# Lista de nombres de campeones para scrapeo
champion_names = [
    'Aatrox', 'Ahri', 'Akali', 'Alistar', 'Amumu', 'Anivia', 'Annie',
    'Aphelios', 'Ashe', 'Aurelion Sol', 'Azir', 'Bard', 'Blitzcrank',
    'Brand', 'Braum', 'Caitlyn', 'Camille', 'Cassiopeia', 'Cho\'Gath',
    'Corki', 'Darius', 'Diana', 'Dr. Mundo', 'Draven', 'Ekko', 'Elise',
    'Evelynn', 'Ezreal', 'Fiddlesticks', 'Fiora', 'Fizz', 'Galio',
    'Gangplank', 'Garen', 'Gnar', 'Gragas', 'Graves', 'Hecarim',
    'Heimerdinger', 'Illaoi', 'Irelia', 'Ivern', 'Janna', 'Jarvan IV',
    'Jax', 'Jayce', 'Jhin', 'Jinx', 'Kai\'Sa', 'Kalista', 'Karma',
    'Karthus', 'Kassadin', 'Katarina', 'Kayle', 'Kayn', 'Kennen',
    'Kha\'Zix', 'Kindred', 'Kled', 'Kog\'Maw', 'LeBlanc', 'Lee Sin',
    'Leona', 'Lillia', 'Lissandra', 'Lucian', 'Lulu', 'Lux', 'Malphite',
    'Malzahar', 'Maokai', 'Master Yi', 'Miss Fortune', 'Mordekaiser',
    'Morgana', 'Nami', 'Nasus', 'Nautilus', 'Neeko', 'Nidalee',
    'Nocturne', 'Nunu & Willump', 'Olaf', 'Orianna', 'Ornn', 'Pantheon',
    'Poppy', 'Pyke', 'Qiyana', 'Quinn', 'Rakan', 'Rammus', 'Rek\'Sai',
    'Rell', 'Renekton', 'Rengar', 'Riven', 'Rumble', 'Ryze', 'Samira',
    'Sejuani', 'Senna', 'Seraphine', 'Sett', 'Shaco', 'Shen',
    'Shyvana', 'Singed', 'Sion', 'Sivir', 'Skarner', 'Sona', 'Soraka',
    'Swain', 'Sylas', 'Syndra', 'Tahm Kench', 'Taliyah', 'Talon',
    'Taric', 'Teemo', 'Thresh', 'Tristana', 'Trundle', 'Tryndamere',
    'Twisted Fate', 'Twitch', 'Udyr', 'Urgot', 'Varus', 'Vayne',
    'Veigar', 'Vel\'Koz', 'Vi', 'Viego', 'Viktor', 'Vladimir',
    'Volibear', 'Warwick', 'Wukong', 'Xayah', 'Xerath', 'Xin Zhao',
    'Yasuo', 'Yone', 'Yorick', 'Yuumi', 'Zed', 'Zeri', 'Ziggs', 'Zilean'
    'Zoe', 'Zyra']

if __name__ == '__main__':
    # Scrape data from u.gg
    champion_names = [...]  # list of champion names goes here
    data_directory = os.path.join(os.getcwd(), 'data')
    for champion_name in champion_names:
        champion_data = scraping.get_data(champion_name)
        preprocess.preprocess_data(champion_data, data_directory)
    
    # Train model
    trainingmodel.train_model(data_directory)
