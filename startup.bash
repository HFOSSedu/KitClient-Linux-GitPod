IMAGE_PULLED=$(docker image ls | tail -n +2)
if [ -z "$IMAGE_PULLED" ];
then
    echo "Pulling VNC/noVNC image..."
    #docker pull braughtg/vnc-novnc-base:1.2.1
    docker pull registry.gitlab.com/hfossedu/kits/kitclient:latest
    echo "Pulled."
    echo ""
fi

CONTAINER_EXISTS=$(docker ps -a | grep "vnc")
if [ -z "$CONTAINER_EXISTS" ];
then
    echo "Creating VNC/noVNC container..."
    #docker create --name vnc --publish 5901:5901 --publish 6901:6901 braughtg/vnc-novnc-base:1.2.1
    docker create --name KitClient -p 6901:6901 -p 5901:5901 registry.gitlab.com/hfossedu/kits/kitclient:latest
    echo "Created."
    echo ""
fi

CONTAINER_RUNNING=$(docker ps | grep "vnc")
if [ -z "$CONTAINER_RUNNING" ];
then
    echo "Starting VNC/noVNC container"
    #docker start vnc
    docker start KitClient
    gp ports await 5901 > /dev/null
    gp ports await 6901 > /dev/null
    echo "Started."
    echo ""
    echo ""

    echo "Connect to the noVNC server with your browser at:"
    gp url 6901
    echo ""
    echo "OR"
    echo ""

    echo "Do the following on your machine to connect via VNC:"
    SSH_URL=$(gp ssh | cut -f2 -d' ')
    echo "  Run the following command in a terminal:"
    echo "    ssh -L 5901:localhost:5901 $SSH_URL"
    echo "  Connect your VNC Client to:"
    echo "    localhost:5901"
    echo ""
fi
