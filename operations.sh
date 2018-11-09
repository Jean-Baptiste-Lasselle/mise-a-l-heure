#!/bin/bash
# Hôte Docker sur centos 7
############################################################
############################################################
# 					Compatibilité système		 		   #
############################################################
############################################################

# ----------------------------------------------------------
# [Pour Comparer votre version d'OS à
#  celles mentionnées ci-dessous]
# 
# ¤ distributions Ubuntu:
#		lsb_release -a
#
# ¤ distributions CentOS:
# 		cat /etc/redhat-release
# 
# 
# ----------------------------------------------------------

# ----------------------------------------------------------
# testé pour:
# 
# 
# 
# 
# ----------------------------------------------------------
# (Ubuntu)
# ----------------------------------------------------------
# 
# ¤ [TEST-OK]
#
# 	[Distribution ID: 	Ubuntu]
# 	[Description: 		Ubuntu 16.04 LTS]
# 	[Release: 			16.04]
# 	[codename:			xenial]
# 
# 
# 
# 
# 
# 
# ----------------------------------------------------------
# (CentOS)
# ----------------------------------------------------------
# 
# 
# 
# ...
# ----------------------------------------------------------




# --------------------------------------------------------------------------------------------------------------------------------------------
##############################################################################################################################################
#########################################							ENV								##########################################
##############################################################################################################################################
# --------------------------------------------------------------------------------------------------------------------------------------------
export MAISON_OPERATIONS=`pwd`

# -
export NOMFICHIERLOG="$MAISON_OPERATIONS/synchronisation-NTP-public.log"

export SERVEUR_NTP=0.us.pool.ntp.org

######### -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -
######### -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -


# --------------------------------------------------------------------------------------------------------------------------------------------
##############################################################################################################################################
#########################################							FONCTIONS						##########################################
##############################################################################################################################################

# --------------------------------------------------------------------------------------------------------------------------------------------
# Cette fonction permet de re-synchroniser l'hôte docker sur un serveur NTP, sinon# certaines installations dépendantes
# de téléchargements avec vérification de certtificat SSL
configurationNTP () {
        # ---------------------------------------------------------------------------------------------------------------------------------------------
        # ------        SYNCHRONSITATION SUR UN SERVEUR NTP PUBLIC (Y-en-a-til des gratuits dont je puisse vérifier le certificat SSL TLSv1.2 ?)
        # ---------------------------------------------------------------------------------------------------------------------------------------------
        # ---------------------------------------------------------------------------------------------------------------------------------------------
        # ---   Pour commencer, pour ne PAS FAIRE PETER TOUS LES CERTIFICATS SSL vérifiés pour les installation yum
        # ---
        # ---   Sera aussi utilise pour a provision de tous les noeuds d'infrastructure assurant des fonctions d'authentification:
        # ---           Le serveur Free IPA Server
        # ---           Le serveur OAuth2/SAML utilisé par/avec Free IPA Server, pour gérer l'authentification
        # ---           Le serveur Let's Encrypt et l'ensemble de l'infrastructure à clé publique gérée par Free IPA Server
        # ---           Toutes les macines gérées par Free-IPA Server, donc les hôtes réseau exécutant des conteneurs Girofle
        #
        #
        # >>>>>>>>>>> Mais en fait la synchronisation NTP doit se faire sur un référentiel commun à la PKI à laquelle on choisit
        #                         de faire confiance pour l'ensemble de la provision. Si c'est une PKI entièrement interne, alors le système
        #                         comprend un repository linux privé contenant tous les packes à installer, dont docker-ce.
        #
        # ---------------------------------------------------------------------------------------------------------------------------------------------
        echo "date avant la configuration  NTP" >> $NOMFICHIERLOG
        date >> $NOMFICHIERLOG
        
        
        # sudo which ntpdate
        # sudo which ntpd
        # sudo which ntptrace
        
        
        # '/usr/sbin/ntptrace' est installé par 'ntp-perl'
        # sudo yum install -y ntp ntpdate ntp-perl
        # je ne veux plus de ntp-trace, ni ntp-perl,je veu xsimplement cofngiurer le servie NTP
        sudo yum remove -y ntp ntpdate
        sudo yum install -y ntp ntpdate
        
        # Pour re-confifgurer le service NTP
        # On commence par désactiver le service NTP, s'il existe déjà.
        sudo systemctl stop ntpd
        sudo systemctl disable ntpd
        
        sudo rm -f /etc/ntp.conf
        sudo cp ./etc.ntp.conf /etc/ntp.conf
        sudo systemctl enable ntpd
        
        echo " Vérification du statut du service ntp avant la re-synchronisation forcée au serveur NTP de référence du système : "
        sudo systemctl stop ntpd && sudo systemctl status ntpd >> $NOMFICHIERLOG

        # Synchronisation forcée sur un sereur NTP particulier
        sudo ntpdate $SERVEUR_NTP >> $NOMFICHIERLOG
        
        # Pour re-synchroniser l'horloge matérielle, sur l'horloge Linux qui vient d'être synchronisée.
        # Et ainsi conserver l'heure après un reboot, et ce y compris après ré-installation de l'OS.
        sudo hwclock --systohc >> $NOMFICHIERLOG
        
        echo " Vérification du statut du service ntp après re-démarrage du service NTPD : " >> $NOMFICHIERLOG
        sudo systemctl start ntpd && sudo systemctl restart ntpd && sudo systemctl status ntpd >> $NOMFICHIERLOG
        
        echo " Vérification de la liste des serveurs NTP de référence du système : "
        echo " Vérification de la liste des serveurs NTP de référence du système : " >> $NOMFICHIERLOG
        sudo ntpq -p
        sudo ntpq -p >> $NOMFICHIERLOG
        # sudo ntptrace
        # sudo ntptrace >> $NOMFICHIERLOG
        
        echo " Date après la configuration  NTP"
        echo " Date après la configuration  NTP" >> $NOMFICHIERLOG
        date 
        date >> $NOMFICHIERLOG
        
        echo " TimeZone après la configuration  NTP : ]"
        echo " TimeZone après la configuration  NTP : ]" >> $NOMFICHIERLOG
        ls -all /etc/localtime
        ls -all /etc/localtime >> $NOMFICHIERLOG
        
}


# --------------------------------------------------------------------------------------------------------------------------------------------
##############################################################################################################################################
#########################################							OPS								##########################################
##############################################################################################################################################
# --------------------------------------------------------------------------------------------------------------------------------------------

echo " +++configurationNTP+  COMMENCEE  - " >> $NOMFICHIERLOG

configurationNTP

echo " +++configurationNTP+  TERMINEE  - " >> $NOMFICHIERLOG
