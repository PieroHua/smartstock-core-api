# SmartStock Core API - Setup Deployment Guide

## 🚀 Guía de Despliegue Completa

### Opción 1: Railway (Recomendado) ⭐

**Ventajas**:
- Setup más rápido (~5 minutos)
- Incluye PostgreSQL gratuito
- Dashboard intuitivo
- Despliegue automático desde GitHub
- $5/mes de crédito gratis

**Pasos**:

1. **Crear cuenta**:
   ```bash
   # Ir a https://railway.app
   # Sign up with GitHub
   ```

2. **Crear proyecto**:
   - New Project → GitHub Repo
   - Seleccionar `smartstock-core-api`
   - Autorizar acceso a GitHub

3. **Agregar servicio PostgreSQL**:
   ```bash
   # En el dashboard:
   # Add Service → PostgreSQL
   # Se configuran automáticamente las variables
   ```

4. **Configurar variables de entorno**:
   ```bash
   # En el dashboard > project > variables:
   NODE_ENV=production
   APP_PORT=3000
   JWT_SECRET=tu-clave-secreto-fuerte
   JWT_EXPIRATION=7d
   WHATSAPP_API_KEY=xxx (si aplica)
   ```

5. **Desplegar**:
   ```bash
   # El deploy es automático cuando haces push a main
   # Puedes ver logs en tiempo real en dashboard
   ```

6. **Agregar a GitHub Actions** (para CI/CD):
   ```bash
   # En GitHub:
   # Settings > Secrets and variables > Actions
   # Add: RAILWAY_TOKEN
   
   # Obtener token:
   # https://railway.app/account/tokens
   ```

**Resultado**: Tu API en `https://smartstock-core-api.railway.app`

---

### Opción 2: Render

**Ventajas**:
- 750 horas/mes gratis (nunca duerme)
- PostgreSQL incluido
- Interfaz clara

**Pasos**:

1. **Crear cuenta**:
   ```bash
   # https://render.com
   # Sign up with GitHub
   ```

2. **Crear Web Service**:
   - New → Web Service
   - Conectar repositorio
   - Build command: `npm install && npm run build`
   - Start command: `npm run start:prod`
   - Publish port: `3000`

3. **Crear PostgreSQL**:
   - New → PostgreSQL
   - Notar credenciales (aparecen en ENV automáticamente)

4. **Variables de entorno** (Render dashboard):
   ```
   NODE_ENV=production
   DATABASE_HOST=[auto-populated]
   DATABASE_PORT=[auto-populated]
   DATABASE_USER=[auto-populated]
   DATABASE_PASSWORD=[auto-populated]
   DATABASE_NAME=[auto-populated]
   APP_PORT=3000
   JWT_SECRET=tu-clave-fuerte
   ```

5. **Deploy webhook para GitHub Actions**:
   ```bash
   # En Render > Settings > Deploy Hook
   # Copiar URL
   
   # En GitHub:
   # Settings > Secrets > RENDER_DEPLOY_HOOK
   # Pegar URL
   ```

**Resultado**: Tu API en `https://smartstock-core-api.onrender.com`

---

### Opción 3: Fly.io

**Ventajas**:
- 3 máquinas compartidas gratis
- Global deployment (baja latencia)
- Escalado automático

**Pasos**:

```bash
# 1. Instalar CLI
npm install -g flyctl

# 2. Crear cuenta
flyctl auth signup

# 3. Inicializar app
flyctl launch

# Responder preguntas:
# - App name: smartstock-core-api
# - Region: usa (o tu región)
# - PostgreSQL: yes
# - Deploy now: yes

# 4. Configurar variables
flyctl secrets set NODE_ENV=production
flyctl secrets set JWT_SECRET=tu-clave-fuerte
flyctl secrets set APP_PORT=3000

# 5. Deploy
flyctl deploy

# 6. Ver logs
flyctl logs
```

**Para CI/CD automático**:
```bash
# Generar deploy token
flyctl tokens create deploy

# En GitHub Settings > Secrets:
FLY_API_TOKEN=token-aqui

# Crear .github/workflows/deploy-fly.yml
```

---

### Opción 4: Google Cloud Run (Serverless)

**Ventajas**:
- Pago por uso (muy barato si poca carga)
- 2M requests/mes gratis
- Escalado automático

**Pasos**:

