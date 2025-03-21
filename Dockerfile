# 1. Përdorim një imazh bazë Python (me versionin 3.9)
FROM python:3.9-slim

# 2. Krijojmë një direktori pune brenda konteinerit, që do të përdoret për ekzekutimin e komandave
WORKDIR /usr/src/app

# 3. Përditësojmë pip dhe instalojmë Robot Framework dhe Selenium
RUN pip install --upgrade pip && \
    pip install robotframework selenium

# 4. Vendosim që të ekzekutojmë komandën robot kur konteineri të nisë
ENTRYPOINT ["robot"]
