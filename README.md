# 🐳 WordPress Docker Infrastructure (Terraform + Vagrant + Ansible)

Ce projet automatise le déploiement d'un site WordPress dans un environnement local isolé à l'aide des outils DevOps modernes : **Terraform**, **Vagrant**, **Ansible** et **Docker Compose**.

---

## 📦 Technologies utilisées

| Outil           | Rôle                                                                |
|-----------------|---------------------------------------------------------------------|
| Terraform       | Provisionne automatiquement une VM Azure              				|
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

### 0. Se connecter a azure

```bash
az login
```

Connecte la vm a Azure, et permet le deploiement des ressources sur le portail Azure. 

### 1. Provisionner la machine virtuelle avec Terraform

```bash
cd terraform
terraform init
terraform apply -auto-approve
```

Ce processus :
- Lance une VM sur Azure
- Prépare la base pour une configuration automatique via Ansible.

### 3. Exécuter le playbook Ansible

```bash
cd ansible
ansible-playbook -i ansible/inventory.ini playbook/playbook.yml
```

Ce playbook :
- Met à jour les paquets système.
- Installe Docker + docker-compose.
- Déploie WordPress via Docker Compose.

## Se connecter en SSH a la VM

```bash
ssh alice@cloud1-42lh.duckdns.org
```

---

## 🌐 Accéder au site

Une fois le déploiement terminé, ouvrez :

```
https://cloud1-42lh.duckdns.org
```

---

## 🧹 Nettoyage de l’environnement

```bash
cd terraform 
terraform destroy
```
