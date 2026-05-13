# CONTRIBUTING.md

## Guía de Contribución - SmartStock Core API

### 📋 Flujo de Desarrollo

```
main (producción)
  ↑
develop (staging)
  ↑
feature/* (tus cambios)
```

### 1. Crear una Rama de Feature

```bash
# Actualizar develop
git checkout develop
git pull origin develop

# Crear rama
git checkout -b feature/my-feature
# o
git checkout -b fix/my-fix
# o
git checkout -b docs/my-docs
```

### 2. Hacer Cambios

```bash
# Instalar dependencias (si es necesario)
npm install

# Editar código
# Crear tests para los cambios
# Verificar que los tests pasen
npm run test

# Formatear código
npm run format

# Verificar linting
npm run lint:fix
```

### 3. Commit con Mensajes Claros

```bash
# Mensaje convencional (recomendado)
git commit -m "feat(users): add email validation"
git commit -m "fix(inventory): resolve stock update bug"
git commit -m "docs(api): update README with new endpoints"
git commit -m "refactor(auth): improve JWT handling"
git commit -m "test(products): add unit tests for service"
```

**Tipos permitidos**:
- `feat`: Nueva funcionalidad
- `fix`: Corrección de bug
- `docs`: Cambios en documentación
- `style`: Formateo, sin cambios de lógica
- `refactor`: Reestructuración sin cambios de comportamiento
- `perf`: Mejoras de performance
- `test`: Añadir o actualizar tests
- `chore`: Cambios en dependencias, config, etc.

### 4. Push y Pull Request

```bash
git push origin feature/my-feature
```

Luego:
1. Ir a GitHub
2. Crear Pull Request hacia `develop`
3. Rellenar el template de PR
4. Esperar que el CI/CD valide (automático)

### 5. Code Review

- Un mantenedor revisará los cambios
- Pueden solicitar cambios
- Una vez aprobado, se hace merge automático

### ✅ Requisitos antes de PR

- [ ] Código formateado: `npm run format`
- [ ] Linting aprobado: `npm run lint`
- [ ] Tests pasando: `npm run test:cov`
- [ ] Commits con mensajes claros
- [ ] PR description explica qué cambia y por qué

### 🧪 Testing

```bash
# Tests unitarios
npm run test

# Con coverage
npm run test:cov

# En modo watch (desarrollo)
npm run test:watch

# Debug
npm run test:debug
```

**Objetivo**: 80%+ de cobertura en archivos nuevos

### 📝 Estructura de Código

```typescript
// ✅ Correcto
import { Controller, Get } from '@nestjs/common';
import { UserService } from './user.service';

@Controller('users')
export class UserController {
  constructor(private readonly userService: UserService) {}

  @Get(':id')
  findOne(id: string) {
    return this.userService.findOne(id);
  }
}

// ❌ Incorrecto - lógica en controller
@Controller('users')
export class UserController {
  @Get(':id')
  findOne(id: string) {
    return db.query(`SELECT * FROM users WHERE id = ${id}`);
  }
}
```

### 🐛 Reportar Bugs

1. Verificar que no existe issue similar
2. Crear issue con:
   - Descripción clara
   - Pasos para reproducir
   - Comportamiento esperado
   - Comportamiento actual
   - Versiones (Node, npm, etc.)

### 💡 Sugerencias de Mejora

Abrir issue con tag `enhancement` y describir:
- Problema que resuelve
- Solución propuesta
- Alternativas consideradas

### 📚 Documentación

- Actualizar README si cambias:
  - Scripts
  - Variables de entorno
  - Dependencias
- Documentar funciones públicas con JSDoc
- Incluir ejemplos si es complejo

### 🚀 Deploy

El despliegue es automático:
- **Develop**: Cada PR aprobado a `develop` se despliega a staging
- **Main**: Cada commit a `main` se despliega a producción

No hagas push directo a `main` ni `develop` - siempre usa PRs.

---

**¿Preguntas?** Abre una discussion o contacta a un mantenedor.