```bash
# 1. Crear cuenta Google Cloud
# 2. Habilitar Cloud Run + Cloud SQL APIs
# 3. Instalar Google Cloud CLI
curl https://sdk.cloud.google.com | bash

# 4. Compilar imagen Docker
gcloud builds submit --tag gcr.io/PROJECT_ID/smartstock-core-api

# 5. Crear Cloud SQL PostgreSQL
gcloud sql instances create smartstock-db \
  --database-version=POSTGRES_16 \
  --tier=db-f1-micro

# 6. Desplegar a Cloud Run
gcloud run deploy smartstock-core-api \
  --image gcr.io/PROJECT_ID/smartstock-core-api \
  --platform managed \
  --memory 512Mi \
  --set-env-vars NODE_ENV=production \
  --add-cloudsql-instances PROJECT_ID:REGION:smartstock-db

# 7. Ver URL del servicio
gcloud run services list
```

---

### Opción 5: Docker en tu propio servidor VPS

Si tienes un servidor Ubuntu/Debian:

```bash
# 1. En tu servidor
sudo apt update && sudo apt install docker.io docker-compose

# 2. Clonar repo
git clone https://github.com/tu-usuario/smartstock-core-api.git
cd smartstock-core-api

# 3. Crear .env
cp .env.example .env
# Editar con tus variables

# 4. Levantar servicios
docker-compose up -d

# 5. Ver logs
docker-compose logs -f api

# 6. Usar Nginx como reverse proxy
sudo apt install nginx
# Configurar nginx.conf...
```

**Servidores baratos**:
- Hetzner: ~3€/mes
- DigitalOcean: ~5€/mes
- Linode: ~5€/mes

---

## 🔄 GitHub Actions Setup Automático

Una vez elegida tu plataforma, actualizar `.github/workflows/deploy.yml`:

### Para Railway:
```yaml
- name: Deploy to Railway
  run: |
    npm install -g @railway/cli
    railway up --service api
  env:
    RAILWAY_TOKEN: ${{ secrets.RAILWAY_TOKEN }}
```

### Para Render:
```yaml
- name: Deploy to Render
  run: curl -X POST ${{ secrets.RENDER_DEPLOY_HOOK }}
```

### Para Fly.io:
```yaml
- name: Deploy to Fly.io
  uses: superfly/flyctl-actions@master
  env:
    FLY_API_TOKEN: ${{ secrets.FLY_API_TOKEN }}
  with:
    args: "deploy"
```

---

## 📊 Comparativa de Opciones

| Plataforma | Gratis | Setup | Escalado | BD Incluida | Recomendación |
|-----------|--------|-------|----------|------------|---------------|
| Railway   | $5/mes | ⭐⭐⭐  | Automático | Sí | **MEJOR** |
| Render    | 750h   | ⭐⭐⭐  | Automático | Sí | **Buena opción** |
| Fly.io    | 3 apps | ⭐⭐  | Automático | Pago | Buena escalabilidad |
| GCP Run   | 2M req | ⭐⭐  | Serverless | Pago | Bajo costo dinámico |
| VPS       | Pago   | ⭐   | Manual | Tú | Máximo control |

---

## 🔐 Variables de Entorno en Producción

**IMPORTANTE**: Nunca commitear `.env` con valores reales.

Variables recomendadas para producción:

```bash
NODE_ENV=production
APP_PORT=3000
APP_NAME=SmartStock Core API

# Database
DATABASE_HOST=[tuPlatforma]
DATABASE_PORT=5432
DATABASE_USER=postgres
DATABASE_PASSWORD=[GenerarClaveSegura]
DATABASE_NAME=smartstock

# JWT (Generar con: node -e "console.log(require('crypto').randomBytes(32).toString('hex'))")
JWT_SECRET=[64-char-hex-string]
JWT_EXPIRATION=7d

# Logging
LOG_LEVEL=warn

# WhatsApp (si aplica)
WHATSAPP_API_KEY=[api-key]
```

---

## 🧪 Verificar Deploy

```bash
# Test endpoint health
curl https://tu-api.railway.app/health

# Debe retornar:
# {
#   "status": "ok",
#   "timestamp": "2026-05-12T..."
# }

# Test conexión a BD
# Implementar endpoint que consulte BD
```

---

## 🆘 Troubleshooting

### Railway: Build failure
```bash
# Ver logs: Railway Dashboard > Deployments > Logs
# Común: Variables de entorno faltantes
```

### Render: Application crashed
```bash
# Ir a Logs > Runtime
# Verificar DATABASE_URL si existe
```

### GCP: Out of quota
```bash
# Reducir memory o usar Cloud Run with always-allocated compute
```

---

**¿Necesitas ayuda?** Abre un issue en el repo.
