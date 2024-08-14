locals {
  user_data = <<-EOF
              #!/bin/bash
              sudo yum install -y httpd -y
              sudo systemctl start httpd
              sudo systemctl enable httpd
              
              # Create the main index page with a hyperlink to the accounts page
              echo "<h1>Welcome to ${var.name}!</h1>" > /var/www/html/index.html
              echo "<p><a href='/accounts/index.html'>account-challenge</a></p>" >> /var/www/html/index.html
              
              # Create the protected /accounts page
              sudo mkdir -p /var/www/html/accounts
              echo "<h1>Account Information</h1><p>This content is protected by AWS WAF.</p>" | sudo tee /var/www/html/accounts/index.html > /dev/null
              EOF
}
