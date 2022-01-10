# kubetpl:syntax:go-template

---
apiVersion: apps/v1
kind: Deployment
metadata:
{{ if isset "CANARY" }}
  name: {{ .APP }}-canary
{{ else }}
  name: {{ .APP }}
{{ end }}
  namespace: default
spec:
{{ if isset "CANARY" }}
  replicas: 1
{{ else }}
  replicas: {{ .REPLICAS }}
{{ end }}
  selector:
    matchLabels:
      app: {{ .APP }}
    {{ if isset "CANARY" }}
      version: canary
    {{ end }}
  template:
    metadata:
      name: {{ .APP }}
      labels:
        app: {{ .APP }}
      {{ if isset "CANARY" }}
        version: canary
      {{ end }}
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
