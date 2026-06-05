import requests
import pandas as pd
from datetime import datetime




usuarios_url = "https://jsonplaceholder.typicode.com/users"
posts_url = "https://jsonplaceholder.typicode.com/posts"

def fetch_usuarios() -> list[dict]:

    try:
        response = requests.get(usuarios_url, timeout=30)
        response.raise_for_status()
        return response.json()[:10]  # limite de 10 usuários
    except requests.exceptions.RequestException as e:
        print(f"Erro ao buscar usuários: {e}")
        return []

def fetch_posts() -> list[dict]:
    try:
        response = requests.get(posts_url, timeout=30)
        response.raise_for_status()
        return response.json()[:10]  # limite de 10 posts
    except requests.exceptions.RequestException as e:
        print(f"Erro ao buscar posts: {e}")
        return []
    
def flatten_usuario(usuario: dict) -> dict:
    usuario_flat = {}

    for chave, valor in usuario.items():
        
        if isinstance(valor, dict):

            for sub_chave, sub_valor in valor.items():
                usuario_flat[f"{chave}_{sub_chave}"] = sub_valor
        else:
            usuario_flat[chave] = valor

    return usuario_flat

def extract_usuarios() -> pd.DataFrame:
    usuarios = fetch_usuarios()

    usuarios_flat = [flatten_usuario(usuario) for usuario in usuarios]

    df = pd.DataFrame(usuarios_flat)

    df["dl_load_timestamp"] = datetime.now()

    return df

def extract_posts() -> pd.DataFrame:
    posts = fetch_posts()
    df = pd.DataFrame(posts)
    df["dl_load_timestamp"] = datetime.now()
    return df


## Teste rápido para verificar se as funções estão funcionando corretamente ##

if __name__ == "__main__":

    usuarios_df = extract_usuarios()
    posts_df = extract_posts()

    print("Usuarios")
    print(usuarios_df.head())

    print("\nPosts")
    print(posts_df.head())

## até o momento aqui ta ok ##
   