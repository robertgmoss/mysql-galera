# create the containers

sudo docker run -d --name first-node robertgmoss/galera
sudo docker run -d --name second-node robertgmoss/galera
sudo docker run -d --name third-node robertgmoss/galera

# modify the config

FIRST_IP=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' first-node)
SECOND_IP=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' second-node)
THIRD_IP=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' third-node)

GCOMM="gcomm://$FIRST_IP,$SECOND_IP,$THIRD_IP"
CLUSTER_NAME="MyCluster"

sudo docker exec -it first-node bash  -c "echo wsrep_cluster_name=\"$CLUSTER_NAME\" >> /etc/mysql/my.cnf"
sudo docker exec -it second-node bash -c "echo wsrep_cluster_name=\"$CLUSTER_NAME\" >> /etc/mysql/my.cnf"
sudo docker exec -it third-node bash  -c "echo wsrep_cluster_name=\"$CLUSTER_NAME\" >> /etc/mysql/my.cnf"

sudo docker exec -it first-node bash  -c "echo wsrep_cluster_address=\"$GCOMM\" >> /etc/mysql/my.cnf"
sudo docker exec -it second-node bash -c "echo wsrep_cluster_address=\"$GCOMM\" >> /etc/mysql/my.cnf"
sudo docker exec -it third-node bash  -c "echo wsrep_cluster_address=\"$GCOMM\" >> /etc/mysql/my.cnf"

sudo docker exec -it first-node bash  -c "echo wsrep_node_address=\"$FIRST_IP\" >> /etc/mysql/my.cnf"
sudo docker exec -it second-node bash -c "echo wsrep_node_address=\"$SECOND_IP\" >> /etc/mysql/my.cnf"
sudo docker exec -it third-node bash  -c "echo wsrep_node_address=\"$THIRD_IP\" >> /etc/mysql/my.cnf"

# Grant permissions to root user on all nodes

GRANT_FIRST="SET wsrep_on=OFF; GRANT ALL ON *.* TO root@$FIRST_IP;"
GRANT_SECOND="SET wsrep_on=OFF; GRANT ALL ON *.* TO root@$SECOND_IP;"
GRANT_THIRD="SET wsrep_on=OFF; GRANT ALL ON *.* TO root@$THIRD_IP;"

sudo docker exec -it first-node bash  -c "mysql -u root -e '$GRANT_FIRST'"
sudo docker exec -it first-node bash  -c "mysql -u root -e '$GRANT_SECOND'"
sudo docker exec -it first-node bash  -c "mysql -u root -e '$GRANT_THIRD'"

sudo docker exec -it second-node bash -c "mysql -u root -e '$GRANT_FIRST'"
sudo docker exec -it second-node bash -c "mysql -u root -e '$GRANT_SECOND'"
sudo docker exec -it second-node bash -c "mysql -u root -e '$GRANT_THIRD'"

sudo docker exec -it third-node bash  -c "mysql -u root -e '$GRANT_FIRST'"
sudo docker exec -it third-node bash  -c "mysql -u root -e '$GRANT_SECOND'"
sudo docker exec -it third-node bash  -c "mysql -u root -e '$GRANT_THIRD'"

# restart the databases

sudo docker exec -it first-node bash -c "service mysql restart --wsrep-new-cluster"
sudo docker exec -it second-node bash -c "service mysql restart"
sudo docker exec -it third-node bash -c "service mysql restart"


