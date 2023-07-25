import rosbag
import rospy
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D

import nav_msgs.msg

def plot_bag_file(bag_file):
    bag = rosbag.Bag(bag_file)
    x = []
    y = []
    z = []

    for topic, msg, t in bag.read_messages(topics=['/quadrotor_1_ground_truth_state_robot_position_subscribe1']):
        x.append(msg.pose.pose.position.x)
        y.append(msg.pose.pose.position.y)
        z.append(msg.pose.pose.position.z)

    fig = plt.figure()
    ax = fig.add_subplot(111, projection='3d')
    ax.plot(x, y, z)
    ax.set_xlabel('X')
    ax.set_ylabel('Y')
    ax.set_zlabel('Z')

    plt.show()

if __name__ == "__main__":
    import sys
    if len(sys.argv) < 2:
        print("Please provide a bag file as argument.")
        sys.exit(1)
    plot_bag_file(sys.argv[1])


