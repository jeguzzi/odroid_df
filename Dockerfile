FROM ros:jade-ros-base

MAINTAINER Jerome Guzzi jerome@idsia.ch

USER root
ENV HOME /home/root

RUN apt-get update && apt-get install -y \
    build-essential \
    libgps-dev \
    ros-jade-roscpp \
    ros-jade-nodelet \
    ros-jade-image-transport-plugins \
    ros-jade-mavros \
    ros-jade-usb-cam \
    ros-jade-image-common \
    ros-jade-diagnostic-updater \
    ros-jade-dynamic-reconfigure \    
    ros-jade-geometry \
    git \
    autoconf \
    automake \
    autopoint \
    libglib2.0-dev \
    libtool \
    python-dev \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /tmp
RUN git clone https://github.com/lcm-proj/lcm /tmp/lcm
RUN /bin/bash -c 'pushd /tmp/lcm; ./bootstrap.sh; ./configure --prefix=/usr; make; make install; popd; rm -r /tmp/lcm'

RUN /bin/bash -c '. /opt/ros/jade/setup.bash; rosdep init; rosdep update'

RUN mkdir -p /home/root/catkin_ws/src
RUN /bin/bash -c '. /opt/ros/jade/setup.bash; catkin_init_workspace ~/catkin_ws/src'

RUN git clone https://github.com/jeguzzi/nimbro_network.git ~/catkin_ws/src/nimbro_network
RUN touch ~/catkin_ws/src/nimbro_network/nimbro_cam_transport/CATKIN_IGNORE
RUN touch ~/catkin_ws/src/nimbro_network/nimbro_service_transport/CATKIN_IGNORE
RUN touch ~/catkin_ws/src/nimbro_network/nimbro_topic_transport/CATKIN_IGNORE
RUN touch ~/catkin_ws/src/nimbro_network/tf_throttle/CATKIN_IGNORE

RUN git clone https://github.com/jeguzzi/gps_umd.git ~/catkin_ws/src/gps_umd

RUN git clone https://github.com/KumarRobotics/camera_base.git ~/catkin_ws/src/camera_base
RUN git clone https://github.com/KumarRobotics/bluefox2.git ~/catkin_ws/src/bluefox2

RUN home/root/catkin_ws/src/bluefox2/install/install.bash

RUN git clone  https://github.com/jeguzzi/odroid_manet.git ~/catkin_ws/src/odroid_manet

RUN /bin/bash -c '. /opt/ros/jade/setup.bash; catkin_make -j1 -C ~/catkin_ws'
RUN /bin/sed -i \
    '/source "\/opt\/ros\/$ROS_DISTRO\/setup.bash"/a source "\/home\/root\/catkin_ws\/devel\/setup.bash"'\
    /ros_entrypoint.sh

ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]

RUN touch ~/catkin_ws/src/nimbro_network/nimbro_log_transport/CATKIN_IGNORE 
RUN rm ~/catkin_ws/src/nimbro_network/nimbro_topic_transport/CATKIN_IGNORE  

RUN /bin/bash -c '. /opt/ros/jade/setup.bash; catkin_make -j1 -C ~/catkin_ws'

RUN /bin/bash -c 'pushd ~/catkin_ws/src/odroid_manet; git pull; popd'


