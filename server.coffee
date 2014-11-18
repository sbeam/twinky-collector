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
        resp.writeHead(204, {
            'Access-Control-Allow-Origin': '*'
            'Access-Control-Allow-Methods': 'POST,OPTIONS'
            'Access-Control-Allow-Headers': 'Authorization,Content-Type,Accept,Origin,User-Agent,DNT,Cache-Control,X-Mx-ReqToken,Keep-Alive,X-Requested-With,If-Modified-Since'
            'Access-Control-Max-Age': '604800'
            'Access-Control-Allow-Credentials': 'true'
            'Content-type': 'text/plain charset=UTF-8'
            'Content-length': '0'
        })
        resp.end()
    else
        resp.statusCode = 404
        resp.end()

).listen(serverConfig.proxy_port)

sys.puts("Proxying /#{serverConfig.route} to #{serverConfig.upstream_url} at port #{serverConfig.proxy_port}")
