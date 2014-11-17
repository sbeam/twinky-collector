#!/usr/bin/env coffee

http = require 'http'
config = require 'config'
sys = require 'sys'
Request = require 'request'

serverConfig = config.get('server')

http.createServer((req, resp)->

    if req.method is 'POST' and req.url is "/#{serverConfig.route}"
        body = ""

        req.on 'data', (chunk)->
            body += chunk

        req.on 'end', ->
            Request.post(serverConfig.upstream_url, form: body).pipe(resp)

    else if req.method is 'OPTIONS'
        resp.writeHead(200, {
            'Access-Control-Allow-Origin': '*'
            'Access-Control-Allow-Methods': 'POST'
            'Access-Control-Max-Age': '604800'
            'Access-Control-Allow-Credentials': 'true'
        })
        resp.end()
    else
        resp.statusCode = 404
        resp.end()

).listen(serverConfig.proxy_port)

sys.puts("Proxying /#{serverConfig.route} to #{serverConfig.upstream_url} at port #{serverConfig.proxy_port}")
