FROM python:alpine
# just ignore the ldap wheel its fine no problem
# its just ldap0 with ldap_r changed to ldap from the setup.cfg
# so it compiles against openldap-dev>=2.5 
RUN set -eux;\
    apk --no-cache --virtual .build-deps add gcc musl-dev libffi-dev;\
    wget https://files.catbox.moe/fp893j.whl -O ldap0-1.4.9-cp310-cp310-linux_x86_64.whl;\
    pip3 install ldap0-1.4.9-cp310-cp310-linux_x86_64.whl && rm ldap0-1.4.9-cp310-cp310-linux_x86_64.whl;\
    pip3 install --no-cache-dir --find-links https://www.web2ldap.de/download.html web2ldap;\
    apk del .build-deps;\
    apk add libldap

CMD ["web2ldap","0.0.0.0","1760"]