# kubetpl:syntax:go-template

---
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: {{ .DB }}-storage
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: {{ .DB_STORAGE }}
---
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    name: {{ .DB }}
  name: {{ .DB }}
spec:
  replicas: {{ .DB_REPLICAS }}
  selector:
    matchLabels:
      name: {{ .DB }}
  template:
    metadata:
      labels:
        name: {{ .DB }}
    spec:
      containers:
      - image: {{ .DB }}
        name: {{ .DB }}
        ports:
        - name: {{ .DB }}
          containerPort: {{ .DB_PORT }}
        volumeMounts:
          - name: {{ .DB }}-db
            mountPath: /data/db
      volumes:
        - name: {{ .DB }}-db
          persistentVolumeClaim:
            claimName: {{ .DB }}-storage
---
apiVersion: v1
kind: Service
metadata:
  name: {{ .APP }}
  labels:
    name: {{ .APP }}
spec:
  type: LoadBalancer
  ports:
    - port: 80
      targetPort: 8080
      protocol: TCP
  selector:
    name: {{ .APP }}
---
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    name: {{ .APP }}
  name: {{ .APP }}
spec:
  replicas: {{ .APP_REPLICAS }}
  selector:
    matchLabels:
        name: {{ .APP }}
  template:
    metadata:
      labels:
        name: {{ .APP }}
    spec:
      containers:
      - image: {{ .APP_IMAGE }} 
        name: {{ .APP }}
        ports:
        - containerPort: 8080
          name: http-server
