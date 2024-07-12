import os
import robot

def run_robot_tests():
    robot_file = 'path_to_robot_file.robot'  # Update with the actual path to your robot file
    results_dir = 'results'
    
    if not os.path.exists(results_dir):
        os.makedirs(results_dir)
    
    result = robot.run(robot_file, outputdir=results_dir)
    
    if result == 0:
        print("All tests passed successfully!")
    else:
        print(f"Some tests failed. Check the results in {results_dir} for more details.")

if __name__ == "__main__":
    run_robot_tests()