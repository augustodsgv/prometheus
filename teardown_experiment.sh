# Getting number of nodes to destroy
n_nodes=$(docker ps | grep worker-node | wc -l)

# Lanching nodes
for ((i = 1; i < $n_nodes + 1; i++)); do
    echo "Stopping node $i"
    docker stop worker-node$i >> /dev/null
    docker rm worker-node$i >> /dev/null
done

# Lanching prometheus
prometheus_exists=$(docker ps -a | grep prometheus | wc -l)
if [ $prometheus_exists -eq 1 ]; then
    echo "Deleting prometheus"
    docker stop prometheus >> /dev/null
    docker rm prometheus >> /dev/null
fi

# Deleting network
if [ $(docker network list | grep monitor_network | wc -l) -eq 1 ]; then
    echo "Deleting monitor network "
    docker network rm monitor_network > /dev/null
fi