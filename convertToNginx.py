import yaml

# Load links from links.yml
with open("links.yml", "r") as stream:
    try:
        links = yaml.safe_load(stream)
        links = links["links"]
    except yaml.YAMLError as exc:
        print(exc)

print("Loaded " + str(len(links)) + " links")


def convertLinksToNginx(links):
    # create for each link a nginx location

    nginx = """
events {
    worker_connections  4096;  ## Default: 1024
}

http {
include mime.types;
default_type application/octet-stream;
sendfile on;

server {
    listen 80;
    listen [::]:80;

    server_name shortener.thilo.learn2cloud.ch;

    location /
    {
        root /etc/nginx/html;
        index index.html;
    }

"""
    for link in links:
        print("Adding " + link + " to " + links[link])
        nginx += "location = /" + link + " {\n"
        nginx += "\treturn 301 " + links[link] + ";\n"
        nginx += "}\n"

        nginx += "\n"

    nginx += """
    }
}
"""

    return nginx


nginx = convertLinksToNginx(links)

# Write nginx config to nginx.conf
with open("nginx.conf", "w", encoding="UTF-8") as f:
    f.write(nginx)
