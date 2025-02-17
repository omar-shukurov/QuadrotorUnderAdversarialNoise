mkdir -p ~/catkin_ws/src/IMAV_2017_Virtual_Challenge
cp -r * ~/catkin_ws/src/IMAV_2017_Virtual_Challenge

sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
sudo apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116

sudo apt update
sudo apt install ros-melodic-desktop-full -y

sudo rosdep init
rosdep update

echo "source /opt/ros/melodic/setup.bash" >> ~/.bashrc
source ~/.bashrc

sudo apt install python-rosinstall -y

cd ~/catkin_ws/
catkin_make

echo "source ~/catkin_ws/devel/setup.bash" >> ~/.bashrc
source ~/.bashrc

sudo apt install ros-melodic-joy -y
sudo apt install ros-melodic-image-view -y

sudo sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list'
wget http://packages.osrfoundation.org/gazebo.key -O - | sudo apt-key add -
sudo apt update

sudo apt install gazebo9 libgazebo9-dev -y
sudo apt install ros-melodic-gazebo-ros-pkgs ros-melodic-gazebo-ros-control -y
sudo apt install ros-melodic-hector-gazebo-plugins ros-melodic-hector-sensors-description ros-melodic-hector-gazebo -y

if [ "$1" == "noisy" ]; then
    cp ~/catkin_ws/src/IMAV_2017_Virtual_Challenge/controllers/quadrotor_simple_controller_noisy.cpp ~/catkin_ws/src/IMAV_2017_Virtual_Challenge/plugins/src/quadrotor_simple_controller.cpp
elif [ "$1" == "normal" ]; then
    cp ~/catkin_ws/src/IMAV_2017_Virtual_Challenge/controllers/quadrotor_simple_controller.cpp ~/catkin_ws/src/IMAV_2017_Virtual_Challenge/plugins/src/quadrotor_simple_controller.cpp
elif [ "$1" == "noisy_collision" ]; then
    cp ~/catkin_ws/src/IMAV_2017_Virtual_Challenge/controllers/quadrotor_simple_controller_noisy_collision.cpp ~/catkin_ws/src/IMAV_2017_Virtual_Challenge/plugins/src/quadrotor_simple_controller.cpp
elif [ "$1" == "collision" ]; then
    cp ~/catkin_ws/src/IMAV_2017_Virtual_Challenge/controllers/quadrotor_simple_controller_collision.cpp ~/catkin_ws/src/IMAV_2017_Virtual_Challenge/plugins/src/quadrotor_simple_controller.cpp
else
    echo "Invalid argument. Please use 'noisy', 'normal', 'collision', 'noisy_collision' as an argument."
    exit 1
fi

cd ~/catkin_ws/src/IMAV_2017_Virtual_Challenge/plugins
mkdir -p build
cd build
cmake ..
make

cd ~/catkin_ws/
catkin_make


cd ~/catkin_ws/src/IMAV_2017_Virtual_Challenge/worlds/xacro
rosrun xacro xacro --inorder imav_indoor.world.xacro > ../imav_indoor.world 


echo 'export GAZEBO_PLUGIN_PATH=:~/catkin_ws/src/IMAV_2017_Virtual_Challenge/plugins/build:/opt/ros/melodic/lib:/usr/include/gazebo-9' >> ~/.bashrc

chmod +x pause_gazebo.py
cd ~/catkin_ws/src/IMAV_2017_Virtual_Challenge/
./run_gzb.sh
