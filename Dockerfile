############################################################################################################
# BUILD
############################################################################################################
FROM python:3.12.4 as build

# Install dependencies
COPY ./requirements.txt /requirements.txt
RUN pip install -r /requirements.txt

# Run script to convert links.yml to nginx.conf
COPY ./links.yml /links.yml
COPY ./convertToNginx.py /convertToNginx.py
RUN python convertToNginx.py

############################################################################################################
# RELEASE
############################################################################################################
FROM nginx:1.25.4 as release

# Path: /etc/nginx/nginx.conf
COPY --from=build nginx.conf /etc/nginx/nginx.conf
COPY html /etc/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
