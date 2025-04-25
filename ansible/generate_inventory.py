import subprocess
import json
import os

terraform_dir = "../terraform"
os.chdir(terraform_dir)

output = subprocess.run(["terraform", "output", "-json"], capture_output=True)
data = json.loads(output.stdout)
ip = data["vm_ip"]["value"]

os.chdir("..")

with open("ansible/inventory.ini", "w") as f:
    f.write(f"[vagrant]\n{ip} ansible_user=vagrant ansible_private_key_file=~/.vagrant.d/insecure_private_keys/vagrant.key.rsa ansible_ssh_common_args='-o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'\n")
