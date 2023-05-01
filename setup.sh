        # This is the initialization script that will get the password from encrypted .env file
        if [ "$EUID" -ne 0 ]
            then echo "You are not running as root. Please run the script as root or using sudo."
            
        fi
        echo "Changing SSH config.."
        #!/bin/bash

        if ! command -v sed &> /dev/null
        then
            echo "sed not found. Installing..."
            if command -v apt-get &> /dev/null; then
                apt-get update
                apt-get upgrade
                apt-get install curl
                apt-get install sed
            elif command -v yum &> /dev/null; then
                sudo yum install sed
            else
                echo "Error: package manager not found. Please install sed manually."
                exit 1
            fi
        else
            sleep 2
            clear
            echo "======================"
            echo "Enter your password:"
            echo "======================"
            read rootpass
            echo "You entered: $rootpass"
            sleep 3
            sed -i 's/^PasswordAuthentication no$/PasswordAuthentication yes/' /etc/ssh/sshd_config
            sed -i 's/^#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
            echo "Changing the root@password now ..."
            sleep 2
            # Set the root password to the custom password
            echo "Setting root password..."
            echo "root:$rootpass" | chpasswd
            systemctl restart sshd
            clear
            echo "Successfully changes the SSH Config and password"
            sleep 3
            clear
            echo "======================="
            echo "=     Login Details   = "
            echo "======================="
            echo ""
            echo "IP: $(curl -s icanhazip.com)"
            echo "Password: $rootpass"
            exit
            
    fi

