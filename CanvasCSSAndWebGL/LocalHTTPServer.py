import mimetypes
import SimpleHTTPServer
import BaseHTTPServer

class LocalHTTPRequestHandler(SimpleHTTPServer.SimpleHTTPRequestHandler):

    """SimpleHTTPServer subclass which knows about certain necessary MIME types."""

    SimpleHTTPServer.SimpleHTTPRequestHandler.extensions_map.update({
        '.svg': 'image/svg+xml',
        })

if __name__ == '__main__':
    SimpleHTTPServer.test(LocalHTTPRequestHandler, BaseHTTPServer.HTTPServer)
