#!/usr/bin/env python3
import subprocess
import json
import os
import sys

env = sys.argv[1] if len(sys.argv) > 1 else "vagrant"

terraform_dirs = {
    "vagrant": "terraform/vagrant",
    "azure": "terraform/azure"
}

if env not in terraform_dirs:
    print(f"Unknown environment '{env}'")
    sys.exit(1)

tf_dir = terraform_dirs[env]

os.chdir(tf_dir)

output = subprocess.run(["terraform", "output", "-json"], capture_output=True, text=True)

if output.returncode != 0:
    print("Error running terraform output:", output.stderr)
    sys.exit(1)

data = json.loads(output.stdout)
ip = data["vm_ip"]["value"]

os.chdir("../..")  # back to project root

inventory_path = "ansible/inventory.ini"
with open(inventory_path, "w") as f:
    f.write(f"[{env}]\n")
    f.write(f"{ip} ansible_user=vagrant ansible_private_key_file=~/.vagrant.d/insecure_private_key ")
    f.write("ansible_ssh_common_args='-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'\n")

print(f"Inventory written to {inventory_path} for environment: {env}")
