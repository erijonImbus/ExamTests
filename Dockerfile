# 1. Përdorim një imazh bazë Python (me versionin 3.9)
FROM python:3.9-slim

# 2. Krijojmë një direktori pune brenda konteinerit, që do të përdoret për ekzekutimin e komandave
WORKDIR /usr/src/app

# 3. Përditësojmë pip dhe instalojmë Robot Framework dhe Selenium
RUN pip install --upgrade pip && \
    pip install robotframework selenium

# 4. Kopjojmë skedarët nga mjedisi i jashtëm (për shembull, skedarët e testeve nga Jenkins) në direktorinë e punës
COPY . /usr/src/app

# 5. Vendosim që të ekzekutojmë komandën robot kur konteineri të nisë
ENTRYPOINT ["robot"]

# 6. Komanda e ekzekutimit të testeve, duke përdorur një argument për të kaluar rrugën e testeve
CMD ["/usr/src/app/test_cases"]
