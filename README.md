# DevOpsAssignment

The code have two modules that will deploy the infrastructure. 

The first module will deploy the Virtual Machines, Network Subnets, Security Group, Public IP, Network Interfaces and Load Balancers.

Each virtual machine will be deployed and assigned to a Network interface card. After that a load balancer will be created and the NICs will be associated to this load balancer.
Also, a public IP is created to be used by the load balancer. The subnets will be created and will be associated with NSG rules.

The second module will create the database infrastructure.

A storage account will be created, after that, a mySQL server will be created with an admin user and password. The last step will create an sql database in the sql server previously created and the process will be finished.

Each step is deployed in modules and the variables are in separated files.
