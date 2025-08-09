from fastapi import FastAPI, Query, HTTPException
import httpx
import os
from dotenv import load_dotenv

load_dotenv()

app = FastAPI()

API_KEY = os.getenv("WEATHER_API_KEY")

if not API_KEY:
    raise RuntimeError("Variável de ambiente WEATHER_API_KEY não encontrada.")

@app.get("/weather")
async def get_weather(city: str = Query(..., example="São Paulo")):
    async with httpx.AsyncClient() as client:
        response = await client.get(
            "https://api.openweathermap.org/data/2.5/weather",
            params={
                "q": city,
                "appid": API_KEY,
                "units": "metric",
                "lang": "pt"
            }
        )

    if response.status_code != 200:
        raise HTTPException(status_code=404, detail="Cidade não encontrada.")

    data = response.json()

    return {
        "cidade": data["name"],
        "temperatura": f"{data['main']['temp']}°C",
        "clima": data["weather"][0]["description"],
        "umidade": f"{data['main']['humidity']}%",
        "vento": f"{data['wind']['speed']} m/s"
    }