# Arquitectura de SmartStock Core API

## 🏗️ Estructura General

```
┌─────────────────────────────────────┐
│      NestJS Application             │
├─────────────────────────────────────┤
│  Controllers (HTTP endpoints)        │
│      ↓                              │
│  Guards (Autenticación)             │
│      ↓                              │
│  Services (Lógica de negocio)       │
│      ↓                              │
│  Repositories (TypeORM)             │
│      ↓                              │
│  PostgreSQL Database                │
└─────────────────────────────────────┘
```

## 📁 Organización por Módulos

Cada módulo es independiente y contiene todo lo necesario:

```
src/modules/users/
├── entities/              # Modelos de BD (TypeORM)
│   └── user.entity.ts
├── dtos/                  # Data Transfer Objects (validación)
│   ├── create-user.dto.ts
│   └── update-user.dto.ts
├── repositories/          # Acceso a datos
│   └── user.repository.ts
├── services/              # Lógica de negocio
│   └── user.service.ts
├── controllers/           # Endpoints HTTP
│   └── user.controller.ts
├── guards/                # Autenticación/Autorización
│   └── auth.guard.ts
├── decorators/            # Decoradores personalizados
│   └── current-user.decorator.ts
├── tests/                 # Tests unitarios
│   ├── user.service.spec.ts
│   └── user.controller.spec.ts
└── users.module.ts        # Módulo NestJS
```

## 🔄 Flujo de una Solicitud

```
HTTP Request
    ↓
Router (main.ts)
    ↓
Controller.handler()
    ↓
Guard (verifica JWT)
    ↓
Validar DTO (class-validator)
    ↓
Service.businessLogic()
    ↓
Repository.database()
    ↓
TypeORM (Query Builder)
    ↓
PostgreSQL
    ↓
Response (DTO)
    ↓
HTTP Response
```

## 🔐 Capas de Seguridad

### 1. Autenticación (Guards)
```typescript
@UseGuards(AuthGuard)
@Controller('users')
export class UserController {
  // Solo se ejecuta si el JWT es válido
}
```

### 2. Validación de Datos (DTOs)
```typescript
// DTOs con class-validator
export class CreateUserDto {
  @IsEmail()
  email: string;

  @MinLength(8)
  password: string;
}
```

### 3. Autorización (Roles)
```typescript
@UseGuards(AuthGuard, RolesGuard)
@Roles('admin')
@Delete(':id')
deleteUser(@Param('id') id: string) {
  // Solo admin puede ejecutar
}
```

## 💾 Base de Datos

### TypeORM + PostgreSQL

```typescript
// user.entity.ts
@Entity('users')
export class User {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ unique: true })
  email: string;

  @Column({ select: false })  // No incluir en SELECTs por defecto
  password: string;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;
}
```

### Migraciones
```bash
npm run db:migrate:create -- -n CreateUsersTable
npm run db:migrate:run
npm run db:migrate:revert
```

## 🧪 Testing Strategy

### Unit Tests (80% cobertura objetivo)
```typescript
describe('UserService', () => {
  let service: UserService;
  let repository: UserRepository;

  beforeEach(async () => {
    const module = await Test.createTestingModule({
      providers: [UserService, { provide: UserRepository, useValue: mockRepository }],
    }).compile();

    service = module.get(UserService);
    repository = module.get(UserRepository);
  });

  it('should create user with email', async () => {
    const dto = { email: 'test@example.com', password: '123456' };
    const result = await service.create(dto);
    expect(result.email).toBe(dto.email);
  });
});
```

### E2E Tests
```typescript
describe('Users (e2e)', () => {
  let app: INestApplication;

  beforeEach(async () => {
    const module = await Test.createTestingModule({
      imports: [AppModule],
    }).compile();
    app = module.createNestApplication();
  });

  it('GET /users/:id should return user', () => {
    return request(app.getHttpServer())
      .get('/users/123')
      .expect(200);
  });
});
```

## 🚀 Performance

### Optimizaciones Implementadas

1. **Lazy Loading de Módulos**
```typescript
@Module({
  imports: [
    ConfigModule.forRoot(),
    TypeOrmModule.forRootAsync({...}),
    UsersModule,  // Solo carga cuando se necesita
  ],
})
```

2. **Query Optimization**
```typescript
// Evitar N+1 queries
this.repository
  .createQueryBuilder('user')
  .leftJoinAndSelect('user.posts', 'posts')
  .getMany();
```

3. **Caching** (opcional, future)
```typescript
@Cacheable()
findAll() {
  return this.repository.find();
}
```

## 📝 Configuración

### Manejo de Configuración
```typescript
// config/database.ts
import { registerAs } from '@nestjs/config';

export default registerAs('database', () => ({
  host: process.env.DATABASE_HOST,
  port: parseInt(process.env.DATABASE_PORT),
  username: process.env.DATABASE_USER,
  password: process.env.DATABASE_PASSWORD,
  database: process.env.DATABASE_NAME,
}));
```

```typescript
// app.module.ts
TypeOrmModule.forRootAsync({
  imports: [ConfigModule],
  inject: [ConfigService],
  useFactory: (configService: ConfigService) => ({
    ...configService.get('database'),
  }),
})
```

## 🔗 Patrones de Comunicación

### Dentro de la Aplicación
- **Services**: Inyección de dependencias
- **Database**: TypeORM repositories

### Salida Externa
- **HTTP REST**: Controllers
- **WhatsApp** (futuro): Custom service
- **Webhooks**: Dedicated controllers

## 📊 Monitoreo y Logging

```typescript
// common/filters/http-exception.filter.ts
@Catch(HttpException)
export class HttpExceptionFilter implements ExceptionFilter {
  catch(exception: HttpException, host: ArgumentsHost) {
    const ctx = host.switchToHttp();
    const response = ctx.getResponse();
    const request = ctx.getRequest();

    response.status(exception.getStatus()).json({
      statusCode: exception.getStatus(),
      timestamp: new Date().toISOString(),
      path: request.url,
    });
  }
}
```

## 🔄 CI/CD Pipeline

```
PR to develop
    ↓
├─ ESLint
├─ Prettier
├─ Unit Tests
├─ Security Audit
├─ Docker Build
└─ E2E Tests
    ↓
✅ Quality Gate
    ↓
Merge to develop
    ↓
Deploy to Staging
    ↓
PR to main (manual)
    ↓
Deploy to Production
```

## 📚 Stack Tecnológico

| Capa | Tecnología | Versión |
|------|-----------|---------|
| Runtime | Node.js | 20.x |
| Framework | NestJS | 10.x |
| ORM | TypeORM | 0.3.x |
| BD | PostgreSQL | 16 |
| Validación | class-validator | 0.14.x |
| Testing | Jest | 29.x |
| Linting | ESLint | 8.x |
| Formateo | Prettier | 3.x |
| Containers | Docker | latest |

## 🎯 Próximas Mejoras

- [ ] Swagger/OpenAPI documentation
- [ ] Rate limiting
- [ ] Caching (Redis)
- [ ] Message Queue (Bull)
- [ ] Logging centralizado (Winston)
- [ ] Monitoring (Prometheus/Grafana)
- [ ] GraphQL (alternativa a REST)

---

**Contribución**: Mantener esta arquitectura es responsabilidad de todos. Si encuentras mejoras, abre un issue.
