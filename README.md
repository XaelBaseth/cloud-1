# 🐳 WordPress Docker Infrastructure (Terraform + Vagrant + Ansible)

Ce projet automatise le déploiement d'un site WordPress dans un environnement local isolé à l'aide des outils DevOps modernes : **Terraform**, **Vagrant**, **Ansible** et **Docker Compose**.

---

## 📦 Technologies utilisées

| Outil           | Rôle                                                                |
|-----------------|---------------------------------------------------------------------|
| Terraform       | Provisionne automatiquement une VM locale via Vagrant.              |
| Vagrant         | Gère les machines virtuelles locales via VirtualBox.                |
| Ansible         | Configure la VM, installe Docker, et déploie WordPress.             |
| Docker          | Exécute les services WordPress et MariaDB dans des conteneurs.      |
| Docker Compose  | Orchestration multi-conteneurs (WordPress + DB).                    |

---

## 🛠️ Prérequis

Assurez-vous d’avoir ces outils installés sur votre machine :

- [VirtualBox](https://www.virtualbox.org/)
- [Vagrant](https://www.vagrantup.com/)
- [Terraform](https://developer.hashicorp.com/terraform/downloads)
- [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
- [Python3](https://www.python.org/)

---

## 🚀 Lancer l’environnement

### 1. Provisionner la machine virtuelle avec Terraform

```bash
cd terraform
terraform init
terraform apply -auto-approve
```

Ce processus :
- Lance une VM avec Vagrant et VirtualBox.
- Génére une adresse IP pour la VM.
- Prépare la base pour une configuration automatique via Ansible.

### 2. Générer dynamiquement l’inventaire Ansible

```bash
python3 ansible/generate_inventory.py
```

Ce script lit la sortie de Terraform et génère automatiquement un fichier `ansible/inventory.ini` à jour.

### 3. Exécuter le playbook Ansible

```bash
ansible-playbook -i ansible/inventory.ini playbook/playbook.yml
```

Ce playbook :
- Met à jour les paquets système.
- Installe Docker + docker-compose.
- Déploie WordPress via Docker Compose.

## Se connecter en SSH a la VM

```bash
ssh -i ~/.vagrant.d/insecure_private_keys/vagrant.key.rsa \
    vagrant@192.168.56.10 \
    -o StrictHostKeyChecking=no \
    -o UserKnownHostsFile=/dev/null
```

---

## 🌐 Accéder au site

Une fois le déploiement terminé, ouvrez :

```
http://192.168.56.10:8080
```

> Si vous avez changé l’adresse IP dans Vagrantfile ou Terraform, adaptez-la ici.

---

## 🧹 Nettoyage de l’environnement

Un script est fourni pour nettoyer proprement l’environnement :

```bash
sudo ./scripts/clean.sh
```

Ce script :
- Détruit la VM Vagrant
- Supprime les fichiers d’état Terraform
- Nettoie les images, volumes et conteneurs Docker
- Supprime les clusters k3d si présents
- Efface l’inventaire généré
