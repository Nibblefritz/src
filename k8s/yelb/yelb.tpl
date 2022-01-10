# kubetpl:syntax:go-template

---
apiVersion: v1
kind: Service
metadata:
  name: {{ .REDIS_NAME }}
  labels:
    app: {{ .REDIS_NAME }}
    tier: cache
  namespace: {{ .NAMESPACE }}
spec:
  type: ClusterIP
  ports:
  - port: {{ .REDIS_PORT }}
  selector:
    app: {{ .REDIS_NAME }}
    tier: cache
---
apiVersion: v1
kind: Service
metadata:
  name: {{ .APP }}-db
  labels:
    app: {{ .APP }}-db
    tier: backenddb
  namespace: {{ .NAMESPACE }}
spec:
  type: ClusterIP
  ports:
  - port: {{ .DB_PORT }}
  selector:
    app: {{ .APP }}-db
    tier: backenddb
---
apiVersion: v1
kind: Service
metadata:
  name: {{ .APP }}-appserver
  labels:
    app: {{ .APP }}-appserver
    tier: middletier
  namespace: {{ .NAMESPACE }}
spec:
  type: ClusterIP
  ports:
  - port: {{ .APP_PORT }}
  selector:
    app: {{ .APP }}-appserver
    tier: middletier
---
apiVersion: v1
kind: Service
metadata:
  name: {{ .APP }}-ui
  labels:
    app: {{ .APP }}-ui
    tier: frontend
  namespace: {{ .NAMESPACE }}
spec:
  type: NodePort
  ports:
  - port: 80
    protocol: TCP
    targetPort: 80
    nodePort: 30001
  selector:
    app: {{ .APP }}-ui
    tier: frontend
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ .APP }}-ui
  namespace: {{ .NAMESPACE }}
spec:
  selector:
    matchLabels:
      app: {{ .APP }}-ui
  replicas: {{ .UI_REPLICAS }}
  template:
    metadata:
      labels:
        app: {{ .APP }}-ui
        tier: frontend
    spec:
      containers:
      - name: {{ .APP }}-ui
        image: {{ .UI_IMAGE }}
        ports:
        - containerPort: 80
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ .REDIS_NAME }}
  namespace: {{ .NAMESPACE }}
spec:
  selector:
    matchLabels:
      app: {{ .REDIS_NAME }}
  replicas: {{ .REDIS_REPLICAS }}
  template:
    metadata:
      labels:
        app: {{ .REDIS_NAME }}
        tier: cache
    spec:
      containers:
      - name: {{ .REDIS_NAME }}
        image: {{ .REDIS_IMAGE }}
        ports:
        - containerPort: {{ .REDIS_PORT }}
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ .APP }}-db
  namespace: {{ .NAMESPACE }}
spec:
  selector:
    matchLabels:
      app: {{ .APP }}-db
  replicas: {{ .DB_REPLICAS }}
  template:
    metadata:
      labels:
        app: {{ .APP }}-db
        tier: backenddb
    spec:
      containers:
      - name: {{ .APP }}-db
        image: {{ .DB_IMAGE }}
        ports:
        - containerPort: {{ .DB_PORT }}
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ .APP }}-appserver
  namespace: {{ .NAMESPACE }}
spec:
  selector:
    matchLabels:
      app: {{ .APP }}-appserver
  replicas: {{ .APP_REPLICAS }}
  template:
    metadata:
      labels:
        app: {{ .APP }}-appserver
        tier: middletier
    spec:
      containers:
      - name: {{ .APP }}-appserver
        image: {{ .APP_IMAGE }}
        ports:
        - containerPort: {{ .APP_PORT }}
