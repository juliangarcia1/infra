# EC2 for nexjs project, connect to multi-db database
* Ready for Next.js projects
* Connection to multi-db database instance
* Single EC2 instance hosting the application
* Security Group to allow HTTP (80) and SSH (22) access to the EC2
* PEM file created through terraform code and stored locally to access the EC2 instance via SSH
* User Data script to install Node.js, Git, and deploy a sample Next.js application
* Cognito User Pool for user authentication and management
* Outputs for EC2 public IP and SSH command to access the instance
*Instance type from variables with t3.micro as default
* Region from variables with us-east-1 as default
* EC2 turn off and on from variables with off as default