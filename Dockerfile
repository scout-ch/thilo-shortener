############################################################################################################
# BUILD
############################################################################################################
FROM python:3.12.1 as build

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
FROM nginx:1.25.3 as release

# Path: /etc/nginx/nginx.conf
COPY --from=build nginx.conf /etc/nginx/nginx.conf

EXPOSE 80
