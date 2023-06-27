#!/bin/bash/

################################
# executed inside the container
# Then create an rc.local file to perform the profile loading:
cat > /etc/rc.local <<EOF
#!/bin/bash

apparmor_parser --replace /var/lib/snapd/apparmor/profiles/snap.microk8s.*
exit 0
EOF

# Make the rc.local executable:
chmod +x /etc/rc.local




