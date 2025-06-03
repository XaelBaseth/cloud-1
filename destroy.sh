#!/bin/bash
set -euo pipefail

TERRAFORM_DIR="terraform/azure"
ANSIBLE_INVENTORY="ansible/inventory.ini"

echo "[!] ATTENTION : destruction de l'infrastructure cloud"

read -p "Confirmer la destruction de la VM Azure ? (yes/no): " CONFIRM
if [[ "$CONFIRM" != "yes" ]]; then
  echo "Opération annulée."
  exit 1
fi

echo "[*] Destruction de l'infrastructure avec Terraform"
cd "$TERRAFORM_DIR"
terraform destroy -auto-approve

cd ../../

if [[ -f "$ANSIBLE_INVENTORY" ]]; then
  echo "[*] Suppression de l'inventaire Ansible"
  rm -f "$ANSIBLE_INVENTORY"
fi

# Optionnel : purger les volumes persistants locaux (à adapter si utilisé dans des mounts)
# echo "[*] Suppression des volumes persistants locaux"
# rm -rf data/db data/wordpress data/certs data/vhost.d data/html

echo "[✓] Tout a été nettoyé proprement."
