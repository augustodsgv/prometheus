"""
Produces load on all available CPU cores.
Requires system environment var STRESS_MINS to be set.
"""

from multiprocessing import Pool
from multiprocessing import cpu_count
import time
import os

class Memory_stress:
    def stress(self, stress_time : int, memory_allocated : int)->None:
        if not 'STRESS_SECS' in os.environ:
            print("Missing stress time test")
            exit(1)
        
        processes = cpu_count()
        print ('Starting CPU stress utilizing %d cores\n' % processes)
        pool = Pool(processes)
        pool.map(self._stress_f, range(processes))

    def _stress_f(self, x : int)-> int:
        set_time = os.environ['STRESS_SECS']
        timeout = time.time() + float(set_time)  # X minutes from now
        while True:
            if time.time() > timeout:
                break
            x*x

if __name__ == '__main__':
    m = Memory_stress()
    m.stress(15)