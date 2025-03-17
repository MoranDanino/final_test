# as in docker part: 
    FROM python:3.9-slim AS builder
    WORKDIR /app
    COPY requirements.txt .
    # run packages we need
    RUN pip install --no-cache-dir -r requirements.txt
    #copy the app- update the app file name to the right:
    COPY . .
    
    FROM python:3.9-slim 
    WORKDIR /app
    #depend on the builder- multistaging
    COPY --from=builder /app /app  
    #path packages we probably need
    COPY --from=builder /usr/local/lib/python3.9/site-packages /usr/local/lib/python3.9/site-packages   
    EXPOSE 5001
    #env vars 
    ENV AWS_DEFAULT_REGION=us-east-1
    ENV PYTHONUNBUFFERED=1
    #update the app file name to the right:
    CMD ["python", "app.py"]