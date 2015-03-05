sibtek-site
===========

How to deploy
-------------

1. Clone this repo and go to directory:

  ```bash
  $ git clone https://github.com/unclechu/sibtek-site sibtek-site
  $ cd sibtek-site
  ```
2. Sync <b>git</b> submodules:

  ```bash
  $ git submodule update --init
  ```

3. Copy [config.yaml.example](./config.yaml.example) to `config.yaml` and set correct 'DATABASE', 'PRODUCTION' and 'EMAIL' in `config.yaml`.

4. Install dependencies:

  ```bash
  $ npm install
  ```
  
  It automatically runs `./deploy.sh` after install, it deploys front-end scripts and styles for site and admin control panel, it will install bower-dependencies for front-end too. You can rebuild front-end by `./front-end-gulp` util, see more [here](https://github.com/unclechu/front-end-gulp-pattern).
  
  Also it runs automatically after install `./auto-migrate.sh`, you can run it by your bare hands, it's important thing to do for updates or first site initialization.

6. Run your production server:

  ```bash
  $ ./run-production-server.sh
  ```
