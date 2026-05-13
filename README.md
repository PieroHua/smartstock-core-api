# SmartStock Core API 🚀

Backend principal de **SmartStock AI**. Construido con **NestJS** y **PostgreSQL**. Orquesta la gestión de usuarios, el CRUD de inventario y la automatización de pedidos vía WhatsApp.

## 📋 Requisitos Previos

- **Node.js**: v20.x o superior
- **npm**: v10.x o superior
- **Docker**: (Opcional, para desarrollo con Docker)
- **PostgreSQL**: v16 (Si no usas Docker)

## 🚀 Inicio Rápido

### Opción 1: Con Docker (Recomendado)

```bash
# Clonar repositorio
git clone <repository-url>
cd smartstock-core-api

# Levantar servicios
docker-compose up -d

# El API estará disponible en http://localhost:3000
# Base de datos en localhost:5432
```

### Opción 2: Instalación Local

```bash
# Instalar dependencias
npm install

# Configurar variables de entorno
cp .env.example .env

# Editar .env con tus valores
nano .env

# Ejecutar migraciones (si existen)
npm run db:migrate:run

# Iniciar en desarrollo
npm run start:dev

# Iniciar en producción
npm run build
npm run start:prod
```

## 📁 Estructura del Proyecto

```
smartstock-core-api/
├── src/
│   ├── main.ts                 # Punto de entrada
│   ├── app.module.ts           # Módulo raíz
│   ├── modules/                # Módulos de negocio
│   │   └── health/             # Health check (ejemplo)
│   ├── common/
│   │   ├── decorators/         # Decoradores personalizados
│   │   ├── filters/            # Filtros de excepciones
│   │   └── guards/             # Guards de autenticación
│   ├── config/                 # Configuración de la app
│   └── database/
│       └── migrations/         # Migraciones de TypeORM
├── test/                       # Tests E2E
├── .github/workflows/          # Pipelines CI/CD
├── Dockerfile                  # Imagen Docker multi-stage
├── docker-compose.yml          # Orquestación local
├── package.json
└── tsconfig.json
```

## 🛠️ Scripts Disponibles

```bash
# Desarrollo
npm run start:dev              # Iniciar con hot-reload
npm run start:debug            # Debug mode

# Compilación
npm run build                  # Compilar para producción
npm run format                 # Formatear código (Prettier)
npm run lint                   # Analizar código (ESLint)
npm run lint:fix               # Corregir errores de linting

# Testing
npm run test                   # Ejecutar tests unitarios
npm run test:watch             # Tests en modo watch
npm run test:cov               # Tests con coverage
npm run test:debug             # Debug tests

# Base de datos
npm run db:migrate:create      # Crear nueva migración
npm run db:migrate:run         # Ejecutar migraciones
npm run db:migrate:revert      # Revertir última migración
```

## 🔐 Variables de Entorno

Crear archivo `.env` basado en `.env.example`:

```env
# Base de datos
DATABASE_HOST=localhost
DATABASE_PORT=5432
DATABASE_USER=postgres
DATABASE_PASSWORD=your_password
DATABASE_NAME=smartstock

# Aplicación
NODE_ENV=development
APP_PORT=3000
APP_NAME=SmartStock Core API

# JWT
JWT_SECRET=your-secret-key-change-in-production
JWT_EXPIRATION=7d

# WhatsApp (Opcional)
WHATSAPP_API_KEY=your-api-key
WHATSAPP_PHONE_NUMBER=+1234567890

# Logging
LOG_LEVEL=debug
```

## 📊 CI/CD Pipeline

### Flujo en Pull Request a `develop`

El pipeline ejecuta automáticamente:

1. **Code Quality**: ESLint, Prettier, análisis de código
2. **Security Audit**: Verificación de dependencias vulnerables
3. **Unit Tests**: Jest con coverage
4. **Build**: Compilación de TypeScript
5. **Docker Build**: Construcción de imagen Docker
6. **E2E Tests**: Tests de integración con PostgreSQL
7. **Quality Gate**: Validación de todos los checks

