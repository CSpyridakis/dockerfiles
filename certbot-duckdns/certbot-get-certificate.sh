#!/bin/bash

# -----------------------------------------------------------------------------
# This file has either been created using public resources or developed by the following author.
# 
# Last Modified: 31 March 2025
# Repository: https://github.com/CSpyridakis/dockerfiles
# Author: Christos Spyridakis
# 
# -----------------------------------------------------------------------------
# License:
#     If an external resource was used, proper attribution is provided afterward. In that case, 
#     please disregard the licensing indicated here and ensure that the software license is
#     derived from the original resource. Otherwise, use the following license.
# 
# MIT License
# 
# Copyright (c) 2025 Christos Spyridakis
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
# -----------------------------------------------------------------------------

# see: https://github.com/infinityofspace/certbot_dns_duckdns?tab=readme-ov-file#credentials-file-or-cli-parameters

domain="domain.duckdns.org"

docker run \
    -v "./letsencrypt:/etc/letsencrypt" \
    -v "./letsencrypt-logs:/var/log/letsencrypt" \
    -v "./duckdns.ini:/conf/duckdns.ini" \
    infinityofspace/certbot_dns_duckdns:latest \
        certonly \
            --non-interactive \
            --agree-tos \
            --register-unsafely-without-email \
            --preferred-challenges dns \
            --authenticator dns-duckdns \
            --dns-duckdns-credentials /conf/duckdns.ini \
            --dns-duckdns-propagation-seconds 60 \
            -d "${domain}"
