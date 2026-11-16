# OBSYD Project

**OBSYD Cosmetics 0.4.0** est une application Windows qui permet d’essayer des cosmétiques et de sauvegarder des tenues dans le Locker de Lunar Client. Un agent Java applique les changements à l’affichage local. La compatibilité dépend des services disponibles dans le profil Lunar utilisé.

OBSYD est un projet indépendant de Lunar Client et de Minecraft. Le client Lunar s’installe séparément.

## Démarrer sous Windows

Prérequis pour compiler sous Windows 10 ou 11 x64 :

- Node.js 24.
- JDK 17, avec `JAVA_HOME` pointant vers son dossier d’installation.
- Visual Studio 2022 ou Build Tools 2022, avec la charge de travail **Développement Desktop en C++**, CMake et le SDK Windows.

Dans **Developer PowerShell for VS 2022**, depuis la racine du projet :

```powershell
.\Build-Windows.cmd
```

Au premier lancement, le script crée les clés de développement et configure le client pour `http://127.0.0.1:8787`. La compilation télécharge ProGuard depuis Maven Central et vérifie les SHA-256 de ses dépendances. L’exécutable se trouve dans `build\Release\OBSYDCosmetics.exe`.

Démarrer le serveur de test et laisser le terminal ouvert :

```powershell
npm.cmd run dev
```

Dans un deuxième terminal PowerShell, à la racine du projet, créer une clé de test valable un jour :

```powershell
$env:SOMBRE_LOCAL_ADMIN = '1'
npm.cmd run admin -- http://127.0.0.1:8787 create 1 "Essai local"
Remove-Item Env:SOMBRE_LOCAL_ADMIN
```

1. Fermer Lunar Client, lancer `OBSYDCosmetics.exe` et saisir la clé `SC-…` affichée par la commande précédente.
2. Cliquer sur **Préparer Lunar**. Coller l’argument JVM copié dans les paramètres JVM du profil Lunar, une seule fois.
3. Cliquer sur **Activer pour Lunar**, lancer le profil, puis ouvrir le Locker.
4. Pour retirer l’agent, supprimer l’argument JVM et redémarrer Lunar.

Pour connecter le client à votre propre service HTTPS, suivre le [guide d’auto-hébergement](docs/SELF-HOSTING.md).

## Sources et tests

| Dossier | Rôle |
| --- | --- |
| `client/` | Interface Windows, activation et gestion de la session |
| `agent/` | Agent Java et bibliothèque native qui vérifie le permis de session |
| `worker/` | API de licences Cloudflare Workers et migrations D1 |
| `tools/` | Scripts de compilation, serveur de test et administration |
| `tests/` | Tests de l’API, du client et de l’agent |

Lancer `npm.cmd test` depuis PowerShell sous Windows, ou `npm test` sous Linux. Cette suite utilise Node.js 24 et SQLite. Elle inclut un test HTTP qui ouvre un port local.

Après compilation, `ctest --test-dir build -C Release --output-on-failure` lance les tests natifs. Le [workflow Windows](.github/workflows/windows.yml) exécute les tests et la compilation avec des clés générées à chaque exécution. Les tests automatisés de l’agent utilisent des services Lunar simulés.

Voir aussi l’[architecture du serveur et du client](docs/ARCHITECTURE.md).

## Licence

Le code d’OBSYD est sous [licence MIT](LICENSE). Les polices Sora et IBM Plex Sans sont distribuées sous SIL Open Font License 1.1. Leurs [avis de licence](assets/THIRD_PARTY_NOTICES.txt) accompagnent les fichiers.
