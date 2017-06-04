# -*- coding: utf-8 -*-
from flask import Flask

api = Flask(__name__)

@api.route('/')
def index():
    return open('index.html').read()

@api.route('/processing.js')
def processing():
    return open('processing.js').read()

@api.route('/lorenz-attractor.web.pde')
def pde():
    return open('lorenz_attractor.web.pde').read()

if __name__ == '__main__':
    api.run(host='0.0.0.0', port=8000)
