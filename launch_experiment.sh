# Launching network
if [ $(docker network list | grep monitor_network | wc -l) -ne 1 ]; then
    echo "Creating monitor network "
    docker network create monitor_network > /dev/null
fi

# Getting number of nodes from user
if [ $# -eq 0 ]; then
    echo "Insert the amout of node to run: "
    read n_nodes
else
    n_nodes=$1
fi

# Setting prometheus template file
cat << EOF > prometheus.yml 
global:
  scrape_interval: "1s"

scrape_configs:
  - job_name: 'node'
    static_configs:
EOF


# Setting nodes configs to prometheus file
for ((i = 1; i < $n_nodes + 1; i++)); do
    cat << EOF >> prometheus.yml
      - targets: ['worker-node$i:9100']
        labels:
          group: 'monitoring_node_ex$i'
EOF
done

# Compiling worker node's image
docker build -t stress-worker ./node

# Lanching nodes
for ((i = 1; i < $n_nodes + 1; i++)); do
    echo "Creating node $i at port $port"

    docker run -d --network monitor_network \
        --name worker-node$i \
        -p 900$i:9100 \
        -p 800$i:8080 \
        stress-worker >> /dev/null

done

# Lanching prometheus
echo "Creating prometheus"

docker  run -d --name prometheus \
            -p 9090:9090 \
            --network monitor_network \
            -v $(pwd)/prometheus.yml:/opt/bitnami/prometheus/conf/prometheus.yml \
            bitnami/prometheus:latest >> /dev/null