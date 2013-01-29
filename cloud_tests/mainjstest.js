var assert = require("assert");
var util = require('util');
var nodeapp = require("node_modules/fh-nodeapp/lib/fh-nodeapp.js"); 
var mainjs = require("main.js");
var request = require('request');

var ROOT_URL = 'http://localhost:8001';

// The following tests our high level REST API endpoints (i.e. in cloud/main.js)
suite('RestAPI', function(){

  // Run fh-nodeapp on setup
  suiteSetup(function(done){
    nodeapp.HostApp.init();
    nodeapp.HostApp.serveApp(mainjs, function(err){
      done(err);
    });
  });

  // Stop fh-nodeapp
  suiteTeardown(function(done){
    nodeapp.HostApp.stopApp(function(){
      done();
    });
  });

  // Basic test to check App is running ok
  test('App running', function(done){
    request.get(ROOT_URL, function(err, response, data){
      if (err) done(err);
      assert.equal(response.statusCode, 200, "Bad statusCode from '/': " + response.statusCode + " - " + data);
      done();
    });
  });

  // Test 'getConfig' as defined in main.js
  test('getConfig', function(done){
    request.post({url: ROOT_URL + '/cloud/getConfig', json:{}}, function(err, response, data){
      if (err) done(err);
      assert.equal(response.statusCode, 200, "Bad statusCode from getConfig: " + response.statusCode + " - " + data);
      assert.equal(data.config.param2, true, "Unexpected config data, got: " + util.inspect(data));
      done();
    });
  });
});