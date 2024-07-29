import os
import sys
from robot import run

def run_robot_tests():
    # Get the directory of the current script
    script_dir = os.path.dirname(os.path.abspath(__file__))

    # Define the path to the Robot Framework test file
    test_file = os.path.join(script_dir, 'testcases.robot')

    # Run the test file
    result = run(test_file, outputdir=os.path.join(script_dir, 'results'))
    
    # Exit with the same exit code as the test run
    sys.exit(result)

if __name__ == "__main__":
    run_robot_tests()