**Status en PR**: Se añade un comentario automático con los resultados ✅/❌

### Flujo en Push a `main`

Deploya automáticamente la aplicación a:
- Docker Hub (si están configuradas las credenciales)
- Railway o Render (según la configuración)

## 🚀 Opciones de Despliegue GRATUITAS

### 1. **Railway** (Recomendado) ⭐
**Características**:
- 5GB RAM, almacenamiento unlimited por mes
- PostgreSQL incluido
- Despliegue automático desde GitHub
- Variables de entorno gestionadas en dashboard
- Logs en tiempo real

**Configuración**:
```bash
# 1. Crear cuenta en https://railway.app
# 2. Conectar repositorio GitHub
# 3. Añadir servicio PostgreSQL
# 4. Definir variables de entorno
# 5. El despliegue es automático en cada push a main
```

**Secrets para GitHub**:
```
RAILWAY_TOKEN: Token generado en railway.app/account/tokens
```

### 2. **Render** 
**Características**:
- 750 horas/mes gratis (servidor nunca se duerme)
- PostgreSQL gratuito
- SSL automático
- Despliegue desde Git

**Configuración**:
```bash
# 1. Crear cuenta en https://render.com
# 2. Conectar GitHub
# 3. Crear Web Service + PostgreSQL
# 4. Despliegue automático en push
```

**Secrets para GitHub**:
```
RENDER_DEPLOY_HOOK: URL del webhook (Render > Deploy)
```

### 3. **Fly.io**
**Características**:
- 3 máquinas compartidas gratis
- PostgreSQL incluido
- Global deployment
- Buena latencia

**Deploy Manual**:
```bash
npm install -g flyctl
flyctl launch
flyctl deploy
```

### 4. **Heroku** (Plan Básico)
⚠️ Ya no es completamente gratis, pero ofrece plan de $7/mes

### 5. **Google Cloud Run** (Serverless)
**Características**:
- 2 millones de solicitudes/mes gratis
- Pago por uso
- Sin servidor para mantener

```bash
# Requiere Cloud SQL para PostgreSQL
# Buena opción si tu carga es variable
```

---

## 📝 Crear Nuevos Módulos

Estructura recomendada para cada módulo:

```
src/modules/example/
├── entities/
│   └── example.entity.ts        # Entidad TypeORM
├── dto/
│   ├── create-example.dto.ts
│   └── update-example.dto.ts
├── example.controller.ts         # Rutas HTTP
├── example.service.ts            # Lógica de negocio
├── example.module.ts             # Módulo NestJS
└── example.controller.spec.ts    # Tests
```

**Ejemplo básico**:
```typescript
// example.controller.ts
import { Controller, Get, Post, Body } from '@nestjs/common';
import { ExampleService } from './example.service';

@Controller('examples')
export class ExampleController {
  constructor(private readonly exampleService: ExampleService) {}

  @Get()
  findAll() {
    return this.exampleService.findAll();
  }

  @Post()
  create(@Body() dto: CreateExampleDto) {
    return this.exampleService.create(dto);
  }
}
```

## 🔍 Mejores Prácticas

- ✅ Usar TypeORM decorators para entidades
- ✅ Validar DTOs con class-validator
- ✅ Implementar Guards para autenticación
- ✅ Usar Filters para manejo de errores
- ✅ Escribir tests unitarios (>80% coverage)
- ✅ Documentar APIs con Swagger (próxima tarea)

## 📚 Recursos

- [NestJS Docs](https://docs.nestjs.com)
- [TypeORM Docs](https://typeorm.io)
- [Railway Docs](https://docs.railway.app)
- [Render Docs](https://render.com/docs)

## 🤝 Contribuciones

1. Crear rama desde `develop`
2. Implementar cambios
3. Ejecutar tests: `npm run test:cov`
4. Hacer commit con mensajes claros
5. Push y crear Pull Request
6. El CI/CD valida automáticamente

## 📄 Licencia

MIT

---

**¿Preguntas o Sugerencias?** Abre un Issue en el repositorio.
