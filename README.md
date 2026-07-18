# suqk

Stochastic Unitary Quantum Krylov using QForte and Qiskit. Project from Frost
SURP 2026, California Polytechnic State University, SLO.

The initial implementation is a dense NumPy reference simulator. It samples
qDRIFT unitary trajectories, averages their projected Hamiltonian and overlap
matrices, and solves the stabilized generalized eigenvalue problem.

```python
import numpy as np
from suqk import StochasticUnitaryKrylov

X = np.array([[0, 1], [1, 0]], dtype=complex)
Z = np.diag([1, -1]).astype(complex)

solver = StochasticUnitaryKrylov([(0.7, X), (-0.2, Z)])
result = solver.run(
    [1, 0],
    krylov_dimension=3,
    time_step=0.3,
    trajectories=1000,
    steps_per_interval=4,
    seed=7,
)
print(result.ground_energy)
```

Run the tests from the repository root with:

```console
PYTHONPATH=src pytest
```
