# kubetpl:syntax:go-template

---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ .APP }}
  namespace: default
spec:
  replicas: {{ .REPLICAS }}
  selector:
    matchLabels:
      app: {{ .APP }}
  template:
    metadata:
      name: {{ .APP }}
      labels:
        app: {{ .APP }}
    spec:
      containers:
      - name: {{ .APP }}
        image: {{ .IMAGE }}
        resources:
          limits:
            memory: {{ .MEMORY_LIMIT }}
          requests:
            memory: {{ .MEMORY_REQUEST }}
            cpu: {{ .CPU_REQUEST }}
        env:
        - name: ENV_KEY
          value: $ENV_KEY
