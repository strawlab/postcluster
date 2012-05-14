from cStringIO import StringIO
import subprocess

def test_python_matlab():
    # generate data
    subprocess.check_call('python generate_dataset.py',
                          shell=True)

    # get matlab output (octave, actually):
    proc = subprocess.Popen('octave --silent compute_quality.m',
                            shell=True,
                            stdout=subprocess.PIPE)
    matlab_out = proc.communicate()[0]

    # get python output
    proc = subprocess.Popen('python compute_quality.py',
                            shell=True,
                            stdout=subprocess.PIPE)
    python_out = proc.communicate()[0]

    assert matlab_out.strip()==python_out.strip()
