import os
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import accuracy_score


def train_model(X, y):
    # Split data into training and testing sets
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

    # Train a random forest classifier
    clf = RandomForestClassifier(n_estimators=100, random_state=42)
    clf.fit(X_train, y_train)

    # Predict on test set and calculate accuracy
    y_pred = clf.predict(X_test)
    accuracy = accuracy_score(y_test, y_pred)

    return clf, accuracy


if __name__ == '__main__':
    # Load preprocessed data
    X = pd.read_csv(os.path.join("processed_data", "X.csv"))
    y = pd.read_csv(os.path.join("processed_data", "y.csv"))

    # Train model
    model, accuracy = train_model(X, y)

    # Print accuracy
    print("Accuracy:", accuracy)

    # Save model
    if not os.path.exists("models"):
        os.mkdir("models")

    model_path = os.path.join("models", "model.pkl")
    joblib.dump(model, model_path)

    print("Model training complete!")
