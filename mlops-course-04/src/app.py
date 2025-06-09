from fastapi import FastAPI
from fastapi.responses import JSONResponse
from fastapi.middleware.cors import CORSMiddleware

app = FastAPI()

# Enable CORS for App Runner health checks
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/health")
async def health_check():
    """Enhanced health endpoint with service checks"""
    try:
        # Add any critical service verifications here
        return JSONResponse(
            content={"status": "healthy", "services": ["ready"]},
            status_code=200,
            headers={"Content-Type": "application/json"}
        )
    except Exception as e:
        return JSONResponse(
            content={"status": "unhealthy", "error": str(e)},
            status_code=503
        )

# Your existing routes...
@app.get("/")
async def root():
    return {"message": "Service is running"}