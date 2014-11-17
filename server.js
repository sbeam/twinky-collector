(function() {
  var Prox, config, processor, setCORSHeaders, url;

  Prox = require('mitm-proxy');

  url = require('url');

  config = require('config');

  setCORSHeaders = function(req, res, next) {
    res.setHeader('Access-Control-Allow-Origin', '*');
    res.setHeader('Access-Control-Allow-Methods', 'POST');
    res.setHeader('Access-Control-Max-Age', '604800');
    res.setHeader('Access-Control-Allow-Credentials', 'true');
    return next();
  };

  var Thing = {
  processor : function(proxy) {
    console.log(this);
    this.url_rewrite = function(req_url) {
      console.error("url_rewrite is called ok");
      req_url.query.u = 'root';
      req_url.query.p = 'root';
      req_url.search = "?" + qs.stringify(req_url.query);
      req.url.path = '/quuux';
      this.rewritten = true;
      return req_url;
    };
    return proxy.on('request', function(request, req_url) {
      url = req_url;
      console.info("Request has been rewritten, new request: " + url.format(req_url));
      return console.info("[" + url.hostname + " " + url.pathname + "] - Processor request event, url: " + (url.format(req_url)));
    });
  }
  };

  new Prox({
    proxy_port: 8080,
    verbose: true
  }, Thing.processor);

}).call(this);
