# Projet SAE6 - Samuel BINCKLY et Charles DOMMANGE

Ce projet a pour objectif une application permettant de reconnaître des plantes avec la caméra.

## Installation pour tester

- Cloner le git
- Ajouter un fichier .env dans `sae_app_mobile/assets` contenant `API_KEY=...`, avec la clé API de Plant.ID

Aucune autre configuration n'est nécessaire, il n'y a plus qu'à lancer.

L'application a été testé uniquement sur iOS. Elle devrait fonctionner également sur Android, mais elle ne fonctionne pas entièrement en web (gestion de la prise de photos non fonctionnel).

## Fonctionnement

Flutter appelle directement Plant.id pour l'API, il n'y a pas d'intermédiaire (nous n'avons pas développé d'API), car l'API Plant.id nous suffit et un intermédiaire serait peu utile (sauf pour les aspects de sécurité).

## Choix de technologies

- **Front-end** : Dart, avec Flutter
- **Bases de données** : SQLite, en local pour l'utilisateur
-  **API** : l'API externe [Plant.id](https://www.plant.id/api)