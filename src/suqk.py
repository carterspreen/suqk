# Essentials
#import numpy as np
from pathlib import Path

# Used to generate the ES Hamiltonian
#import qforte as qf
from qforte import system_factory

# Used to generate the qubit Hamiltonian
#import openfermion as of

# Used to generate quantum circuits and drive QPUs
#import qiskit as qk
#import qiskit_aer as aer
#import qiskit_ibm_runtime as ibm

########################################################

def get_repo_root() -> Path:
    """
    Return a Path to the repo root.
    """
    return Path(__file__).parent.parent

def get_data_dir() -> Path:
    """
    Return a Path to the data/ directory.
    """
    return get_repo_root() / "data"

def create_experiment_dir(exp_name: str):
    """
    Create the experiment directory.
    """
    (get_data_dir() / exp_name).mkdir()

def get_experiment_dir(exp_name: str):
    """
    Return a Path to the experiment directory.
    """
    return get_data_dir() / exp_name

def diatomic_h2_sto_3g(exp_name: str):
    """
    Create the molecule options for
    a hardcoded diatomic H2 molecule.
    """
    mol_name = "diatomic_h2_sto_3g"
    mol_geom = [
        ('H', (0, 0, 1.0)), 
        ('H', (0, 0, 2.0)),
    ]
    #listed in order of their appearance in system_factory.py
    mol_options = {
        'mol_geometry': mol_geom,
        'basis': 'sto-3g', #minimal AO basis
        'charge': 0,       #neutral
        'multiplicity': 1, #singlet
        'filename': str(get_experiment_dir(exp_name) / (mol_name + "_psi4_log")),
        'nroots_fci': 2  #nick
    }
    return mol_options

def build_molecule(mol_options):
    """
    Build a QForte 'Molecule' object for a diatomic H2 molecule,
    with 1 Angstrom spacing between the H atoms,
    using the STO-3G basis set,
    and Psi4 as the backend.
    """
    # listed in order of their appearance in molecule_adapters.py
    mol_build_options = {
        'num_frozen_docc': 0, #default
        'num_frozen_uocc': 0, #default
        'run_mp2': False, #nick
        'run_cisd': False, #nick
        'run_ccsd': False, #nick
        'run_fci': True, #nick
        'symmetry': 'c1', #nick
        'build_qb_ham': False, #nick
        'build_df_ham': False, #default
        'store_mo_ints': True, #nick
        'store_mo_ints_np': False, #default
        'df_icut': 1.0e-6          #default
    }
    mol = system_factory(
        system_type='molecule',
        build_type='psi4',
        **mol_options,
        **mol_build_options
    )
    return mol

def run_experiment(exp_name: str):
    try:
        create_experiment_dir(exp_name)
    except FileExistsError as e:
        print(f"Error: '{exp_name}' already exists. You may not overwrite an existing experiment.")
    else:
        build_molecule(diatomic_h2_sto_3g(exp_name))

if __name__ == "__main__":

    run_experiment("testing2")
