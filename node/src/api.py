from fastapi import FastAPI
from src.cpu_stress import CPU_stress
import uvicorn 

app = FastAPI()

@app.get('/cpu')
def cpu_stress(stress_time : int):
    c = CPU_stress()
    c.stress(stress_time)
    return {f'Cpu stressed for {stress_time}s'}

if __name__ == '__main__':
    uvicorn.run(app, host='0.0.0.0', port=8080)