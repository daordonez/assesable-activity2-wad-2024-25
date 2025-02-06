# assesable-activity2-wad-2024-25

# EC2 instace deployment
To deploy your EC2 AWS instance, you should have a valid subscription and a valid roles to create new resources in at least one region. For this activity, a training lab using awsacademy.instructure.com has been used.

The following steps explains (simplified) the required steps to run and make your EC2 instance available on internet:

1. Network: Create a VPC to have a range for all the requried resources
2. Network: Create a subnet and make it accesible from internet enabling: auto-assign public ipv4 address
3. Security Group: Create a security group and define a firewall rules to allow inbound/outbound communication. **You should allow inbound connections to ports: 80,443 and 22**
4. Compute: Launch a EC2 instance using the creation wizard, and attach it to the already created subnet. Do not forget to add your public Key or create a new SSH-Key pair.
5. Management: Create a SSH-Key pair to connect to your EC2 during the creation process
6. Internet Gateway: Create and internet gateway to allow internet communication with your VPC.
7. Atttach and associate, and route the IGW: Assoicate your created IGW to your VPC, and allow the interne communication using ```0.0.0.0/0``` CIDR notation in the route tables
8. Elastic IP: Create and associate your public IP to your IGW to get public access of your EC2 instance.
9. Test your SSH connection using: ``ssh -i "<YOUR_KEY_NAME>.pem" ubuntu@<YOUR_PUBLIC_IP>``

# App Deployment
To Install, configure and deploy, once you have been deployed your AWS EC2 instance, follow this sequence to finish your lab:

1. Connect to your EC2 instance using your public IP and the generated privated key ``ssh -i "<YOUR_KEY_NAME>.pem" ubuntu@<YOUR_PUBLIC_IP>``
2. Execute the following command:``curl -sL https://raw.githubusercontent.com/daordonez/assesable-activity2-wad-2024-25/refs/heads/main/post_deployment.sh | bash``