var express, jade, http;
express = require('express');
jade = require('jade');
http = require('http');
module.exports = {
  site: express(),
  admin: express()
};