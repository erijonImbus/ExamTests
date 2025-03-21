# 1. Përdorim një imazh bazë Python (me versionin 3.9)
FROM python:3.9-slim

# 2. Krijojmë një direktori pune brenda konteinerit
WORKDIR /usr/src/app

# 3. Përditësojmë pip dhe instalojmë Robot Framework dhe Selenium
RUN pip install --upgrade pip && \
    pip install robotframework selenium

# 4. Kopjojmë skedarët nga mjedisi i jashtëm në direktorinë e punës në konteiner
COPY . /usr/src/app/test_cases

# 5. Vendosim që të ekzekutojmë komandën robot kur konteineri të nisë
ENTRYPOINT ["robot"]

# 6. Ekzekutojmë testet nga dosja /usr/src/app/test_cases
CMD ["/usr/src/app/test_cases"]
