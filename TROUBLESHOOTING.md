# Troubleshooting Guide

## Problemas Comunes y Soluciones

### 1. Error: "Cannot find module '@nestjs/common'"

**Problema**: Módulos no instalados
```bash
Error: Cannot find module '@nestjs/common'
```

**Solución**:
```bash
npm install
npm ci  # Si necesitas instalación exacta
```

---

### 2. Error: "connect ECONNREFUSED 127.0.0.1:5432"

**Problema**: PostgreSQL no está corriendo

**Soluciones**:

#### Opción A: Con Docker (recomendado)
```bash
docker-compose up postgres
# Esperar 10 segundos para que inicie
```

#### Opción B: PostgreSQL local
```bash
# En Windows (PowerShell)
Get-Service postgresql* | Start-Service

# En Linux
sudo systemctl start postgresql

# En macOS (Homebrew)
brew services start postgresql
```

---

### 3. Error: "database "smartstock" does not exist"

**Problema**: BD no creada

**Solución**:
```bash
# En PostgreSQL CLI
psql -U postgres
CREATE DATABASE smartstock;
\q

# Luego ejecutar migraciones
npm run db:migrate:run
```

---

### 4. Error: "Port 3000 already in use"

**Problema**: Otro proceso usando el puerto

**Solución**:

```bash
# Windows - encontrar y matar proceso
netstat -ano | findstr :3000
taskkill /PID <PID> /F

# Linux/Mac
lsof -ti:3000 | xargs kill -9
```

O cambiar puerto en `.env`:
```env
APP_PORT=3001
```

---

### 5. Tests faillng: "JestNotFoundError"

**Problema**: Jest no configurado correctamente

**Solución**:
```bash
npm install --save-dev jest ts-jest @types/jest

# Verificar jest.config.js existe
npm run test
```

---

### 6. Error: "Unexpected end of JSON input"

**Problema**: `package-lock.json` corrupto

**Solución**:
```bash
# Limpiar cache
npm cache clean --force

# Reinstalar
rm -rf node_modules package-lock.json
npm install
```

---

### 7. Error en Deploy Railway: "Build failed"

**Síntomas**:
```
Error: Deployment failed
Build exited with code 1
```

**Soluciones**:

1. **Revisar logs**:
   - Railway Dashboard → Deployments → View logs

2. **Verificar variables de entorno**:
   - Todas las variables en `.env.example` deben estar configuradas

3. **Verificar Dockerfile**:
   ```bash
   docker build .
   ```

4. **Limpiar caché**:
   - Railway Dashboard → Settings → Purge Build Cache

---

### 8. Error: "Cannot read property 'getRepository'"

**Problema**: TypeORM no inicializado

**Solución**: Verificar que `AppModule` importa `TypeOrmModule`:

```typescript
@Module({
  imports: [
    TypeOrmModule.forRootAsync({...}),
    // otros módulos
  ],
})
export class AppModule {}
```

---

### 9. Linting errors: "Unexpected any"

**Problema**: TypeScript strict mode

**Solución** (2 opciones):

A. Corregir el código:
```typescript
// ❌ Evitar
function process(data: any) {}

// ✅ Usar tipos específicos
function process(data: User[]) {}
```

B. Relajar reglas en `.eslintrc.json` (NO recomendado):
```json
{
  "rules": {
    "@typescript-eslint/no-explicit-any": "off"
  }
}
```

---

### 10. Docker: "permission denied"

**Problema**: Permisos de Docker en Linux

**Solución**:
```bash
# Agregar usuario al grupo docker
sudo usermod -aG docker $USER

# Aplicar cambios (sin reiniciar)
newgrp docker

# Verificar
docker ps
```

---

### 11. "FATAL: password authentication failed"

**Problema**: Credenciales PostgreSQL incorrectas

**Solución**:
```bash
# Verificar variables en .env
cat .env | grep DATABASE_

# Si usas Docker, verificar en docker-compose.yml
# Deben coincidir las credenciales

# Reiniciar PostgreSQL
docker-compose down postgres
docker-compose up postgres
```

---

### 12. Hot-reload no funciona en desarrollo

**Problema**: Cambios en código no se reflejan

**Solución**:
```bash
# Usar el comando correcto
npm run start:dev

# NO usar:
npm run start  # No recarga cambios

# Si aún no funciona:
npm install
npm run start:dev
```

---

### 13. "EACCES: permission denied" en npm install

**Problema**: Permisos globales npm

**Solución**:
```bash
# Opción A: Cambiar permisos de npm
mkdir ~/.npm-global
npm config set prefix '~/.npm-global'
export PATH=~/.npm-global/bin:$PATH

# Opción B: Usar sudo (NO recomendado)
sudo npm install -g

# Opción C: Usar nvm (recomendado)
curl https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
nvm install 20
```

---

### 14. Error: "ENOENT: no such file or directory"

**Problema**: Archivos/directorios faltantes

**Solución**:
```bash
# Verificar estructura
ls -la src/

# Si falta algo, recrear desde template
mkdir -p src/{common,config,database,modules}
```

---

### 15. E2E tests falla con timeout

**Problema**: Conexión a BD lenta

**Solución** en `test/jest-e2e.json`:
```json
{
  "testTimeout": 30000  // Aumentar a 30 segundos
}
```

---

## 🆘 Debugging Avanzado

### Habilitar logs de debug
```bash
# En .env
LOG_LEVEL=debug

# O ejecutar con debug
npm run start:debug
```

### Verificar estructura de carpetas
```bash
# Mostrar árbol del proyecto
tree -L 3 -I 'node_modules' -I '.git'

# O con ls
find src -type f -name "*.ts" | head -20
```

### Usar VS Code Debugger
```json
// .vscode/launch.json
{
  "version": "0.2.0",
  "configurations": [
    {
      "type": "node",
      "request": "launch",
      "name": "Debug NestJS",
      "program": "${workspaceFolder}/node_modules/@nestjs/cli/bin/nest.js",
      "args": ["start", "--debug", "--watch"],
      "cwd": "${workspaceFolder}"
    }
  ]
}
```

---

## 📞 Pedir Ayuda

Si el problema persiste:

1. **Revisar logs completos**:
   ```bash
   npm run start:dev 2>&1 | tee debug.log
   ```

2. **Crear issue en GitHub** con:
   - Error exacto (copiar/pegar)
   - Pasos para reproducir
   - Salida de `node -v && npm -v`
   - Sistema operativo

3. **Contactar al equipo**:
   - Email: equipo@smartstock.ai
   - Discord: [enlace a servidor]

---

**Última actualización**: Mayo 12, 2026
