import rosbag
import rospy
import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d.axes3d import Axes3D

def plot_bag_file(bag_files, labels):
    fig = plt.figure()
    ax = fig.add_subplot(111, projection='3d')
    ax.set_xlabel('X')
    ax.set_ylabel('Y')
    ax.set_zlabel('Z')

    

    for i, bag_file in enumerate(bag_files):
        bag = rosbag.Bag(bag_file)
        x = []
        y = []
        z = []
        
        # Check which topic exists in the bag file
        topics_info = bag.get_type_and_topic_info().topics
        if '/quadrotor_1_ground_truth_state_robot_position_subscribe1' in topics_info:
            topic_to_read = '/quadrotor_1_ground_truth_state_robot_position_subscribe1'
        elif '/quadrotor_1/ground_truth/state' in topics_info:
            topic_to_read = '/quadrotor_1/ground_truth/state'
        else:
            print("Neither topic found in {bag_file}")
            continue

        for topic, msg, t in bag.read_messages(topics=[topic_to_read]):
            x.append(msg.pose.pose.position.x)
            y.append(msg.pose.pose.position.y)
            z.append(msg.pose.pose.position.z)

        ax.plot(x, y, z, label=labels[i])

    xRate=3.5
    yRate=1
    zRate=1

    #Setting aspect ratio
    AspectRatio=np.diag([xRate, yRate, zRate, 1.0])
    AspectRatio=AspectRatio*(1.0/AspectRatio.max())
    AspectRatio[3,3]=1.0

    def short_proj():
        return np.dot(Axes3D.get_proj(ax), AspectRatio)
        print()

    ax.get_proj=short_proj

    ax.legend()

    plt.show()

if __name__ == "__main__":
    import sys
    if len(sys.argv) < 3 or len(sys.argv) % 2 != 1:
        print("""
Provide bagfile name then it's label
        
bagfile1.bag label1 ...
        """)
        sys.exit(1)

    bag_files = sys.argv[1::2]
    labels = sys.argv[2::2]
    plot_bag_file(bag_files, labels)

