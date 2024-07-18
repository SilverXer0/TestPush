import subprocess

def run_robot_tests():
    result = subprocess.run(['robot', 'path_to_your_robot_file.robot'], capture_output=True, text=True)
    print(result.stdout)

if __name__ == "__main__":
    run_robot_tests()