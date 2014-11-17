#!/usr/bin/env coffee

Prox = require('mitm-proxy')
url = require('url')
config = require 'config'

setCORSHeaders = (req, res, next) ->
  res.setHeader 'Access-Control-Allow-Origin', '*'
  res.setHeader 'Access-Control-Allow-Methods', 'POST'
  res.setHeader 'Access-Control-Max-Age', '604800'
  res.setHeader 'Access-Control-Allow-Credentials', 'true'

  next()

class Masher
  url_rewrite: (req_url)->
    # http://stats.reviewed.com:8086/db/hydra-timing/series?u
    req_url.host = 'localhost:8086'
    req_url.pathname = '/db/hydra-timing/series'
    req_url.search = "?u=root&p=root"
    req_url

  constructor: (@proxy) ->
      @proxy.on('request', (request, req_url)->
          if request.method is 'POST'
              url = req_url
              console.info "Request has been rewritten, new request: " + url.format(req_url)
              console.info("[#{url.hostname} #{url.pathname}] - Processor request event, url: #{url.format(req_url)}")
          else
              req_url.port = 9999 # TODO mitm needs a way to cancel here
      )
      @proxy.on('request_data', (data)->
          console.info "+++ RECEIVED data"
          console.log(JSON.parse(data))
      )

new Prox({proxy_port: 8080, verbose: true}, Masher)
