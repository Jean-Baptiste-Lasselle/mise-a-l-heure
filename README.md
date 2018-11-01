# mise-a-l-heure

Synchronisation sur un serveur NTP, et mise à joru de l'horodatage système.
Serveur NTP publics internet de strate 2.

Valable pour un système Cent OS 7

### Dépendances 

Cette recette doit être exécutée sur une machine:
* sur laquelle CentOS 7 est le système d'exploitation, 
* sur laquelle GIT a été installé,
* sur laquellle le système CentOS a été synchronisé sur un serveur NTP


Cette recette a donc pour dépendances:

* Le système CentOS 7,
* un serveur NTP
* GIT 


# Utilisation

Il vous suffit d'exécuter les instructions ci-dessous, la valeur de la variable d'environnement `SERVEUR_NTP` vous permet de fixer quel est le serveur NTP sur lequel votre instance d'OS se synchronisera.

```
# export URI_REPO_RECETTE=https://github.com/Jean-Baptiste-Lasselle/provision-hote-docker-sur-centos
export URI_REPO_RECETTE=git@github.com:Jean-Baptiste-Lasselle/mise-a-l-heure.git
export PROVISONING_HOME=$HOME/horodatage-systeme
export GIT_SSH_COMMAND="ssh -i ~/.ssh/id_rsa"
rm -rf $PROVISONING_HOME
mkdir -p $PROVISONING_HOME
cd $PROVISONING_HOME
git clone "$URI_REPO_RECETTE" .
sudo chmod +x operations.sh
# Pour les US : 0.us.ntp.org
export SERVEUR_NTP=0.fr.ntp.org
./operations.sh
```

Soit en une seule ligne:

```
export URI_REPO_RECETTE=git@github.com:Jean-Baptiste-Lasselle/mise-a-l-heure.git && export PROVISONING_HOME=$HOME/horodatage-systeme && export GIT_SSH_COMMAND="ssh -i ~/.ssh/id_rsa" && rm -rf $PROVISONING_HOME && mkdir -p $PROVISONING_HOME && cd $PROVISONING_HOME && git clone "$URI_REPO_RECETTE" . && sudo chmod +x operations.sh && export SERVEUR_NTP=0.fr.ntp.org && ./operations.sh 
```

## RUN: forcer la mis à jour de l'heure 

À un quelconque moement du ru, voici comment mettre à jour l'heure, sur la base des serveurs NTP configurés dans le fichier `/etc/ntp.conf`
```bash
sudo ntpd -gq
```


# Références

https://www.pool.ntp.org/en/use.html


# TODO : configuration TIMEZONES

Tout en notant que dans le cas des 4 OS prinicpaux supportés, la procédure à suivre est très similaire, reposant sur les fondamentaux UNIX / Linux : 

* Pour CentOS : https://www.cyberciti.biz/faq/centos-linux-6-7-changing-timezone-command-line/
* Pour Debian 6+ : https://wiki.debian.org/TimeZoneChanges 
* Pour Ubuntu 12.04 LTS + : https://askubuntu.com/questions/323131/setting-timezone-from-terminal
* Pour Alpine Linux 3.0.0 + : https://wiki.alpinelinux.org/wiki/Setting_the_timezone 


ENfin, il faiudra automatiser de 2 façons : 
* Pour une configuration dans le run
* Pour une configuration dans le kickstart 


