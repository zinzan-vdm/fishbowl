#!/usr/bin/env bash

woof() {
    local file="$1"
    local port="${2:-8080}"

    local name=$(basename "$file")
    local size=$(stat -c%s "$file")

    local ip=$(ip route get 1 | awk '{print $7; exit}')
    local link="http://$ip:$port"

    echo "Serving $file at $link"
    echo ""
    echo "$url" | qrencode -t UTF8
    echo ""
    echo "Press Ctrl+C to stop"
    echo ""

    local tmp=$(mktemp)

    {
        printf "HTTP/1.1 200 OK\r\n"
        printf "Content-Type: application/octet-stream\r\n"
        printf "Content-Disposition: attachment; filename=\"$name\"\r\n"
        printf "Content-Length: $size\r\n"
        printf "Accept-Ranges: bytes\r\n"
        printf "Cache-Control: private, max-age=0\r\n"
        printf "Connection: close\r\n"
        printf "\r\n"
    } > "$tmp"

    cat "$file" >> "$tmp"

    cat "$tmp" | nc -l "$port"

    rm "$tmp"

    echo "Connection closed, terminating..."
}

woofs() {
    local file="$1"
    local port="${2:-8080}"

    local name=$(basename "$file")
    local size=$(stat -c%s "$file")

    local ip=$(ip route get 1 | awk '{print $7; exit}')
    local link="http://$ip:$port"

    echo "Serving $file at $link"
    echo ""
    echo "$url" | qrencode -t UTF8
    echo ""
    echo "Press Ctrl+C to stop"
    echo ""

    local tmp=$(mktemp)

    {
        printf "HTTP/1.1 200 OK\r\n"
        printf "Content-Type: application/octet-stream\r\n"
        printf "Content-Disposition: attachment; filename=\"$name\"\r\n"
        printf "Content-Length: $size\r\n"
        printf "Accept-Ranges: bytes\r\n"
        printf "Cache-Control: private, max-age=0\r\n"
        printf "Connection: close\r\n"
        printf "\r\n"
    } > "$tmp"

    cat "$file" >> "$tmp"

    while true; do
        cat "$tmp" | nc -l "$port"

        echo "Connection closed, waiting for next request..."
    done

    rm "$tmp"
}
