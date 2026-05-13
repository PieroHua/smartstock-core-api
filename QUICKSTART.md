# 🚀 QUICK START - SmartStock Core API

## Inicio en 2 minutos

### Opción 1: Con Docker (Recomendado)
```bash
cd smartstock-core-api

# Levantar todo (API + PostgreSQL)
docker-compose up

# El API está en: http://localhost:3000/health
# BD está en: localhost:5432
```

### Opción 2: Local (Sin Docker)
```bash
npm install
cp .env.example .env
npm run start:dev

# El API está en: http://localhost:3000/health
# ⚠️ PostgreSQL debe estar corriendo localmente en 5432
```

---

## Verificar que funciona

```bash
# Test health endpoint
curl http://localhost:3000/health

# Debería responder:
# {"status":"ok","timestamp":"2026-05-12T..."}
```

---

## Próximo paso: Crear tu primer módulo

1. **Leer ARCHITECTURE.md** (entiende la estructura)
2. **Copiar estructura de health/ a users/** 
3. **Modificar DTOs, Entity, Service, Controller**
4. **Escribir tests** (src/modules/users/tests/)
5. **Hacer commit y PR a develop**

```bash
git checkout -b feature/users-module
# ... code ...
npm run lint:fix
npm run test
git commit -m "feat(users): add user module"
git push origin feature/users-module
# Crear PR en GitHub
```

---

## 📚 Documentación por Rol

**👨‍💻 Desarrollador Backend**:
1. [README.md](./README.md) - Scripts y setup
2. [ARCHITECTURE.md](./ARCHITECTURE.md) - Cómo se estructura
3. [CONTRIBUTING.md](./CONTRIBUTING.md) - Cómo contribuir

**🚀 DevOps/Infrastructure**:
1. [DEPLOYMENT.md](./DEPLOYMENT.md) - Opciones de deploy
2. [Dockerfile](./Dockerfile) - Imagen Docker
3. [docker-compose.yml](./docker-compose.yml) - Local stack

**🔧 Tech Lead**:
1. [ARCHITECTURE.md](./ARCHITECTURE.md) - Visión técnica
2. [ROADMAP.md](./ROADMAP.md) - Plan de desarrollo
3. [.github/workflows/](./github/workflows/) - CI/CD pipelines

**🆘 En problemas**:
1. [TROUBLESHOOTING.md](./TROUBLESHOOTING.md) - Soluciones comunes

---

## Pipeline Automático

Cada PR a `develop` ejecuta:
```
✅ ESLint (code quality)
✅ Tests (with coverage)
✅ Security audit
✅ Docker build
✅ E2E tests
✅ Quality gate
└→ Deploy automático en merge a develop
```

No necesitas hacer nada manualmente. Simplemente:
```bash
git push origin feature/mi-feature
# → GitHub Actions valida todo automáticamente
# → Si todo passa, haz PR y merge
```

---

## Desplegar a Producción

Elige una opción en [DEPLOYMENT.md](./DEPLOYMENT.md):

### ⭐ Railway (Recomendado)
```bash
# 1. Crear cuenta en https://railway.app
# 2. Conectar GitHub
# 3. Agregar PostgreSQL
# 4. Push a main → Deploy automático
```

### Render / Fly.io / GCP Run
Ver guía detallada en [DEPLOYMENT.md](./DEPLOYMENT.md)

---

## 🎯 Checklist Inicial

- [ ] `npm install` ejecutado sin errores
- [ ] `docker-compose up` funciona
- [ ] `curl http://localhost:3000/health` retorna ok
- [ ] `npm run test` pasa todos los tests
- [ ] `npm run lint` sin errores
- [ ] `.env` creado desde `.env.example`
- [ ] Leído [README.md](./README.md)

---

## Comandos Más Usados

```bash
# Desarrollo
npm run start:dev              # Iniciar con hot-reload
npm run test                   # Tests
npm run lint:fix               # Corregir linting

# Docker
docker-compose up              # Levantar servicios
docker-compose down            # Parar servicios
docker-compose logs -f api     # Ver logs en vivo

# Base de datos
npm run db:migrate:create      # Nueva migración
npm run db:migrate:run         # Ejecutar migraciones

# Build/Deploy
npm run build                  # Compilar
docker build .                 # Compilar imagen Docker
```

---

## Variables de Entorno Críticas

En `.env` (mínimo):
```env
NODE_ENV=development
DATABASE_HOST=postgres          # Si usas Docker
DATABASE_USER=postgres
DATABASE_PASSWORD=postgres
DATABASE_NAME=smartstock
JWT_SECRET=tu-clave-secreto
APP_PORT=3000
```

---

## 🎓 Stack Tecnológico

| Componente | Tecnología |
|-----------|-----------|
| Runtime | Node.js 20.x |
| Framework | NestJS 10.x |
| BD | PostgreSQL 16 |
| ORM | TypeORM 0.3.x |
| Testing | Jest |
| Container | Docker |

---

## Estructura de Carpetas

```
src/modules/          ← Aquí creas tu lógica
  ├── users/
  ├── inventory/
  └── orders/

src/common/           ← Código compartido
  ├── decorators/
  ├── filters/
  └── guards/

.github/workflows/    ← CI/CD automático
  ├── ci-develop.yml
  └── deploy.yml
```

---

## 📞 Ayuda Rápida

| Problema | Solución |
|----------|----------|
| "Port 3000 already in use" | Cambiar APP_PORT en .env |
| "Cannot connect to postgres" | `docker-compose up postgres` |
| Tests fallando | `npm run test:watch` y revisar errores |
| Linting errors | `npm run lint:fix` |
| "Cannot find module" | `npm install` |
| Deploy failing | Ver [DEPLOYMENT.md](./DEPLOYMENT.md) |

---

## ✨ Ahora a Codificar

```bash
# 1. Actualizar .env
nano .env

# 2. Iniciar dev server
docker-compose up &
npm run start:dev

# 3. Abrir http://localhost:3000/health en navegador
# Deberías ver: {"status":"ok","timestamp":"..."}

# 4. Crear tu primer módulo
git checkout -b feature/users
# ... implementar ...

# 5. Push y crear PR
git push origin feature/users
# → Ir a GitHub y crear PR a develop
```

---

**¡Bienvenido! 🎉**

Tienes todo para empezar. Lee los documentos según necesites.

**Cualquier duda**: Revisa [TROUBLESHOOTING.md](./TROUBLESHOOTING.md)
