# Essentials
import numpy as np

# Used to generate the ES Hamiltonian
import qforte

# Used to generate the qubit Hamiltonian
import openfermion

# Used to generate quantum circuits and drive QPUs
import qiskit
import qiskit_aer
import qiskit_ibm_runtime


def build_es_hamiltonian(geom):

    mol = system_factory(
        build_type='psi4',
        mol_geometry=geom,
        basis='sto-3g',
        df_icut=1.0e-6)

#number of krylov basis states to generate
krylov_basis_size = 3
#timestep size (seconds)
dt = 0.5

def build_qubit_hamiltonian():
    pass

def build_evolution_circuit():
    pass
    
def build_krylov_basis():
    pass

def build_overlap_matrix():
    pass

if __name__ == "__main__":

    geom = [
        ('H', (1.0, 0.0, 0.0)), 
        ('H', (2.0, 0.0, 0.0))
        ]

    build_es_hamiltonian(geom)