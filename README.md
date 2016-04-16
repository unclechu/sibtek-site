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

3. Copy [config.yaml.example](./config.yaml.example) to `config.yaml`:
  
  ```bash
  $ cp config.yaml.example config.yaml
  ```
  
  And set correct values of 'DATABASE', 'PRODUCTION' and 'EMAIL' in `config.yaml`.
  **WARNING!** If you're going to connect to MongoDB without user or password,
  or you want to use default port then remove that fields from `config.yaml`,
  DO NOT leave fields with empty strings (as in example config file),
  it will be interpreted as real values (empty string).

4. Install dependencies:
  
  ```bash
  $ npm install
  ```
  
  It automatically runs `./deploy.sh` after install, it deploys front-end
  scripts and styles for site and admin control panel, it will install
  bower-dependencies for front-end too. It runs `./gulp` default tasks,
  that build server-side code.
  
  You can rebuild front-end by `./front-end-gulp` util, see more
  [here](https://github.com/unclechu/front-end-gulp-pattern).
  
  You can rebuild server-side code by `./gulp server`. You can start watcher
  for automatically rebuilding server-side code by
  `./gulp server-watch --buildLog` (--buildLog will log every file).
  
  Also it runs automatically after install `./auto-migrate.sh`, you can run it
  by your bare hands, it's important thing to do for updates or first site
  initialization.

6. Run your production server:
  
  ```bash
  $ ./run-production-server.js
  ```
