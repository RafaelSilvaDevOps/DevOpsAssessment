# DevOpsAssessment

The code has two modules that will deploy the infrastructure. 

The first module will deploy the Virtual Machines, Network Subnets, Security Group, Public IP, Network Interfaces and Load Balancers.

Each virtual machine will be deployed and assigned to a Network interface card. After that a load balancer will be created and the NICs will be associated with this load balancer.
Also, a public IP is created to be used by the load balancer. The subnets will be created and will be associated with NSG rules.

The second module will create the database infrastructure.

A storage account will be created, and a MySQL server will be created with an admin user and password. The last step will create an SQL database in the SQL server previously developed and the process will be finished.

Each step is deployed in modules and the variables are in separate files.


# Python script

This script will deploy resources on Azure using the subscription ID. This will deploy a virtual machine, and the network infrastructure (virtual network, subnet, NIC, SQL database, SQL server, and a storage account. The script will use the Azure CLI to authenticate and then, deploy these resources on the cloud. The logs can be followed during the deployment
