ARG VAULT_VERSION

FROM arm32v6/vault:${VAULT_VERSION}

RUN mkdir -p /opt/vault && \
    apk add --no-cache nmap-ncat jq bash

COPY run.sh /opt/vault/run.sh

RUN chmod +x /opt/vault/run.sh

CMD ["/bin/bash", "/opt/vault/run.sh"]
