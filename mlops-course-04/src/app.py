from fastapi import FastAPI
from pydantic import BaseModel
import pandas as pd
import joblib
import os

app = FastAPI()

class InputData(BaseModel):
    Gender: str
    Age: int
    HasDrivingLicense: int
    RegionID: float
    Switch: int
    PastAccident: str
    AnnualPremium: float

# Load model with error handling
try:
    model = joblib.load('models/model.pkl')
except Exception as e:
    print(f"Error loading model: {str(e)}")
    model = None

@app.get("/")
async def root():
    return {"status": "ok", "health_check": "success"}

@app.get("/health")
async def health_check():
    if model is None:
        return JSONResponse(status_code=503, content={"status": "error"})
    return JSONResponse(status_code=200, content={"status": "healthy"})

@app.post("/predict")
async def predict(input_data: InputData):
    if model is None:
        return {"error": "Model not loaded"}, 500
        
    try:
        df = pd.DataFrame([input_data.dict().values()], 
                         columns=input_data.dict().keys())
        pred = model.predict(df)
        return {"predicted_class": int(pred[0])}
    except Exception as e:
        return {"error": str(e)}, 500