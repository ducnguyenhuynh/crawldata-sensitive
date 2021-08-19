import requests
from bs4 import BeautifulSoup
subtree = {}

def get_subtree(link):
    result = requests.get(link)
    print(result.content)

if __name__ == "__main__":
    with open ("root_link.tab", "r") as rlink:
        links = rlink.readlines()
     
    get_subtree(links[0])
    # for l in links:
    #     subtree.update{l : }