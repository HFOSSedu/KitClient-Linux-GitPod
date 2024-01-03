IMAGE_PULLED=$(docker image ls | tail -n +2)
if [ -z "$IMAGE_PULLED" ];
then
    echo "Pulling KitClient image..."
    docker pull registry.gitlab.com/hfossedu/kits/kitclient:latest
    echo "Pulled."
    echo ""
fi

CONTAINER_EXISTS=$(docker ps -a | grep "KitClient")
if [ -z "$CONTAINER_EXISTS" ];
then
    echo "Creating KitClient container..."
    docker create --name KitClient -p 6901:6901 -p 5901:5901 registry.gitlab.com/hfossedu/kits/kitclient:latest
    echo "Created."
    echo ""
fi

CONTAINER_RUNNING=$(docker ps | grep "KitClient")
if [ -z "$CONTAINER_RUNNING" ];
then
    echo "Starting KitClient container"
    docker start KitClient
    gp ports await 5901 > /dev/null
    gp ports await 6901 > /dev/null
    echo "Started."
    echo ""
    echo ""

    echo "*********************************************************************************"
    echo "*********************************************************************************"
    echo ""
    echo "Connect to the KitClient with your browser at:"
    gp url 6901
    echo ""
    echo "*********************************************************************************"
    echo "*********************************************************************************"
    echo ""
    echo ""
    echo "Alternatively you can connect via a VNC client on your machine using the following commands:"
    SSH_URL=$(gp ssh | cut -f2 -d' ')
    echo "  Run the following command in a terminal:"
    echo "    ssh -L 5901:localhost:5901 $SSH_URL"
    echo "  Connect your VNC Client to:"
    echo "    localhost:5901"
    echo ""
fi
