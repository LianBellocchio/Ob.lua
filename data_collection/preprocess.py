import os
import pandas as pd
from sklearn.preprocessing import StandardScaler


def preprocess_data(data_path):
    # Load data
    data = pd.read_csv(data_path)

    # Extract features and target variable
    X = data.drop(columns=["target"])
    y = data["target"]

    # Scale features
    scaler = StandardScaler()
    X_scaled = scaler.fit_transform(X)

    return X_scaled, y


if __name__ == '__main__':
    # Define path to data file
    data_path = os.path.join("data", "data.csv")

    # Preprocess data
    X, y = preprocess_data(data_path)

    # Save preprocessed data
    if not os.path.exists("processed_data"):
        os.mkdir("processed_data")

    # Save X and y as CSV files
    pd.DataFrame(X).to_csv("processed_data/X.csv", index=False)
    pd.DataFrame(y).to_csv("processed_data/y.csv", index=False)

    print("Preprocessing complete!")
