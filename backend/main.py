from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
import uvicorn

app = FastAPI()

# This allows your Flutter app to talk to this Python server
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

@app.get("/tasks")
def get_tasks():
    return [
        {"id": "1", "title": "Buy Groceries", "status": "done"},
        {"id": "2", "title": "Finish Flodo Assignment", "status": "todo", "blockedBy": "1"}
    ]

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)