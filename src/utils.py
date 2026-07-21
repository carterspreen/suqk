from pathlib import Path

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