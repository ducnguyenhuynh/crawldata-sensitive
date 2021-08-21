import pandas as pd

if __name__ == "__main__":
    database = pd.read_csv("./database.csv",sep="\t")
    print(database)
    print(database.keys())