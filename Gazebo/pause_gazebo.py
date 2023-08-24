#!/usr/bin/env python

import sys
import rospy
from std_msgs.msg import Bool
from std_srvs.srv import Empty

subscriber = None 

def callback(data):
    global subscriber
    if data.data:
        rospy.loginfo("Received pause command. Attempting to pause Gazebo...")

        try:
            pause_gazebo = rospy.ServiceProxy('/gazebo/pause_physics', Empty)
            pause_gazebo()
            rospy.loginfo("Gazebo paused successfully. Exiting...")
            
            if subscriber:
                subscriber.unregister()
            
            rospy.sleep(1.0) 
            rospy.signal_shutdown("Task completed.")
            sys.exit(0)

        except rospy.ServiceException as e:
            rospy.logerr("Failed to pause Gazebo: %s", e)

def listener():
    global subscriber
    rospy.init_node('gazebo_pause_listener', anonymous=True)
    subscriber = rospy.Subscriber("/pause_gazebo_topic", Bool, callback)
    rospy.spin()

if __name__ == '__main__':
    listener()
