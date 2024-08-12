from multiprocessing import Pool
from multiprocessing import cpu_count
import time
import random

class CPU_stress:
    def stress(self, stress_time: int) -> None:
        if stress_time <= 0:
            print("Invalid stress time")
            exit(1)
        
        processes = cpu_count()
        print('Starting CPU stress utilizing %d cores\n' % processes)
        pool = Pool(processes)
        pool.map(self._stress_f, [stress_time] * processes)

    def _stress_f(self, stress_time: int) -> int:
        timeout = time.time() + stress_time  # X seconds from now
        while True:
            if time.time() > timeout:
                break
            # Arbitrary computation to keep the CPU busy
            x = random.randint(0, 100_000_000)
            x * x

if __name__ == '__main__':
    c = CPU_stress()
    c.stress(15)
