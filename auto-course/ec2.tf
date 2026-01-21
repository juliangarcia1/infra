resource "tls_private_key" "pk" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "kp" {
  key_name   = "auto-course-key"
  public_key = tls_private_key.pk.public_key_openssh
}

resource "local_file" "ssh_key" {
  content         = tls_private_key.pk.private_key_pem
  filename        = "auto-course-key.pem"
  file_permission = "0400"
}

resource "aws_instance" "app_server" {
  ami           = data.aws_ami.amazon_linux_2023.id
  instance_type = var.instance_type
  subnet_id     = data.aws_subnet.selected.id

  vpc_security_group_ids = [aws_security_group.nextjs_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name
  key_name               = aws_key_pair.kp.key_name

  tags = {
    Name = "auto-course-nextjs"
  }

  user_data = <<-EOF
              #!/bin/bash
              dnf update -y
              dnf install -y nodejs git jq iptables-services

              # Create Swap for t3.micro builds
              dd if=/dev/zero of=/swapfile bs=128M count=16
              chmod 600 /swapfile
              mkswap /swapfile
              swapon /swapfile

              # Setup App Directory
              mkdir -p /home/ec2-user/app
              chown ec2-user:ec2-user /home/ec2-user/app
              cd /home/ec2-user/app

              # Example: Fetch DB creds to prove connection (application logic would go here)
              SECRET_JSON=$(aws secretsmanager get-secret-value --region us-east-1 --secret-id ${data.terraform_remote_state.multi_db.outputs.secret_arn} --query SecretString --output text)
              echo "DB Credentials available in environment"

              # Create Minimal Next.js App
              cat <<EOT > package.json
              {
                "name": "auto-course-app",
                "version": "1.0.0",
                "scripts": {
                  "dev": "next dev",
                  "build": "next build",
                  "start": "next start"
                },
                "dependencies": {
                  "next": "14.1.0",
                  "react": "18.2.0",
                  "react-dom": "18.2.0",
                  "pg": "^8.11.3"
                }
              }
              EOT

              cat <<EOT > next.config.js
              module.exports = {
                reactStrictMode: true,
              }
              EOT

              mkdir pages
              cat <<EOT > pages/index.js
              export default function Home() {
                return (
                  <div style={{ fontFamily: 'sans-serif', padding: '50px' }}>
                    <h1>Auto-Course Next.js App</h1>
                    <p>Deployed via Terraform User Data</p>
                    <p>Connected to Multi-DB Infrastructure</p>
                  </div>
                )
              }
              EOT

              # Install and Build (as ec2-user)
              su - ec2-user -c "cd /home/ec2-user/app && npm install && npm run build"

              # Start with PM2
              npm install -g pm2
              su - ec2-user -c "cd /home/ec2-user/app && pm2 start npm --name nextjs -- start"
              
              # Startup Persistence
              su - ec2-user -c "pm2 save"
              pm2 startup systemd -u ec2-user --hp /home/ec2-user

              # Port Forwarding 80 -> 3000
              iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 3000
              service iptables save
              systemctl enable iptables
              systemctl start iptables
              EOF
}

resource "aws_ec2_instance_state" "app_server_state" {
  instance_id = aws_instance.app_server.id
  state       = var.instance_running ? "running" : "stopped"
}

