'use strict'
const express = require('express');
const awsServerlessExpressMiddleware =
  require('aws-serverless-express/middleware');
const app = express();

app.use(awsServerlessExpressMiddleware.eventContext());

app.get('*', (req, res) => {
  // Respond with API Gateway event
  res.json(req.apiGateway.event)
});

module.exports = app;
